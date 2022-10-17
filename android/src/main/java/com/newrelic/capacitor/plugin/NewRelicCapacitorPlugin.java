package com.newrelic.capacitor.plugin;

import android.util.Log;

public class NewRelicCapacitorPlugin {

    public String echo(String value) {
        Log.i("Echo", value);
        return value;
    }
}
