# Angular HttpClient Instrumentation

If you choose to use Angular HttpClient over the Capacitor HTTP API, you will have to add some extra instrumentation code into your app.

1. Create a new custom interceptor to intercept incoming or outgoing HTTP requests. The interceptor should follow these steps:
   * Override the interceptor method of the `HttpInterceptor` interface.
   * Only intercept the request if it is on a mobile platform.
   * Generate distributed tracing headers and add the headers into the http request.
   * Calculate the sent/received bytes of the request.
   * Manually record the http request to the agent.
```
import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpResponse,
  HttpErrorResponse,
} from '@angular/common/http';
import {
  Observable,
  tap,
  from,
  finalize,
  lastValueFrom,
} from 'rxjs';
import { NewRelicCapacitorPlugin } from '@newrelic/newrelic-capacitor-plugin';
import { Capacitor } from '@capacitor/core';

@Injectable()
export class CustomInterceptor implements HttpInterceptor {
  sentBytes: number = 0;
  receivedBytes: number = 0;

  // Generate headers needed for distributed tracing
  async getDTHeaders(): Promise<object> {
    let result =
      await NewRelicCapacitorPlugin.generateDistributedTracingHeaders();
    return result;
  }

  calculateSentBytes(req: HttpRequest<any>): number {
    const headerBytes = JSON.stringify(req.headers).length;
    const bodyBytes = req.body ? JSON.stringify(req.body).length : 0;

    return headerBytes + bodyBytes;
  }
  calculateReceivedBytes(res: HttpResponse<any>): number {
    const headerBytes = JSON.stringify(res.headers).length;
    const bodyBytes = res.body ? JSON.stringify(res.body).length : 0;

    return headerBytes + bodyBytes;
  }

  constructor() {}
  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    return from(this.handleAsyncHeaders(request, next));
  }

  private async handleAsyncHeaders(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Promise<HttpEvent<any>> {
    // The New Relic Capacitor plugin only works on mobile devices.
    if (Capacitor.isNativePlatform()) {
      let httpResponse: HttpResponse<any>;
      const startTime = Date.now();

      const dtHeaders = await this.getDTHeaders();
      // We add only these headers to the request, the rest are for noticeHttpTransaction
      const allowedHeaders = ['traceparent', 'tracestate', 'newrelic'];
      const filteredHeaders: { [key: string]: string } = {};
      Object.entries(dtHeaders).forEach(entry => {
        const [key, value] = entry;
        if (allowedHeaders.includes(key)) {
          filteredHeaders[key] = value;
        }
      })

      // Create a new request with the new headers
      const clonedRequest = request.clone({
        setHeaders: filteredHeaders,
      });

      this.sentBytes += this.calculateSentBytes(clonedRequest);

      return lastValueFrom(
        next.handle(clonedRequest).pipe(
          tap({
            next: (event) => {
              if (event instanceof HttpResponse) {
                httpResponse = event;
                this.receivedBytes = this.calculateReceivedBytes(httpResponse);
              }
            },
            error: (error) => {
              const endTime = Date.now();
              if (error instanceof HttpErrorResponse) {
                NewRelicCapacitorPlugin.noticeHttpTransaction({
                  url: error.url || '',
                  method: clonedRequest.method,
                  status: error.status,
                  startTime: startTime,
                  endTime: endTime,
                  bytesSent: this.sentBytes,
                  bytesReceived: this.receivedBytes,
                  body: error.error.text || '',
                  traceAttributes: dtHeaders,
                });
              } else {
                NewRelicCapacitorPlugin.recordError({
                  name: error.name,
                  message: error.message,
                  stack: error.stack,
                  isFatal: false,
                });
              }
            },
          }),
          finalize(() => {
            const endTime = Date.now();
            // Notice the http transaction with the appropriate data and trace attributes.
            NewRelicCapacitorPlugin.noticeHttpTransaction({
              url: clonedRequest.url ? clonedRequest.url : '',
              method: clonedRequest.method,
              status: httpResponse.status,
              startTime: startTime,
              endTime: endTime,
              bytesSent: this.sentBytes,
              bytesReceived: this.receivedBytes,
              body: JSON.stringify(clonedRequest.body),
              traceAttributes: dtHeaders,
            });
          })
        )
      );
    } else {
      // If non-mobile platform, perform the request as normal. 
      return lastValueFrom(next.handle(request));
    }
  }
}
```

2. Register your interceptor. Ensure that you have registered this interceptor within the providers array in your AppModule or another appropriate module in your application. To register it in AppModule, update your `app.module.ts` file as follows:
```
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';
import { CustomInterceptor } from './custom-interceptor.interceptor';

@NgModule({
  // ...
  providers: [
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    // Add the interceptor to the providers
    {
      provide: HTTP_INTERCEPTORS,
      useClass: CustomInterceptor,
      multi: true,
    },
  ],
  // ...
})
export class AppModule {}
```

3. All requests made using `HttpClient` will now go through the interceptor and http requests will now be instrumented. You can have multiple interceptors registered, but Angular processes interceptors in the order in which they were provided. 