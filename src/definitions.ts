export interface NewRelicCapacitorPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
