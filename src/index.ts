import { registerPlugin } from '@capacitor/core';

import type { NewRelicCapacitorPluginPlugin } from './definitions';

const NewRelicCapacitorPlugin = registerPlugin<NewRelicCapacitorPluginPlugin>(
  'NewRelicCapacitorPlugin',
  {
    web: () => import('./web').then(m => new m.NewRelicCapacitorPluginWeb()),
  },
);

export * from './definitions';
export { NewRelicCapacitorPlugin };

const defaultLog = window.console.log;
const defaultWarn = window.console.warn;
const defaultError = window.console.error;

console.log = function() {
  var msgs = [];

  while(arguments.length) {
    msgs.push("[]" + ': ' + [].shift.call(arguments));
}
  defaultLog.apply(console,msgs);
};
console.warn = function() {
  var msgs = [];

  while(arguments.length) {
    msgs.push("[]" + ': ' + [].shift.call(arguments));
  }
  defaultWarn.apply(console,msgs);
};
console.error = function() {
  var msgs = [];

  while(arguments.length) {
    msgs.push("[]" + ': ' + [].shift.call(arguments));
  }
  defaultError.apply(console,msgs);
};