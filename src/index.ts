/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

import { registerPlugin } from '@capacitor/core';

import type { NewRelicCapacitorPluginPlugin } from './definitions';
import getCircularReplacer from './circular-replacer';

const NewRelicCapacitorPlugin = registerPlugin<NewRelicCapacitorPluginPlugin>(
  'NewRelicCapacitorPlugin',
  {
    web:()=> import('./web').then(m=>new m.NewRelicCapacitorPluginWeb())
  },
);

export * from './definitions';
export { NewRelicCapacitorPlugin };

const defaultLog = window.console.log;
const defaultWarn = window.console.warn;
const defaultError = window.console.error;

console.log = function () {
  var msgs = [];

  while (arguments.length) {
    var copyArguments = Object.assign({}, arguments);
    msgs.push('[]' + ': ' + [].shift.call(arguments));
    sendConsole('log', copyArguments);
  }
  defaultLog.apply(console, msgs);
};
console.warn = function () {
  var msgs = [];

  while (arguments.length) {
    var copyArguments = Object.assign({}, arguments);
    msgs.push('[]' + ': ' + [].shift.call(arguments));
    sendConsole('warn', copyArguments);
  }
  defaultWarn.apply(console, msgs);
};
console.error = function () {
  var msgs = [];

  while (arguments.length) {
    var copyArguments = Object.assign({}, arguments);
    msgs.push('[]' + ': ' + [].shift.call(arguments));
    sendConsole('error', copyArguments);
  }
  defaultError.apply(console, msgs);
};

function sendConsole(consoleType: string, _arguments: any) {
  NewRelicCapacitorPlugin.getAgentConfiguration().then((agentConfig) => {
    if (agentConfig.sendConsoleEvents) {
      const argsStr = JSON.stringify(_arguments, getCircularReplacer());
      NewRelicCapacitorPlugin.recordCustomEvent({
        eventType: 'consoleEvents',
        eventName: 'JSConsole',
        attributes: { consoleType: consoleType, args: argsStr },
      });
    }
  });
}

window.addEventListener('error', event => {
  NewRelicCapacitorPlugin.recordError({
    name: event.error.name,
    message: event.error.message,
    stack: event.error.stack,
    isFatal: true,
  });
});


window.addEventListener('unhandledrejection', e => {
  var err = new Error(e.reason);
  NewRelicCapacitorPlugin.recordError({
    name: err.name,
    message: err.message,
    stack: 'no stack',
    isFatal: false,
  });

});

type NetworkRequest = {
  url: string;
  method: string;
  bytesSent: number;
  startTime: number;
  endTime?: number;
  status?: number;
  bytesreceived?: number;
  body: string;
};

const networkRequest: NetworkRequest = {
  url: "",
  method: "",
  body: "",
  bytesSent: 0,
  startTime: 0,
};

const originalXhrOpen = XMLHttpRequest.prototype.open;
const originalXhrSend = XMLHttpRequest.prototype.send;

window.XMLHttpRequest.prototype.open = function (
  method: string,
  url: string
): void {
  networkRequest.url = url;
  networkRequest.method = method;
  networkRequest.bytesSent = 0;
  networkRequest.startTime = Date.now();
  return originalXhrOpen.apply(this, arguments as any);
};

const oldFetch = window.fetch;

window.fetch = function fetch() {
  var _arguments = arguments;
  var urlOrRequest = arguments[0];
  var options = arguments[1];

  networkRequest.startTime = Date.now();
  if (urlOrRequest && typeof urlOrRequest === 'object') {
    networkRequest.url = urlOrRequest.url;

    if (options && 'method' in options) {
     networkRequest. method = options.method;
    } else if (urlOrRequest && 'method' in urlOrRequest) {
      networkRequest.method = urlOrRequest.method;
    }
  } else {
    networkRequest.url = urlOrRequest;

    if (options && 'method' in options) {
      networkRequest.method = options.method;
    }
  }

  if (networkRequest.method === undefined || networkRequest.method === "" ) {
    networkRequest.method = 'GET';
  }

  return new Promise(function (resolve, reject) {
    // pass through to native fetch
    oldFetch.apply(void 0, _arguments as any).then(function (response) {
      handleFetchSuccess(response, networkRequest.method, networkRequest.url,networkRequest.startTime);
      resolve(response);
    })["catch"](function (error) {
      NewRelicCapacitorPlugin.recordError(error);
      reject(error);
    });
  });
};
window.XMLHttpRequest.prototype.send = function (
): void {
  if (this.addEventListener) {
    this.addEventListener(
      "readystatechange",
      async () => {
        if (this.readyState === this.HEADERS_RECEIVED) {
          if (this.getAllResponseHeaders()) {
            const responseHeaders =
              this.getAllResponseHeaders().split("\r\n");
            const responseHeadersDictionary: {
              [key: string]: string | undefined;
            } = {};
            responseHeaders.forEach((element) => {
              const key = element.split(":")[0];
              const value = element.split(":")[1];
              responseHeadersDictionary[key] = value;
            });
          }
        }
        if (this.readyState === this.DONE) {
          networkRequest.endTime = Date.now();
          networkRequest.status = this.status;

          const type = this.responseType;
          if (type === "arraybuffer") {
            networkRequest.bytesreceived = this.response.byteLength as number;
          } else if (type === "blob") {
            networkRequest.bytesreceived = this.response.size as number;
          } else if (type === "text" || type === "" || type === undefined) {
            networkRequest.bytesreceived = this.responseText.length;
            networkRequest.body = this.responseText;
          } else {
            // unsupported response type
            networkRequest.bytesreceived = 0;
          }

          NewRelicCapacitorPlugin.noticeHttpTransaction({
            url:networkRequest.url,
            method:networkRequest.method,
            status:networkRequest.status,
            startTime:networkRequest.startTime,
            endTime:networkRequest.endTime,
            bytesSent:networkRequest.bytesSent,
            bytesReceived:networkRequest.bytesreceived,
            body:networkRequest.body
          }
          );
        }
      },
      false
    );
  }
  return originalXhrSend.apply(this, arguments as any);
};

function handleFetchSuccess(response: Response, method: string, url: string, startTime: number) {
  NewRelicCapacitorPlugin.noticeHttpTransaction({
    url:url,
    method:method,
    status:response.status,
    startTime:startTime,
    endTime:Date.now(),
    bytesSent:0,
    bytesReceived:0,
    body:""
  }
  );

}


