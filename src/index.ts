/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

import { registerPlugin } from '@capacitor/core';

import type { NewRelicCapacitorPluginPlugin } from './definitions';

const NewRelicCapacitorPlugin = registerPlugin<NewRelicCapacitorPluginPlugin>(
  'NewRelicCapacitorPlugin',
  {
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
    sendConsole('log',copyArguments);
  }
  defaultLog.apply(console, msgs);
};
console.warn = function () {
  var msgs = [];

  while (arguments.length) {
    var copyArguments = Object.assign({}, arguments);
    msgs.push('[]' + ': ' + [].shift.call(arguments));
    sendConsole('warn',copyArguments);

  }
  defaultWarn.apply(console, msgs);
};
console.error = function () {
  var msgs = [];

  while (arguments.length) {
    var copyArguments = Object.assign({}, arguments);
    msgs.push('[]' + ': ' + [].shift.call(arguments));
    sendConsole('error',copyArguments);
  }
  defaultError.apply(console, msgs);
};

function sendConsole(consoleType:string,_arguments:any) {

  const argsStr = JSON.stringify(_arguments);
    NewRelicCapacitorPlugin.recordCustomEvent({
      eventType: 'consoleEvents',
      eventName: 'JSConsole',
      attributes: { consoleType: consoleType, args: argsStr },
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
