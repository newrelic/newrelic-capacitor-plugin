/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

export interface NewRelicCapacitorPluginPlugin {
  start(options: { appKey: string, agentConfiguration?: AgentConfiguration}): void;
  setUserId(options: { userId: string }): void;
  setAttribute(options:{name: string, value: string}): void;
  removeAttribute(options:{name: string}): void;
  recordBreadcrumb(options:{name: string, eventAttributes: object}): void;
  recordCustomEvent(options:{eventType: string, eventName: string, attributes: object}): void;
  startInteraction(options:{value: string}): Promise<{ value: string }>;
  endInteraction(options:{interactionId: string}): void;
  crashNow(options?: {message: string}): void;
  currentSessionId(options?: {}): Promise<{sessionId: string}>;
  incrementAttribute(options: {name: string, value?: number}): void;
  noticeNetworkFailure(options: {
    url: string, 
    method: string, 
    startTime: number, 
    endTime: number, 
    failure:string
  }): void;
  noticeHttpTransaction(options: {
    url: string, 
    method: string, 
    status: number, 
    startTime: number, 
    endTime: number, 
    bytesSent: number, 
    bytesReceived: number, 
    body: string,
    traceAttributes?: object,
    params?: object
  }): void;
  recordMetric(options: {
    name: string,
    category: string,
    value?: number, 
    countUnit?: string,
    valueUnit?: string,
  }): void;
  removeAllAttributes(options?: {}): void;
  setMaxEventBufferTime(options: {maxBufferTimeInSeconds: number}): void;
  setMaxEventPoolSize(options: {maxPoolSize: number}): void;
  setMaxOfflineStorageSize(options: {megaBytes: number}): void;
  recordError(options: {
    name: string;
    message: string;
    stack: string;
    isFatal: boolean;
    attributes?: object;
  }): void;
  analyticsEventEnabled(options: {enabled: boolean}): void;
  networkRequestEnabled(options: {enabled: boolean}): void;
  networkErrorRequestEnabled(options: {enabled: boolean}): void;
  httpResponseBodyCaptureEnabled(options: {enabled: boolean}): void;
  getAgentConfiguration(options?: {}) : Promise<AgentConfiguration>;
  shutdown(options?: {}): void;
  generateDistributedTracingHeaders(options?: {}): Promise<DTHeaders>;
  addHTTPHeadersTrackingFor(options:{headers: string[]}): void;
  getHTTPHeadersTrackingFor(): Promise<HttpHeadersTracking>;

}

export interface AgentConfiguration {
  analyticsEventEnabled?: boolean
  crashReportingEnabled?: boolean
  interactionTracingEnabled?: boolean
  networkRequestEnabled?: boolean
  networkErrorRequestEnabled?: boolean
  httpResponseBodyCaptureEnabled?: boolean
  webViewInstrumentation?: boolean
  loggingEnabled?: boolean
  logLevel?: string
  collectorAddress?: string
  crashCollectorAddress?: string
  sendConsoleEvents?: boolean
  fedRampEnabled?: boolean
  offlineStorageEnabled?: boolean
  backgroundReportingEnabled?: boolean
  newEventSystemEnabled?: boolean
}

export interface DTHeaders {
  guid?: string
  id?: string
  newrelic?: string
  traceid?: string
  traceparent?: string
  tracestate?: string
}

export interface HttpHeadersTracking {
  headersList: string
}

export namespace NREnums {
  export enum LogLevel {
      ERROR = "ERROR",
      WARNING = "WARNING",
      INFO = "INFO",
      VERBOSE = "VERBOSE",
      AUDIT = "AUDIT",
  }
  export enum NetworkFailure {
      Unknown = 'Unknown',
      BadURL = 'BadURL',
      TimedOut = 'TimedOut',
      CannotConnectToHost = 'CannotConnectToHost',
      DNSLookupFailed = 'DNSLookupFailed',
      BadServerResponse = 'BadServerResponse',
      SecureConnectionFailed = 'SecureConnectionFailed',
  }
  export enum MetricUnit  {
      PERCENT = 'PERCENT',
      BYTES = 'BYTES',
      SECONDS = 'SECONDS',
      BYTES_PER_SECOND = 'BYTES_PER_SECOND',
      OPERATIONS = 'OPERATIONS',
  }
}
