[![Community Plus header](https://github.com/newrelic/opensource-website/raw/main/src/images/categories/Community_Plus.png)](https://opensource.newrelic.com/oss-category/#community-plus)

# newrelic-capacitor-plugin

NewRelic Plugin for ionic Capacitor.This plugin uses native New Relic Android and iOS agents to instrument the Ionic Capacitor environment. The New Relic SDKs collect crashes, network traffic, and other information for hybrid apps using native components.


## Features
* Capture JavaScript errors
* Network Instrumentation
* Distributed Tracing
* Tracking console log, warn and error
* Promise rejection tracking
* Capture interactions and the sequence in which they were created
* Pass user information to New Relic to track user sessions

## Current Support:
- Android API 24+
- iOS 10
- Depends on New Relic iOS/XCFramework and Android agents

## Install

```bash
npm install newrelic-capacitor-plugin
npx cap sync
```


## Ionic Capacitor Setup

Now open your `index.tsx` and add the following code to launch NewRelic (don't forget to put proper application tokens):

``` tsx
import { NewRelicCapacitorPlugin } from 'newrelic-capacitor-plugin';
import { Capacitor } from '@capacitor/core';

    var appToken;

    if(Capacitor.getPlatform() === 'ios') 
        appToken = '<IOS-APP-TOKEN>';
    } else {
        appToken = '<ANDROID-APP-TOKEN>';
    }

NewRelicCapacitorPlugin.start({appKey:appToken})


```
AppToken is platform-specific. You need to generate the seprate token for Android and iOS apps.

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
        classpath "com.newrelic.agent.android:agent-gradle-plugin:6.8.0"
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
## API

<docgen-index>

* [`echo(...)`](#echo)
* [`start(...)`](#start)
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
* [`noticeNetworkFailure(...)`](#noticenetworkfailure)
* [`recordMetric(...)`](#recordmetric)
* [`removeAllAttributes(...)`](#removeallattributes)
* [`setMaxEventBufferTime(...)`](#setmaxeventbuffertime)
* [`setMaxEventPoolSize(...)`](#setmaxeventpoolsize)
* [`recordError(...)`](#recorderror)
* [`analyticsEventEnabled(...)`](#analyticseventenabled)
* [`networkRequestEnabled(...)`](#networkrequestenabled)
* [`networkErrorRequestEnabled(...)`](#networkerrorrequestenabled)
* [`httpRequestBodyCaptureEnabled(...)`](#httprequestbodycaptureenabled)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### start(...)

```typescript
start(options: { appKey: string; }) => void
```

| Param         | Type                             |
| ------------- | -------------------------------- |
| **`options`** | <code>{ appKey: string; }</code> |

--------------------


### setUserId(...)

```typescript
setUserId(options: { userId: string; }) => void
```

| Param         | Type                             |
| ------------- | -------------------------------- |
| **`options`** | <code>{ userId: string; }</code> |

--------------------


### setAttribute(...)

```typescript
setAttribute(options: { name: any; value: any; }) => void
```

| Param         | Type                                    |
| ------------- | --------------------------------------- |
| **`options`** | <code>{ name: any; value: any; }</code> |

--------------------


### removeAttribute(...)

```typescript
removeAttribute(options: { name: any; }) => void
```

| Param         | Type                        |
| ------------- | --------------------------- |
| **`options`** | <code>{ name: any; }</code> |

--------------------


### recordBreadcrumb(...)

```typescript
recordBreadcrumb(options: { name: any; eventAttributes: object; }) => void
```

| Param         | Type                                                 |
| ------------- | ---------------------------------------------------- |
| **`options`** | <code>{ name: any; eventAttributes: object; }</code> |

--------------------


### recordCustomEvent(...)

```typescript
recordCustomEvent(options: { eventType: any; eventName: any; attributes: object; }) => void
```

| Param         | Type                                                                 |
| ------------- | -------------------------------------------------------------------- |
| **`options`** | <code>{ eventType: any; eventName: any; attributes: object; }</code> |

--------------------


### startInteraction(...)

```typescript
startInteraction(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### endInteraction(...)

```typescript
endInteraction(options: { interactionId: string; }) => void
```

| Param         | Type                                    |
| ------------- | --------------------------------------- |
| **`options`** | <code>{ interactionId: string; }</code> |

--------------------


### crashNow(...)

```typescript
crashNow(options?: { message: string; } | undefined) => void
```

| Param         | Type                              |
| ------------- | --------------------------------- |
| **`options`** | <code>{ message: string; }</code> |

--------------------


### currentSessionId(...)

```typescript
currentSessionId(options?: {} | undefined) => Promise<{ sessionId: string; }>
```

| Param         | Type            |
| ------------- | --------------- |
| **`options`** | <code>{}</code> |

**Returns:** <code>Promise&lt;{ sessionId: string; }&gt;</code>

--------------------


### incrementAttribute(...)

```typescript
incrementAttribute(options: { name: string; value?: number; }) => void
```

| Param         | Type                                           |
| ------------- | ---------------------------------------------- |
| **`options`** | <code>{ name: string; value?: number; }</code> |

--------------------


### noticeHttpTransaction(...)

```typescript
noticeHttpTransaction(options: { url: string; method: string; status: number; startTime: number; endTime: number; bytesSent: number; bytesReceived: number; body: string; }) => void
```

| Param         | Type                                                                                                                                                      |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ url: string; method: string; status: number; startTime: number; endTime: number; bytesSent: number; bytesReceived: number; body: string; }</code> |

--------------------


### noticeNetworkFailure(...)

```typescript
noticeNetworkFailure(options: { url: string; method: string; status: number; startTime: number; endTime: number; failure: string; }) => void
```

| Param         | Type                                                                                                               |
| ------------- | ------------------------------------------------------------------------------------------------------------------ |
| **`options`** | <code>{ url: string; method: string; status: number; startTime: number; endTime: number; failure: string; }</code> |

--------------------


### recordMetric(...)

```typescript
recordMetric(options: { name: string; category: string; value?: number; countUnit?: string; valueUnit?: string; }) => void
```

| Param         | Type                                                                                                     |
| ------------- | -------------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ name: string; category: string; value?: number; countUnit?: string; valueUnit?: string; }</code> |

--------------------


### removeAllAttributes(...)

```typescript
removeAllAttributes(options?: {} | undefined) => void
```

| Param         | Type            |
| ------------- | --------------- |
| **`options`** | <code>{}</code> |

--------------------


### setMaxEventBufferTime(...)

```typescript
setMaxEventBufferTime(options: { maxBufferTimeInSeconds: number; }) => void
```

| Param         | Type                                             |
| ------------- | ------------------------------------------------ |
| **`options`** | <code>{ maxBufferTimeInSeconds: number; }</code> |

--------------------


### setMaxEventPoolSize(...)

```typescript
setMaxEventPoolSize(options: { maxPoolSize: number; }) => void
```

| Param         | Type                                  |
| ------------- | ------------------------------------- |
| **`options`** | <code>{ maxPoolSize: number; }</code> |

--------------------


### recordError(...)

```typescript
recordError(options: { name: string; message: string; stack: string; isFatal: boolean; }) => void
```

| Param         | Type                                                                             |
| ------------- | -------------------------------------------------------------------------------- |
| **`options`** | <code>{ name: string; message: string; stack: string; isFatal: boolean; }</code> |

--------------------


### analyticsEventEnabled(...)

```typescript
analyticsEventEnabled(options: { enabled: boolean; }) => void
```

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

--------------------


### networkRequestEnabled(...)

```typescript
networkRequestEnabled(options: { enabled: boolean; }) => void
```

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

--------------------


### networkErrorRequestEnabled(...)

```typescript
networkErrorRequestEnabled(options: { enabled: boolean; }) => void
```

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

--------------------


### httpRequestBodyCaptureEnabled(...)

```typescript
httpRequestBodyCaptureEnabled(options: { enabled: boolean; }) => void
```

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ enabled: boolean; }</code> |

--------------------

</docgen-api>