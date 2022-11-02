import { WebPlugin } from '@capacitor/core';

import type { NewRelicCapacitorPluginPlugin } from './definitions';

export class NewRelicCapacitorPluginWeb
  extends WebPlugin
  implements NewRelicCapacitorPluginPlugin
{
  start(options: { appKey: string; }): void {
    return;
  }
  async startInteraction(options: { value: string }): Promise<{ value: string; }> {
    return options;
  }
 
  endInteraction(options: { interactionId: string }): void {
    return
  }
  
  
  setAttribute(optins: { name: any; value: any }): void {
    return
  }
  removeAttribute(options: { name: any }): void {
    return
  }
  setUserId(options: { userId: string }): void {
    return ;
  }

  recordBreadcrumb(options:{name: any, eventAttributes: object}): void {
    throw new Error('Method not implemented.');
  }
  recordCustomEvent(options:{eventType: any, eventName: any, attributes: object}): void {
    throw new Error('Method not implemented.');
  }

  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}

const defaultLog = window.console.log;
const defaultWarn = window.console.warn;
const defaultError = window.console.error;

console.log = function() {
  defaultLog.apply(console, );
};
console.warn = function() {
  defaultWarn.apply(console);
};
console.error = function() {
  defaultError.apply(console);
};
