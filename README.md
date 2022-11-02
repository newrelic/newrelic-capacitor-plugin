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
* [`setUserId(...)`](#setuserid)
* [`setAttribute(...)`](#setattribute)
* [`removeAttribute(...)`](#removeattribute)
* [`recordBreadcrumb(...)`](#recordbreadcrumb)
* [`recordCustomEvent(...)`](#recordcustomevent)
* [`startInteraction(...)`](#startinteraction)
* [`endInteraction(...)`](#endinteraction)

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
setAttribute(optins: { name: any; value: any; }) => void
```

| Param        | Type                                    |
| ------------ | --------------------------------------- |
| **`optins`** | <code>{ name: any; value: any; }</code> |

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

</docgen-api>
