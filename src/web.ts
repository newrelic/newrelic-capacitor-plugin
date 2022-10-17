import { WebPlugin } from '@capacitor/core';

import type { NewRelicCapacitorPluginPlugin } from './definitions';

export class NewRelicCapacitorPluginWeb
  extends WebPlugin
  implements NewRelicCapacitorPluginPlugin
{
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
