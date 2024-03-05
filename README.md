[![Community Plus header](https://github.com/newrelic/opensource-website/raw/main/src/images/categories/Community_Plus.png)](https://opensource.newrelic.com/oss-category/#community-plus)

[![Android Test Suite](https://github.com/newrelic/newrelic-capacitor-plugin/actions/workflows/android.yml/badge.svg)](https://github.com/newrelic/newrelic-capacitor-plugin/actions/workflows/android.yml)
[![iOS Test Suite](https://github.com/newrelic/newrelic-capacitor-plugin/actions/workflows/ios.yml/badge.svg)](https://github.com/newrelic/newrelic-capacitor-plugin/actions/workflows/ios.yml)

# newrelic-capacitor-plugin

NewRelic Plugin for ionic Capacitor. This plugin uses native New Relic Android and iOS agents to instrument the Ionic Capacitor environment. The New Relic SDKs collect crashes, network traffic, and other information for hybrid apps using native components.


## Features
* Capture JavaScript errors
* Network Instrumentation (CapacitorHttp Client XMLHttpRequest and Fecth) 
* Distributed Tracing (CapacitorHttp Client and Fecth)
* Tracking console log, warn and error
* Promise rejection tracking
* Capture interactions and the sequence in which they were created
* Pass user information to New Relic to track user sessions
* Collect offline Events when there is no internet connection

## Current Support:
- Android API 24+
- iOS 10
- Depends on New Relic iOS/XCFramework and Android agents

## Install

```bash
npm install @newrelic/newrelic-capacitor-plugin
npx cap sync
```


## Ionic Capacitor Setup

You can start the New Relic agent in the initialization of your app in `main.ts` (Angular or Vue) or `index.tsx` (React). Add the following code to launch NewRelic (don't forget to put proper application tokens):

``` tsx
import { NewRelicCapacitorPlugin, NREnums, AgentConfiguration } from '@newrelic/newrelic-capacitor-plugin';
import { Capacitor } from '@capacitor/core';

var appToken;

if(Capacitor.getPlatform() === 'ios') {
    appToken = '<IOS-APP-TOKEN>';
} else {
    appToken = '<ANDROID-APP-TOKEN>';
}

let agentConfig : AgentConfiguration = {
  //Android Specific
  // Optional:Enable or disable collection of event data.
  analyticsEventEnabled: true,

  // Optional:Enable or disable crash reporting.
  crashReportingEnabled: true,

  // Optional:Enable or disable interaction tracing. Trace instrumentation still occurs, but no traces are harvested. This will disable default and custom interactions.
  interactionTracingEnabled: true,

  // Optional:Enable or disable reporting successful HTTP requests to the MobileRequest event type.
  networkRequestEnabled: true,

  // Optional:Enable or disable reporting network and HTTP request errors to the MobileRequestError event type.
  networkErrorRequestEnabled: true,

  // Optional:Enable or disable capture of HTTP response bodies for HTTP error traces, and MobileRequestError events.
  httpResponseBodyCaptureEnabled: true,

  // Optional:Enable or disable agent logging.
  loggingEnabled: true,

  // Optional:Specifies the log level. Omit this field for the default log level.
  // Options include: ERROR (least verbose), WARNING, INFO, VERBOSE, AUDIT (most verbose).
  logLevel: NREnums.LogLevel.INFO,

  // iOS Specific
  // Optional:Enable/Disable automatic instrumentation of WebViews
  webViewInstrumentation: true,

  // Optional:Set a specific collector address for sending data. Omit this field for default address.
  // collectorAddress: "",

  // Optional:Set a specific crash collector address for sending crashes. Omit this field for default address.
  // crashCollectorAddress: "",

  // Optional:Enable or disable sending JS console logs to New Relic.
  sendConsoleEvents: true,

  // Optional: Enable or disable reporting data using different endpoints for US government clients.
   fedRampEnabled: false

  // Optional: Enable or disable offline data storage when no internet connection is available.
  offlineStorageEnabled:true
}

NewRelicCapacitorPlugin.start({appKey:appToken, agentConfiguration:agentConfig})


```
AppToken is platform-specific. You need to generate separate tokens for Android and iOS apps.

### Android Setup
1. Install the New Relic native Android agent ([instructions here](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/install-configure/install-android-apps-gradle-android-studio)).
2. Update `build.gradle`:
  ```groovy
    buildscript {
      ...
      repositories {
        ...
        mavenCentral()
      }
      dependencies {
        ...
        classpath "com.newrelic.agent.android:agent-gradle-plugin:7.3.0"
      }
    }
  ```

3. Update `app/build.gradle`:
  ```groovy
    apply plugin: "com.android.application"
    apply plugin: 'newrelic' // <-- add this
  
  ```

4. Make sure your app requests INTERNET and ACCESS_NETWORK_STATE permissions by adding these lines to your `AndroidManifest.xml`
  ```
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  ```
To automatically link the package, rebuild your project:
```shell
# Android apps
ionic capacitor run android

# iOS apps
ionic capacitor run ios
```

## Angular HttpClient Instrumentation
To learn more about how to add custom instrumentation for Angular's HttpClient, follow the [link here](./angular_http_client_instrumentation.md).

## API


* [`setUserId(...)`](#setuserid)
* [`setAttribute(...)`](#setattribute)
* [`removeAttribute(...)`](#removeattribute)
* [`recordBreadcrumb(...)`](#recordbreadcrumb)
* [`recordCustomEvent(...)`](#recordcustomevent)
* [`startInteraction(...)`](#startinteraction)
* [`endInteraction(...)`](#endinteraction)
* [`crashNow(...)`](#crashnow)
* [`currentSessionId(...)`](#currentsessionid)
* [`incrementAttribute(...)`](#incrementattribute)
* [`noticeHttpTransaction(...)`](#noticehttptransaction)
* [`recordMetric(...)`](#recordmetric)
* [`removeAllAttributes(...)`](#removeallattributes)
* [`setMaxEventBufferTime(...)`](#setmaxeventbuffertime)
* [`setMaxEventPoolSize(...)`](#setmaxeventpoolsize)
* [`recordError(...)`](#recorderror)
* [`analyticsEventEnabled(...)`](#analyticseventenabled)
* [`networkRequestEnabled(...)`](#networkrequestenabled)
* [`networkErrorRequestEnabled(...)`](#networkerrorrequestenabled)
* [`httpResponseBodyCaptureEnabled(...)`](#httpresponsebodycaptureenabled)
* [`getAgentConfiguration(...)`](#getagentconfiguration)
* [`shutdown(...)`](#shutdown)
* [`generateDistributedTracingHeaders(...)`](#generateDistributedTracingHeaders)
* [`setMaxOfflineStorageSize(...)`](#setMaxOfflineStorageSize)




### [setUserId(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/set-user-id)
> Set a custom user identifier value to associate user sessions with analytics events and attributes.
```typescript
setUserId(options: { userId: string; }) => void
```

| Param         | Type                             |
| ------------- | -------------------------------- |
| **`options`** | <code>{ userId: string; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.setUserId({ userId: "CapacitorUserId" });
```

--------------------


### [setAttribute(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/set-attribute)
> Creates a session-level attribute shared by multiple mobile event types. Overwrites its previous value and type each time it is called.
```typescript
setAttribute(options: { name: string; value: string; }) => void
```

| Param         | Type                                    |
| ------------- | --------------------------------------- |
| **`options`** | <code>{ name: string; value: string; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.setAttribute({ name: "CapacitorAttribute", value: "123" });
```

--------------------


### [removeAttribute(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/remove-attribute)
> This method removes the attribute specified by the name string.

```typescript
removeAttribute(options: { name: string; }) => void
```

| Param         | Type                        |
| ------------- | --------------------------- |
| **`options`** | <code>{ name: string; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.removeAttribute({ name: "CapacitorAttribute" });
```
--------------------


### [recordBreadcrumb(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/recordbreadcrumb)
> Track app activity/screen that may be helpful for troubleshooting crashes.

```typescript
recordBreadcrumb(options: { name: string; eventAttributes: object; }) => void
```

| Param         | Type                                                 |
| ------------- | ---------------------------------------------------- |
| **`options`** | <code>{ name: string; eventAttributes: object; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.recordBreadcrumb({ name: "shoe", eventAttributes: {"shoeColor": "blue","shoesize": 9,"shoeLaces": true} });
```

--------------------


### [recordCustomEvent(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/recordcustomevent-android-sdk-api)
> Creates and records a custom event for use in New Relic Insights.

```typescript
recordCustomEvent(options: { eventType: string; eventName: string; attributes: object; }) => void
```

| Param         | Type                                                                 |
| ------------- | -------------------------------------------------------------------- |
| **`options`** | <code>{ eventType: string; eventName: string; attributes: object; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.recordCustomEvent({ eventType: "mobileClothes", eventName: "pants", attributes:{"pantsColor": "blue","pantssize": 32,"belt": true} });
```

--------------------


### [startInteraction(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/start-interaction)
> Track a method as an interaction.

```typescript
startInteraction(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### [endInteraction(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/end-interaction)
> End an interaction
> (Required). This uses the string ID for the interaction you want to end.
> This string is returned when you use startInteraction().
```typescript
endInteraction(options: { interactionId: string; }) => void
```

| Param         | Type                                    |
| ------------- | --------------------------------------- |
| **`options`** | <code>{ interactionId: string; }</code> |

#### Usage:
```ts
 const badApiLoad = async () => {
   const id = await NewRelicCapacitorPlugin.startInteraction({ value: 'StartLoadBadApiCall' });
   console.log(id);
   const url = 'https://fakewebsite.com/moviessssssssss.json';
   fetch(url)
     .then((response) => response.json())
     .then((responseJson) => {
       console.log(responseJson);
       NewRelicCapacitorPlugin.endInteraction({ interactionId: id.value });
     }) .catch((error) => {
       NewRelicCapacitorPlugin.endInteraction({ interactionId: id.value });
       console.error(error);
     });
 };
```

--------------------


### [crashNow(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/crashnow-android-sdk-api)
> Throws a demo run-time exception to test New Relic crash reporting.

```typescript
crashNow(options?: { message: string; } | undefined) => void
```

| Param         | Type                              |
| ------------- | --------------------------------- |
| **`options`** | <code>{ message: string; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.crashNow();
    NewRelicCapacitorPlugin.crashNow({ message: "A demo crash message" });
```
--------------------


### [currentSessionId(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/currentsessionid-android-sdk-api)
> Returns the current session ID. This method is useful for consolidating monitoring of app data (not just New Relic data) based on a single session definition and identifier.
```typescript
currentSessionId(options?: {} | undefined) => Promise<{ sessionId: string; }>
```

| Param         | Type            |
| ------------- | --------------- |
| **`options`** | <code>{}</code> |

**Returns:** <code>Promise&lt;{ sessionId: string; }&gt;</code>

#### Usage:
```ts
    let { sessionId } = await NewRelicCapacitorPlugin.currentSessionId();
```
--------------------


### [incrementAttribute(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/increment-attribute)
> Increments the count of an attribute with a specified name. Overwrites its previous value and type each time it is called. If the attribute does not exists, it creates a new attribute. If no value is given, it increments the value by 1.

```typescript
incrementAttribute(options: { name: string; value?: number; }) => void
```

| Param         | Type                                           |
| ------------- | ---------------------------------------------- |
| **`options`** | <code>{ name: string; value?: number; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.incrementAttribute({ name: 'CapacitorAttribute', value: 15 })
```

--------------------


### [noticeHttpTransaction(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/notice-http-transaction)
> Manually records HTTP transactions, with an option to also send a response body.
```typescript
noticeHttpTransaction(options: { url: string; method: string; status: number; startTime: number; endTime: number; bytesSent: number; bytesReceived: number; body: string; traceAttributes?: object}) => void
```

| Param         | Type                                                                                                                                                      |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ url: string; method: string; status: number; startTime: number; endTime: number; bytesSent: number; bytesReceived: number; body: string; traceAttributes?: object}</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.noticeHttpTransaction({
      url: "https://fakewebsite.com",
      method: "GET",
      status: 200,
      startTime: Date.now(),
      endTime: Date.now(),
      bytesSent: 10,
      bytesReceived: 2500,
      body: "fake http response body 200",
    });
```
--------------------

### [noticeNetworkFailure(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/notice-network-failure)
> Records network failures. If a network request fails, use this method to record details about the failures. In most cases, place this call inside exception handlers, such as catch blocks. Supported failures are: Unknown, BadURL, TimedOut, CannotConnectToHost, DNSLookupFailed, BadServerResponse, SecureConnectionFailed.
```typescript
noticeNetworkFailure(options: { url: string; method: string; startTime: number; endTime: number; failure: string;
}) => void
```

| Param         | Type                                                                                                                                                      |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ url: string; method: string; startTime: number; endTime: number; failure: string}</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.noticeNetworkFailure({
      url: "https://fakewebsite400.com",
      method: "GET",
      startTime: Date.now(),
      endTime: Date.now() + 200,
      failure: "BadURL"
    });

```
### [recordMetric(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/recordmetric-android-sdk-api))
> Records custom metrics (arbitrary numerical data), where countUnit is the measurement unit of the metric count and valueUnit is the measurement unit for the metric value. If using countUnit or valueUnit, then all of value, countUnit, and valueUnit must all be set. Supported measurements for countUnit and valueUnit are: `PERCENT`, `BYTES`, `SECONDS`, `BYTES_PER_SECOND`, `OPERATIONS`

```typescript
recordMetric(options: { name: string; category: string; value?: number; countUnit?: string; valueUnit?: string; }) => void
```

| Param         | Type                                                                                                     |
| ------------- | -------------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ name: string; category: string; value?: number; countUnit?: string; valueUnit?: string; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.recordMetric({
      name: "CapacitorMetricName",
      category: "CapacitorMetricCategory",
    });
    NewRelicCapacitorPlugin.recordMetric({
      name: "CapacitorMetricName2",
      category: "CapacitorMetricCategory2",
      value: 25,
    });
    NewRelicCapacitorPlugin.recordMetric({
      name: "CapacitorMetricName3",
      category: "CapacitorMetricCategory3",
      value: 30,
      countUnit: NREnums.MetricUnit.SECONDS,
      valueUnit: NREnums.MetricUnit.OPERATIONS,
    });
```

--------------------


### [removeAllAttributes(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/remove-all-attributes)
> Removes all attributes from the session

```typescript
removeAllAttributes(options?: {} | undefined) => void
```

| Param         | Type            |
| ------------- | --------------- |
| **`options`** | <code>{}</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.removeAllAttributes();
```

--------------------


### [setMaxEventBufferTime(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/set-max-event-buffer-time)
> Sets the event harvest cycle length. Default is 600 seconds (10 minutes). Minimum value can not be less than 60 seconds. Maximum value should not be greater than 600 seconds.

```typescript
setMaxEventBufferTime(options: { maxBufferTimeInSeconds: number; }) => void
```

| Param         | Type                                             |
| ------------- | ------------------------------------------------ |
| **`options`** | <code>{ maxBufferTimeInSeconds: number; }</code> |

#### Usage: 
```ts
    NewRelicCapacitorPlugin.setMaxEventBufferTime({ maxBufferTimeInSeconds: 60 });
```
--------------------


### [setMaxEventPoolSize(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/set-max-event-pool-size)
> Sets the maximum size of the event pool stored in memory until the next harvest cycle. Default is a maximum of 1000 events per event harvest cycle. When the pool size limit is reached, the agent will start sampling events, discarding some new and old, until the pool of events is sent in the next harvest cycle.

```typescript
setMaxEventPoolSize(options: { maxPoolSize: number; }) => void
```

| Param         | Type                                  |
| ------------- | ------------------------------------- |
| **`options`** | <code>{ maxPoolSize: number; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.setMaxEventPoolSize({ maxPoolSize: 2000 })
```
--------------------


### [analyticsEventEnabled(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/android-agent-configuration-feature-flags/#ff-analytics-events)
> FOR ANDROID ONLY. Enable or disable the collecton of event data. This is set to true by default.

```typescript
analyticsEventEnabled(options: { enabled: boolean; }) => void
```

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.analyticsEventEnabled({ enabled: true })
```

--------------------


### [networkRequestEnabled(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/android-agent-configuration-feature-flags/#ff-networkRequests)
> Enable or disable reporting successful HTTP requests to the MobileRequest event type. This is set to true by default.

```typescript
networkRequestEnabled(options: { enabled: boolean; }) => void
```

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.networkRequestEnabled({ enabled: true })
```
--------------------


### [networkErrorRequestEnabled(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/android-agent-configuration-feature-flags/#ff-networkErrorRequests)
> Enable or disable reporting network and HTTP request errors to the MobileRequestError event type.

```typescript
networkErrorRequestEnabled(options: { enabled: boolean; }) => void
```

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.networkErrorRequestEnabled({ enabled: true })
```

--------------------


### [httpResponseBodyCaptureEnabled(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/android-agent-configuration-feature-flags/#ff-withHttpResponseBodyCaptureEnabled)
> Enable or disable capture of HTTP response bodies for HTTP error traces, and MobileRequestError events.

```typescript
httpResponseBodyCaptureEnabled(options: { enabled: boolean; }) => void
```

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |
#### Usage:
```ts
    NewRelicCapacitorPlugin.httpResponseBodyCaptureEnabled({ enabled: true })
```

--------------------


### getAgentConfiguration(...)
> Returns the current agent configuration settings. This method allows you to see the current state of the agent configuration.
```typescript
getAgentConfiguration(options?: {} | undefined) => Promise<AgentConfiguration>
```

| Param         | Type            |
| ------------- | --------------- |
| **`options`** | <code>{}</code> |

**Returns:** <code>Promise&lt;AgentConfiguration&gt;</code>

#### Usage:
```ts
    import { NewRelicCapacitorPlugin, AgentConfiguration} from '@newrelic/newrelic-capacitor-agent';

    let agentConfig : AgentConfiguration = await NewRelicCapacitorPlugin.getAgentConfiguration();
    let sendConsoleEvents = agentConfig.sendConsoleEvents;
```
--------------------

### [shutdown(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile-android/android-sdk-api/shut-down/)
> Shut down the agent within the current application lifecycle during runtime.
```typescript
shutdown(options?: {} | undefined) => void
```

| Param         | Type            |
| ------------- | --------------- |
| **`options`** | <code>{}</code> |


--------------------


### [generateDistributedTracingHeaders(...)]
> Generates headers and trace attributes required for manual distributed tracing and http instrumentation.
```typescript
generateDistributedTracingHeaders(options?: {} | undefined) => Promise<object>
```

| Param         | Type            |
| ------------- | --------------- |
| **`options`** | <code>{}</code> |

#### Usage:
```ts
    let distributedTraceAttributes = await NewRelicCapacitorPlugin.generateDistributedTracingHeaders();
    // Add traceparent, tracestate, and newrelic headers to http request
    // ....
    NewRelicCapacitorPlugin.noticeHttpTransaction({
      url: "https://fakewebsite.com",
      method: "GET",
      status: 200,
      startTime: Date.now(),
      endTime: Date.now(),
      bytesSent: 10,
      bytesReceived: 2500,
      body: "fake http response body 200",
      traceAttributes: distributedTraceAttributes,
    });
```
--------------------

### [addHTTPHeadersTrackingFor(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile/mobile-sdk/add-tracked-headers/)

> This API allows you to add any header field strings to a list that gets recorded as attributes with networking request events. After header fields have been added using this function, if the headers are in a network call they will be included in networking events in NR1.
```typescript
addHTTPHeadersTrackingFor(options:{headers: string[]}): void;
```

| Param         | Type            |
| ------------- | --------------- |
| **`options`** | <code>{headers: string[]}</code> |


--------------------

#### Usage:
```ts
 NewRelicCapacitorPlugin.addHTTPHeadersTrackingFor({headers:["Car","Music"]});

```
--------------------

### [setMaxOfflineStorageSize(...)](https://docs.newrelic.com/docs/mobile-monitoring/new-relic-mobile/mobile-sdk/set-max-offline-storage/)
> Sets the maximum size of total data that can be stored for offline storage.By default, mobile monitoring can collect a maximum of 100 megaBytes of offline storage. When a data payload fails to send because the device doesn't have an internet connection, it can be stored in the file system until an internet connection has been made. After a typical harvest payload has been successfully sent, all offline data is sent to New Relic and cleared from storage.

```typescript
setMaxOfflineStorageSize(options: { megaBytes: number; }) => void
```

| Param         | Type                                  |
| ------------- | ------------------------------------- |
| **`options`** | <code>{ megaBytes: number; }</code> |

#### Usage:
```ts
    NewRelicCapacitorPlugin.setMaxOfflineStorageSize({ megaBytes: 200 })
```
--------------------



## Error Reporting
### recordError(...)
> Records JavaScript/TypeScript errors for Ionic Capacitor. You should add this method to your framework's global error handler.

```typescript
recordError(options: { name: string; message: string; stack: string; isFatal: boolean; attributes?: object; }) => void
```

| Param         | Type                                                                             |
| ------------- | -------------------------------------------------------------------------------- |
| **`options`** | <code>{ name: string; message: string; stack: string; isFatal: boolean; attributes?: object; }</code> |

#### Usage:
```ts
    try {
      throw new Error('Example error message');
    } catch (e: any) {
      NewRelicCapacitorPlugin.recordError({
        name: e.name,
        message: e.message,
        stack: e.stack,
        isFatal: false,
        attributes: {
          "status": "pending",
          "escalate": false,
        },
      });
    }
```

### Angular
Angular 2+ exposes an [ErrorHandler](https://angular.io/api/core/ErrorHandler) class to handle errors. You can implement New Relic by extending this class as follows:

```ts
import { ErrorHandler, Injectable } from '@angular/core';
import { NewRelicCapacitorPlugin } from "@newrelic/newrelic-capacitor-plugin";

@Injectable()
export class GlobalErrorHandler extends ErrorHandler {
  constructor() {
    super();
  }
  handleError(error: any): void {
    NewRelicCapacitorPlugin.recordError({
      name: error.name,
      message: error.message,
      stack: error.stack ? error.stack : "No stack available",
      isFatal: false,
      attributes: {
        "status": "pending",
        "escalate": false,
      },
    });
    super.handleError(error);
  }
}
```
Then, you'll need to let Angular 2 know about this new error handler by listing overrides for the provider in `app.module.ts`:
```ts
@NgModule({
  declarations: [AppComponent],
  imports: [BrowserModule, IonicModule.forRoot(), AppRoutingModule,HttpClientModule],
  providers: [{ provide: RouteReuseStrategy, useClass: IonicRouteStrategy },{provide: ErrorHandler, useClass: GlobalErrorHandler}],
  bootstrap: [AppComponent],
})
```

### React
React 16+ has added error boundary components that catch errors that bubble up from child components. These are very useful for tracking and reporting errors to New Relic.

```ts
import React, { Component, ErrorInfo, ReactNode } from "react";
import { NewRelicCapacitorPlugin } from "@newrelic/newrelic-capacitor-plugin";

interface Props {
  children?: ReactNode;
}

interface State {
  hasError: boolean;
}

class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false,
  };

  public static getDerivedStateFromError(_: Error): State {
    // Update state so the next render will show the fallback UI.
    return { hasError: true };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error("Uncaught error:", error, errorInfo);
    NewRelicCapacitorPlugin.recordError({
      name: error.name,
      message: error.message,
      stack: error.stack ? error.stack : "No stack available",
      isFatal: false,
      attributes: {
        "status": "pending",
        "escalate": false,
      },
    });
  }

  public render() {
    if (this.state.hasError) {
      // Render error messages or other components here.
      return;
    }

    return this.props.children;
  }
}

export default ErrorBoundary;
```

### Vue
Vue has a global error handler that reports native JavaScript errors and passes in the Vue instance. This handler will be useful for reporting errors to New Relic.

```js
import { NewRelicCapacitorPlugin } from "@newrelic/newrelic-capacitor-plugin";

Vue.config.errorHandler = (err, vm, info) => {

    // Record properties passed to the component if there are any
    if(vm.$options.propsData) {
        NewRelicCapacitorPlugin.recordBreadcrumb({
          name: "Props passed to component in error handler",
          eventAttributes: vm.$options.propsData
        });
    }

    // Get the lifecycle hook, if present
    let lifecycleHookInfo = 'none';
    if (info){
        lifecycleHookInfo = info;
    }

    // Record a breadcrumb with more details such as component name and lifecycle hook
    NewRelicCapacitorPlugin.recordBreadcrumb({
      name: "Vue Error",
      eventAttributes: {
        componentName: vm.$options.name,
        lifeCycleHook: lifecycleHookInfo
      }
    });

    // Record the JS error to New Relic
    NewRelicCapacitorPlugin.recordError({
      name: err.name,
      message: err.message,
      stack: err.stack ? err.stack : "No stack available",
      isFatal: false,
      attributes: {
        "status": "pending",
        "escalate": false,
      },
    });
}
```

## How to see JSErrors(Fatal/Non Fatal) in NewRelic One?

JavaScript errors can be seen in the `Handled Exceptions` tab or as a `MobileHandledException` event. You can also see these errors in the NRQL explorer using this query:
You can also build dashboard for errors using this query:

  ```sql
  SELECT * FROM `MobileHandledException` SINCE 24 hours ago
  ```

Note: Errors that do not produce a stack trace will not appear in the `Handled Exceptions` tab but will appear as a `MobileHandledException` event.

## Uploading dSYM files

Our iOS agent includes a Swift script intended to be run from a build script in your target's build phases in XCode. The script automatically uploads dSYM files in the background (or converts your dSYM to the New Relic map file format), and then performs a background upload of the files needed for crash symbolication to New Relic.

To invoke this script during an XCode build:
1. In Xcode, select your project in the navigator, then click on the application target.
2. Select the Build Phases tab in the settings editor.
3. Click the + icon above Target Dependencies and choose New Run Script Build Phase. Ensure the new build script is the very last build script.
4. Add the following lines of code to the new phase and replace `APP_TOKEN` with your iOS application token.
    1. If there is a checkbox below Run script that says "Run script: Based on Dependency analysis" please make sure it is not checked.

### Capacitor agent 1.3.1 or higher
With the ios agent 7.4.6 release, the XCFramework no longer includes the dsym-upload-tools. You can find the dsym-upload-tools in the dsym-upload-tools folder of the https://github.com/newrelic/newrelic-ios-agent-spm Swift Package Manager repository. Please copy the dsym-upload-tools directory into your application source code directory by copying the XCFramework into your project or using Cocoapods if you're integrating the New Relic iOS Agent. Use the run script below in your Xcode build phases to perform symbol upload steps during app builds in Xcode.

```
ARTIFACT_DIR="${BUILD_DIR%Build/*}SourcePackages/artifacts"

SCRIPT=`/usr/bin/find "${SRCROOT}" "${ARTIFACT_DIR}" -type f -name run-symbol-tool | head -n 1`
/bin/sh "${SCRIPT}" "APP_TOKEN"
```

#### Note: The automatic script requires bitcode to be disabled. You should clean and rebuild your app after adding the script. 

### Missing dSYMs
The automatic script will create an `upload_dsym_results.log` file in your project's iOS directory, which contains information about any failures that occur during symbol upload.

If dSYM files are missing, you may need to check Xcode build settings to ensure the file is being generated. Frameworks which are built locally have separate build settings and may need to be updated as well.

Build settings:
```
Debug Information Format : Dwarf with dSYM File
Deployment Postprocessing: Yes
Strip Linked Product: Yes
Strip Debug Symbols During Copy : Yes
```

## Contribute

We encourage your contributions to improve `newrelic-capacitor-plugin`! Keep in mind that when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.

If you have any questions, or to execute our corporate CLA (which is required if your contribution is on behalf of a company), drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

If you would like to contribute to this project, review [these guidelines](./CONTRIBUTING.md).

## Support

New Relic hosts and moderates an online forum where customers, users, maintainers, contributors, and New Relic employees can discuss and collaborate:

[forum.newrelic.com](https://forum.newrelic.com/).

## License

This project is distributed under the [Apache 2 license](LICENSE).
>newrelic-capacitor-plugin also uses source code from third-party libraries. You can find full details on which libraries are used and the terms under which they are licensed in the third-party notices document.
