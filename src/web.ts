import { WebPlugin } from '@capacitor/core';
import {
    NewRelicCapacitorPluginPlugin,
    AgentConfiguration,
    DTHeaders,
    HttpHeadersTracking,
    NREnums
} from './definitions';

export class NewRelicCapacitorPluginWeb extends WebPlugin implements NewRelicCapacitorPluginPlugin {
    start(_options: { appKey: string; agentConfiguration?: AgentConfiguration | undefined; }): void {
       // throw new Error('Method not implemented.');
    }
    setUserId(_options: { userId: string; }): void {
        //throw new Error('Method not implemented.');
    }
    setAttribute(_options: { name: string; value: string; }): void {
        //throw new Error('Method not implemented.');
    }
    removeAttribute(_options: { name: string; }): void {
        //throw new Error('Method not implemented.');
    }
    recordBreadcrumb(_options: { name: string; eventAttributes: object; }): void {
       //  throw new Error('Method not implemented.');
    }
    recordCustomEvent(_options: { eventType: string; eventName: string; attributes: object; }): void {
       // throw new Error('Method not implemented.');
    }
    startInteraction(_options: { value: string; }): Promise<{ value: string; }> {
        return new Promise((resolve) => {
            resolve({value:''});
        })
    }
    endInteraction(_options: { interactionId: string; }): void {
       // throw new Error('Method not implemented.');
    }
    crashNow(_options?: { message: string; } | undefined): void {
        //throw new Error('Method not implemented.');
    }
    currentSessionId(_options?: {} | undefined): Promise<{ sessionId: string; }> {
        //throw new Error('Method not implemented.');
        return new Promise((resolve) => {
            resolve({sessionId:''});
        })
    }
    incrementAttribute(_options: { name: string; value?: number | undefined; }): void {
       // throw new Error('Method not implemented.');
    }
    noticeNetworkFailure(_options: {url: string, method: string, startTime: number,  endTime: number, failure:string}): void {
        // throw new Error('Method not implemented.');
    }
    noticeHttpTransaction(_options: { url: string; method: string; status: number; startTime: number; endTime: number; bytesSent: number; bytesReceived: number; body: string; }): void {
        // throw new Error('Method not implemented.');
    }
    recordMetric(_options: { name: string; category: string; value?: number | undefined; countUnit?: string | undefined; valueUnit?: string | undefined; }): void {
        // throw new Error('Method not implemented.');
    }
    removeAllAttributes(_options?: {} | undefined): void {
        // throw new Error('Method not implemented.');
    }
    setMaxEventBufferTime(_options: { maxBufferTimeInSeconds: number; }): void {
        // throw new Error('Method not implemented.');
    }
    setMaxEventPoolSize(_options: { maxPoolSize: number; }): void {
        // throw new Error('Method not implemented.');
    }

    setMaxOfflineStorageSize(_options: { megaBytes: number; }): void {
        // throw new Error('Method not implemented.');
    }
    recordError(_options: { name: string; message: string; stack: string; isFatal: boolean; attributes?: object }): void {
       // throw new Error('Method not implemented.');
    }
    analyticsEventEnabled(_options: { enabled: boolean; }): void {
       // throw new Error('Method not implemented.');
    }
    networkRequestEnabled(_options: { enabled: boolean; }): void {
       // throw new Error('Method not implemented.');
    }
    networkErrorRequestEnabled(_options: { enabled: boolean; }): void {
      //  throw new Error('Method not implemented.');
    }
    httpResponseBodyCaptureEnabled(_options: { enabled: boolean; }): void {
      //  throw new Error('Method not implemented.');
    }
    getAgentConfiguration(_options?: {} | undefined): Promise<AgentConfiguration> {
        let a: AgentConfiguration ={
            analyticsEventEnabled : true,
            crashReportingEnabled : true,
            interactionTracingEnabled: true,
            networkRequestEnabled: true,
            networkErrorRequestEnabled: true,
            httpResponseBodyCaptureEnabled: true,
            webViewInstrumentation: true,
            loggingEnabled: true,
            logLevel: '',
            collectorAddress: '',
            crashCollectorAddress: '',
            sendConsoleEvents: true,
            fedRampEnabled: false,
            offlineStorageEnabled:true
        };
       return new Promise((resolve) => {
            resolve(a);
        })
    }
    shutdown(_options?: {} | undefined): void {
       //  throw new Error('Method not implemented.');
    }
    generateDistributedTracingHeaders(_options: {}):  Promise<DTHeaders> {

        let dtHeaders: DTHeaders ={
            newrelic:"1",
            traceparent:"1",
            tracestate:"1",
            traceid:"1",
            guid:"1",
            id:"1"

        };
       return new Promise((resolve) => {
            resolve(dtHeaders);
        })
        //  throw new Error('Method not implemented.');
    }

    addHTTPHeadersTrackingFor(_options: {headers: string[]}): any {
        //  throw new Error('Method not implemented.');
    }

    log(_options: { level: NREnums.LogLevel; message: string }) {

        if (_options.message === undefined || _options.message.length === 0) {
            // If the message is empty, log an error message and return
            console.error("Log message is empty.");
            return;
        }

        // Create a new Map to store attributes
        let attributes = new Map<string, any>();
        // Set the message and log level as attributes
        attributes.set("message", _options.message);
        attributes.set("level", _options.level);
        // Log the attributes
        this.logAttributes({attributes: attributes});
    }

    logError(_options: { message: string }) {
        this.log({level:NREnums.LogLevel.ERROR, message:_options.message});
    }

    logWarning(_options: { message: string }) {
        this.log({level:NREnums.LogLevel.WARNING, message:_options.message});
    }

    logAll(_options: { error: string; attributes: object }) {

        let allAttributes = new Map<string,any>();

        // Set the error message as an attribute
        allAttributes.set("message", _options.error);

        // Iterate over the attributes Map and add each attribute to allAttributes
        for (let [key, value] of Object.entries(_options.attributes)) {
            allAttributes.set(key, value);
        }

        // Log all attributes
        this.logAttributes({attributes: allAttributes});
    }

    logInfo(_options: { message: string }) {
        this.log({level:NREnums.LogLevel.INFO, message:_options.message});
    }

    logVerbose(_options: { message: string }) {
        this.log({level:NREnums.LogLevel.VERBOSE, message:_options.message})
    }

    logDebug(_options: { message: string }) {
        this.log({level:NREnums.LogLevel.AUDIT, message:_options.message});
    }

    logAttributes(_options: { attributes: object }) {

        if(_options.attributes === undefined || Object.keys(_options.attributes).length === 0){
            // If the attributes are empty, log an error message and return
            console.error("Attributes are empty.");
            return;
        }

    }

    getHTTPHeadersTrackingFor(): Promise<HttpHeadersTracking> {
        
        let httpHeadersTracking: HttpHeadersTracking = {
            headersList:"[]"
        };
       return new Promise((resolve) => {
            resolve(httpHeadersTracking);
        })
    }
}
