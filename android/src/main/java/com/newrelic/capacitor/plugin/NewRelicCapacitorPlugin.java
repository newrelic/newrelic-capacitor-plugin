/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

package com.newrelic.capacitor.plugin;

import android.util.Log;

public class NewRelicCapacitorPlugin {

    public String echo(String value) {
        Log.i("Echo", value);
        return value;
    }
}
