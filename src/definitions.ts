export interface NewRelicCapacitorPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  setUserId(options: { userId: string }): void;
  setAttribute(optins:{name: any, value: any}): void;
  removeAttribute(options:{name: any}): void;
  recordBreadcrumb(options:{name: any, eventAttributes: object}): void;
  recordCustomEvent(options:{eventType: any, eventName: any, attributes: object}): void;
  startInteraction(options:{value: string}): Promise<{ value: string }>;
  endInteraction(options:{interactionId: string}): void;
}
