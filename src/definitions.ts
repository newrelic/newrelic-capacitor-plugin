export interface NewRelicCapacitorPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  start(options: { appKey: string }): void;
  setUserId(options: { userId: string }): void;
  setAttribute(options:{name: any, value: any}): void;
  removeAttribute(options:{name: any}): void;
  recordBreadcrumb(options:{name: any, eventAttributes: object}): void;
  recordCustomEvent(options:{eventType: any, eventName: any, attributes: object}): void;
  startInteraction(options:{value: string}): Promise<{ value: string }>;
  endInteraction(options:{interactionId: string}): void;
  crashNow(options?: {message: string}): void;
  currentSessionId(options?: {}): Promise<{sessionId: string}>;
  incrementAttribute(options: {name: any, value?: any}): void;
  noticeHttpTransaction(options: {
    url: string, 
    method: string, 
    status: any, 
    startTime: any, 
    endTime: any, 
    bytesSent: any, 
    bytesReceived: any, 
    body: string
  }): void;
  noticeNetworkFailure(options: {
    url: string,
    method: string,
    status: any,
    startTime: any,
    endTime: any,
    failure: string
  }): void;
  recordMetric(options: {
    name: string,
    category: string,
    value?: any, 
    countUnit?: string,
    valueUnit?: string,
  }): void;
  removeAllAttributes(options?: {}): void;
  setMaxEventBufferTime(options: {maxBufferTimeInSeconds: any}): void;
  setMaxEventPoolSize(options: {maxPoolSize: any}): void;
}
