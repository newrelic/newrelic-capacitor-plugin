/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

import {registerPlugin} from '@capacitor/core';

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
const defaultAssert = window.console.assert;
const defaultDebug = window.console.debug;

console.log = function () {
  var msgs = [];
  defaultLog(...arguments);
  while (arguments.length) {
    var copyArguments = Object.assign({}, arguments);
    msgs.push('[]' + ': ' + [].shift.call(arguments));
    sendConsole('log', copyArguments);
  }
};
console.warn = function () {
  var msgs = [];
  defaultWarn(...arguments);
  while (arguments.length) {
    var copyArguments = Object.assign({}, arguments);
    msgs.push('[]' + ': ' + [].shift.call(arguments));
    sendConsole('warn', copyArguments);
  }
};
console.error = function () {
  var msgs = [];
  defaultError(...arguments);
  while (arguments.length) {
    var copyArguments = Object.assign({}, arguments);
    msgs.push('[]' + ': ' + [].shift.call(arguments));
    sendConsole('error', copyArguments);
  }
};

console.assert= function () {
  var msgs = [];
  defaultAssert(...arguments);
  while (arguments.length) {
    var copyArguments = Object.assign({}, arguments);
    msgs.push('[]' + ': ' + [].shift.call(arguments));
    sendConsole('assert', copyArguments);
  }
};

console.debug = function () {
  var msgs = [];
  defaultDebug(...arguments);
  while (arguments.length) {
    var copyArguments = Object.assign({}, arguments);
    msgs.push('[]' + ': ' + [].shift.call(arguments));
    sendConsole('debug', copyArguments);
  }
};

function sendConsole(consoleType: string, _arguments: any) {
  NewRelicCapacitorPlugin.getAgentConfiguration().then((agentConfig) => {
    if (agentConfig.sendConsoleEvents) {

      const argsStr = JSON.stringify(_arguments, getCircularReplacer());

      if(consoleType === 'error') {
        NewRelicCapacitorPlugin.logError({message: `[CONSOLE][ERROR]${argsStr}`});
      }else if(consoleType === 'warn') {
        NewRelicCapacitorPlugin.logWarning({message: `[CONSOLE][WARN]${argsStr}`});
      }else if(consoleType === 'debug') {
        NewRelicCapacitorPlugin.logDebug({message: `[CONSOLE][DEBUG]${argsStr}`});
      } else {
        NewRelicCapacitorPlugin.logInfo({message: `[CONSOLE][LOG]${argsStr}`});
      }
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
  headers:any;
  params:any
};

const networkRequest: NetworkRequest = {
  url: "",
  method: "",
  body: "",
  bytesSent: 0,
  startTime: 0,
  headers:[],
  params:{}
};






const oldFetch = window.fetch;

window.fetch = function fetch() {
  var _arguments = arguments;
  var urlOrRequest = arguments[0];
  var options = arguments[1];

 return NewRelicCapacitorPlugin.getHTTPHeadersTrackingFor().then((trackingHeadersList)=>{
  console.log(trackingHeadersList);
  return NewRelicCapacitorPlugin.generateDistributedTracingHeaders().then((headers) => {
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

    return NewRelicCapacitorPlugin.getAgentConfiguration().then((agentConfig) => {
    if(options && 'headers' in options) {

      if(agentConfig.distributedTracingEnabled) {
      options.headers['newrelic'] = headers['newrelic'];
      options.headers['traceparent'] = headers['traceparent'];
      options.headers['tracestate'] = headers['tracestate'];
      }

      JSON.parse(trackingHeadersList["headersList"]).forEach((e: string) => {
        if(options.headers[e] !== undefined) {
          networkRequest.params[e] = options.headers[e];
        }
      });
    } else {
      if(options === undefined) {
        options = {};
      }
      if(agentConfig.distributedTracingEnabled) {
        options['headers']={};
        options.headers['newrelic'] = headers['newrelic'];
        options.headers['traceparent'] = headers['traceparent'];
        options.headers['tracestate'] = headers['tracestate'];
        }
      _arguments[1] = options;
    }

    if(!agentConfig.distributedTracingEnabled){
          headers = {};
    }

    if(options && 'body' in options && options.body !== null && options.body !== undefined) {
      networkRequest.bytesSent = options.body.length;
    } else {
      networkRequest.bytesSent = 0;
    }

    if (networkRequest.method === undefined || networkRequest.method === "" ) {
       networkRequest.method = 'GET';
    }
    return new Promise(function (resolve, reject) {
      // pass through to native fetch
      oldFetch.apply(void 0, _arguments as any).then(function(response) {
        handleFetchSuccess(response.clone(), networkRequest.method, networkRequest.url,networkRequest.startTime,headers,networkRequest.params);
        resolve(response)
      })["catch"](function (error) {
        reject(error);
      });
    });
    });
 });
 });
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

window.XMLHttpRequest.prototype.send = function (
): void {

      if (this.addEventListener) {
        this.addEventListener(
          "readystatechange",
          async () => {
            if (this.readyState === this.OPENED) {

            }
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

              if(isValidURL(networkRequest.url)) {
              NewRelicCapacitorPlugin.noticeHttpTransaction({
                url:networkRequest.url,
                method:networkRequest.method,
                status:networkRequest.status,
                startTime:networkRequest.startTime,
                endTime:networkRequest.endTime,
                bytesSent:networkRequest.bytesSent,
                bytesReceived:networkRequest.bytesreceived,
                body:networkRequest.body,
                traceAttributes:networkRequest.headers,
                params:networkRequest.params
              }
              );
            }
            }
          },
          false
        );
      }
      return originalXhrSend.apply(this, arguments as any);
}

function handleFetchSuccess(response: Response, method: string, url: string, startTime: number,traceAttributes:object,params:object) {

  response.text().then((v)=>{
    if(isValidURL(url)) {
    NewRelicCapacitorPlugin.noticeHttpTransaction({
      url:url,
      method:method,
      status:response.status,
      startTime:startTime,
      endTime:Date.now(),
      bytesSent:networkRequest.bytesSent,
      bytesReceived:v.length,
      body:v,
      traceAttributes:traceAttributes,
      params: params
    }
    );
  }

  });
}

function isValidURL(url: string) {
  try {
    const newUrl = new URL(url);
    return newUrl.protocol === 'http:' || newUrl.protocol === 'https:';
  } catch (err) {
    return false;
  }
}




