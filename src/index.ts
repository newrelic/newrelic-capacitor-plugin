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
