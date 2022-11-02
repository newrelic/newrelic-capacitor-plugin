export interface NewRelicCapacitorPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  start(options: { appKey: string }): void;
  setUserId(options: { userId: string }): void;
  setAttribute(optins:{name: any, value: any}): void;
  removeAttribute(options:{name: any}): void;
  recordBreadcrumb(options:{name: any, eventAttributes: object}): void;
  recordCustomEvent(options:{eventType: any, eventName: any, attributes: object}): void;
  startInteraction(options:{value: string}): Promise<{ value: string }>;
  endInteraction(options:{interactionId: string}): void;
}
