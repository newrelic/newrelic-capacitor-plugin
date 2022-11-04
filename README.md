# newrelic-capacitor-plugin

NewRelic Plugin for ionic Capacitor

## Install

```bash
npm install newrelic-capacitor-plugin
npx cap sync
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
incrementAttribute(options: { name: any; value?: any; }) => void
```

| Param         | Type                                     |
| ------------- | ---------------------------------------- |
| **`options`** | <code>{ name: any; value?: any; }</code> |

--------------------


### noticeHttpTransaction(...)

```typescript
noticeHttpTransaction(options: { url: string; method: string; status: any; startTime: any; endTime: any; bytesSent: any; bytesReceived: any; body: string; }) => void
```

| Param         | Type                                                                                                                                       |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| **`options`** | <code>{ url: string; method: string; status: any; startTime: any; endTime: any; bytesSent: any; bytesReceived: any; body: string; }</code> |

--------------------


### noticeNetworkFailure(...)

```typescript
noticeNetworkFailure(options: { url: string; method: string; status: any; startTime: any; endTime: any; failure: string; }) => void
```

| Param         | Type                                                                                                      |
| ------------- | --------------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ url: string; method: string; status: any; startTime: any; endTime: any; failure: string; }</code> |

--------------------


### recordMetric(...)

```typescript
recordMetric(options: { name: string; category: string; value?: any; countUnit?: string; valueUnit?: string; }) => void
```

| Param         | Type                                                                                                  |
| ------------- | ----------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ name: string; category: string; value?: any; countUnit?: string; valueUnit?: string; }</code> |

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
setMaxEventBufferTime(options: { maxBufferTimeInSeconds: any; }) => void
```

| Param         | Type                                          |
| ------------- | --------------------------------------------- |
| **`options`** | <code>{ maxBufferTimeInSeconds: any; }</code> |

--------------------


### setMaxEventPoolSize(...)

```typescript
setMaxEventPoolSize(options: { maxPoolSize: any; }) => void
```

| Param         | Type                               |
| ------------- | ---------------------------------- |
| **`options`** | <code>{ maxPoolSize: any; }</code> |

--------------------

</docgen-api>
