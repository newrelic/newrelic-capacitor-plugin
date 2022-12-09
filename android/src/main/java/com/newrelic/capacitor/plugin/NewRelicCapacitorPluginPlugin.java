/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

package com.newrelic.capacitor.plugin;

import android.Manifest;
import android.util.Log;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.newrelic.agent.android.ApplicationFramework;
import com.newrelic.agent.android.FeatureFlag;
import com.newrelic.agent.android.NewRelic;
import com.newrelic.agent.android.metric.MetricUnit;
import com.newrelic.agent.android.stats.StatsEngine;
import com.newrelic.agent.android.util.NetworkFailure;
import com.newrelic.com.google.gson.Gson;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

@CapacitorPlugin(name = "NewRelicCapacitorPlugin", permissions = {
        @Permission(strings = { Manifest.permission.ACCESS_NETWORK_STATE }, alias = "network"),
        @Permission(strings = { Manifest.permission.INTERNET }, alias = "internet") })
public class NewRelicCapacitorPluginPlugin extends Plugin {

    private final NewRelicCapacitorPlugin implementation = new NewRelicCapacitorPlugin();

    @Override
    public void load() {
        super.load();
    }

    @PluginMethod
    public void start(PluginCall call) {
        String appKey = call.getString("appKey");

        if(appKey == null) {
            call.reject("Null appKey given to New Relic agent start");
            return;
        }

        NewRelic.withApplicationToken(appKey)
                .withApplicationFramework(ApplicationFramework.Cordova, "0.0.1")
                .withLoggingEnabled(true)
                .start(this.getActivity().getApplication());
        call.resolve();
    }
    

    @PluginMethod
    public void setUserId(PluginCall call) {
        String value = call.getString("userId");

        if(value == null) {
            call.reject("Null userId given to setUserId");
            return;
        }

        NewRelic.setUserId(value);
        call.resolve();
    }

    @PluginMethod
    public void setAttribute(PluginCall call) {
        String name = call.getString("name");
        String value = call.getString("value");

        if(name == null || value == null) {
            call.reject("Null name or value given to setAttribute");
            return;
        }

        NewRelic.setAttribute(name, value);
        call.resolve();
    }

    @PluginMethod
    public void removeAttribute(PluginCall call) {
        String name = call.getString("name");

        if(name == null) {
            call.reject("Null name given to removeAttribute");
            return;
        }

        NewRelic.removeAttribute(name);
        call.resolve();
    }

    @PluginMethod
    public void recordBreadcrumb(PluginCall call) {
        String name = call.getString("name");
        JSONObject eventAttributes = call.getObject("eventAttributes");

        if(name == null) {
            call.reject("Null name given to recordBreadcrumb");
            return;
        }

        Map yourHashMap = new Gson().fromJson(String.valueOf(eventAttributes), Map.class);

        NewRelic.recordBreadcrumb(name, yourHashMap);
        call.resolve();
    }

    @PluginMethod
    public void recordCustomEvent(PluginCall call) {
        String name = call.getString("eventName");
        String eventType = call.getString("eventType");
        JSONObject attributes = call.getObject("attributes");

        if(eventType == null) {
            call.reject("Null eventType given to recordCustomEvent");
            return;
        }

        Map yourHashMap = new Gson().fromJson(String.valueOf(attributes), Map.class);

        NewRelic.recordCustomEvent(eventType, name, yourHashMap);
        call.resolve();
    }

    @PluginMethod
    public void startInteraction(PluginCall call) {
        String actionName = call.getString("value");

        if(actionName == null) {
            call.reject("Null value given to startInteraction");
            return;
        }

        JSObject ret = new JSObject();
        ret.put("value", NewRelic.startInteraction(actionName));
        call.resolve(ret);
    }

    @PluginMethod
    public void endInteraction(PluginCall call) {
        String interactionId = call.getString("interactionId");

        if(interactionId == null) {
            call.reject("Null interactionId given to endInteraction");
            return;
        }

        NewRelic.endInteraction(interactionId);
        call.resolve();
    }

    @PluginMethod
    public void crashNow(PluginCall call) {
        String message = call.getString("message");
        if (message == null) {
            NewRelic.crashNow();
        } else {
            NewRelic.crashNow(message);
        }
        call.resolve();
    }

    @PluginMethod
    public void currentSessionId(PluginCall call) {
        JSObject ret = new JSObject();
        ret.put("sessionId", NewRelic.currentSessionId());
        call.resolve(ret);
    }

    @PluginMethod
    public void incrementAttribute(PluginCall call) {
        String name = call.getString("name");
        Double value = call.getDouble("value");

        if (name == null) {
            call.reject("Bad name in incrementAttribute");
            return;
        }

        if (value == null) {
            NewRelic.incrementAttribute(name);
        } else {
            NewRelic.incrementAttribute(name, value);
        }
        call.resolve();
    }

    @PluginMethod
    public void noticeHttpTransaction(PluginCall call) {
        String url = call.getString("url");
        String method = call.getString("method");
        Integer status = call.getInt("status");
        Long startTime = call.getLong("startTime");
        Long endTime = call.getLong("endTime");
        Integer bytesSent = call.getInt("bytesSent");
        Integer bytesReceived = call.getInt("bytesReceived");
        String body = call.getString("body");

        if (url == null ||
                method == null ||
                status == null ||
                startTime == null ||
                endTime == null ||
                bytesSent == null ||
                bytesReceived == null) {
            call.reject("Bad parameters given to noticeHttpTransaction");
            return;
        }

        NewRelic.noticeHttpTransaction(url, method, status, startTime, endTime, bytesSent, bytesReceived, body);
        call.resolve();
    }

    @PluginMethod
    public void noticeNetworkFailure(PluginCall call) {
        String url = call.getString("url");
        String method = call.getString("method");
        Integer status = call.getInt("status");
        Long startTime = call.getLong("startTime");
        Long endTime = call.getLong("endTime");
        String failure = call.getString("failure");

        if (url == null ||
                method == null ||
                status == null ||
                startTime == null ||
                endTime == null ||
                failure == null) {
            call.reject("Bad parameters given to noticeNetworkFailure");
            return;
        }

        Map<String, NetworkFailure> strToNetworkFailure = new HashMap<>();
        strToNetworkFailure.put("Unknown", NetworkFailure.Unknown);
        strToNetworkFailure.put("BadURL", NetworkFailure.BadURL);
        strToNetworkFailure.put("TimedOut", NetworkFailure.TimedOut);
        strToNetworkFailure.put("CannotConnectToHost", NetworkFailure.CannotConnectToHost);
        strToNetworkFailure.put("BadServerResponse", NetworkFailure.BadServerResponse);
        strToNetworkFailure.put("SecureConnectionFailed", NetworkFailure.SecureConnectionFailed);

        if (strToNetworkFailure.containsKey(failure)) {
            NewRelic.noticeNetworkFailure(url, method, status, startTime, strToNetworkFailure.get(failure));
            call.resolve();
        } else {
            call.reject(
                    "Bad failure name in noticeNetworkFailure. Must be one of: Unknown, BadURL, TimedOut, CannotConnectToHost, BadServerResponse, SecureConnectionFailed");
        }
    }

    @PluginMethod
    public void recordMetric(PluginCall call) {
        String name = call.getString("name");
        String category = call.getString("category");
        Double value = call.getDouble("value");
        String countUnit = call.getString("countUnit");
        String valueUnit = call.getString("valueUnit");

        if (name == null || category == null) {
            call.reject("Bad name or category in recordMetric");
            return;
        }

        if (value == null) {
            NewRelic.recordMetric(name, category);
            call.resolve();
        } else {
            if (countUnit == null && valueUnit == null) {
                NewRelic.recordMetric(name, category, value);
                call.resolve();
            } else {
                if (countUnit == null || valueUnit == null) {
                    call.reject("Both countUnit and valueUnit must be set in recordMetric");
                } else {
                    Map<String, MetricUnit> strToMetricUnit = new HashMap<>();
                    strToMetricUnit.put("PERCENT", MetricUnit.PERCENT);
                    strToMetricUnit.put("BYTES", MetricUnit.BYTES);
                    strToMetricUnit.put("SECONDS", MetricUnit.SECONDS);
                    strToMetricUnit.put("BYTES_PER_SECOND", MetricUnit.BYTES_PER_SECOND);
                    strToMetricUnit.put("OPERATIONS", MetricUnit.OPERATIONS);

                    if (strToMetricUnit.containsKey(countUnit) && strToMetricUnit.containsKey(valueUnit)) {
                        NewRelic.recordMetric(name, category, 1, value, value, strToMetricUnit.get(countUnit),
                                strToMetricUnit.get(valueUnit));
                        call.resolve();
                    } else {
                        call.reject(
                                "Bad countUnit or valueUnit in recordMetric. Must be one of: PERCENT, BYTES, SECONDS, BYTES_PER_SECOND, OPERATIONS");
                    }
                }
            }
        }
    }

    @PluginMethod
    public void removeAllAttributes(PluginCall call) {
        NewRelic.removeAllAttributes();
        call.resolve();
    }

    @PluginMethod
    public void setMaxEventBufferTime(PluginCall call) {
        Integer maxEventBufferTimeInSeconds = call.getInt("maxBufferTimeInSeconds");

        if (maxEventBufferTimeInSeconds == null) {
            call.reject("Bad maxBufferTimeInSeconds in setMaxEventBufferTime");
            return;
        }

        NewRelic.setMaxEventBufferTime(maxEventBufferTimeInSeconds);
        call.resolve();
    }

    @PluginMethod
    public void setMaxEventPoolSize(PluginCall call) {
        Integer maxPoolSize = call.getInt("maxPoolSize");

        if (maxPoolSize == null) {
            call.reject("Bad maxPoolSize in setMaxEventPoolSize");
            return;
        }

        NewRelic.setMaxEventPoolSize(maxPoolSize);
        call.resolve();
    }

    @PluginMethod
    public void recordError(PluginCall call) {
        String name = call.getString("name");
        String message = call.getString("message");
        String stack = call.getString("stack");
        Boolean isFatal = call.getBoolean("isFatal");

        if (name == null || stack == null) {
            call.reject("name should not be empty");
            return;
        }

        try {

            Map<String, Object> crashEvents = new HashMap<>();
            crashEvents.put("Name", name);
            crashEvents.put("Message", message);
            crashEvents.put("isFatal", isFatal);
            if (stack != null) {
                // attribute limit is 4096
                crashEvents.put("errorStack",
                        stack.length() > 4095 ? stack.substring(0, 4094) : stack);
            }

            NewRelic.recordBreadcrumb("JS Errors", crashEvents);
            NewRelic.recordCustomEvent("JS Errors", "JS Errors", crashEvents);

            StatsEngine.get().inc("Supportability/Mobile/Capacitor/JSError");

        } catch (IllegalArgumentException e) {
            Log.w("NRMA", e.getMessage());
        }
        call.resolve();
    }

    @PluginMethod
    public void analyticsEventEnabled(PluginCall call) {
        Boolean toEnable = call.getBoolean("enabled");

        if(toEnable == null) {
            call.reject("Bad parameter given to analyticsEventEnabled");
            return;
        }

        if(toEnable) {
            NewRelic.enableFeature(FeatureFlag.AnalyticsEvents);
        } else {
            NewRelic.disableFeature(FeatureFlag.AnalyticsEvents);
        }

        call.resolve();
    }

    @PluginMethod
    public void networkRequestEnabled(PluginCall call) {
        Boolean toEnable = call.getBoolean("enabled");

        if(toEnable == null) {
            call.reject("Bad parameter given to networkRequestEnabled");
            return;
        }

        if(toEnable) {
            NewRelic.enableFeature(FeatureFlag.NetworkRequests);
        } else {
            NewRelic.disableFeature(FeatureFlag.NetworkRequests);
        }

        call.resolve();
    }

    @PluginMethod
    public void networkErrorRequestEnabled(PluginCall call) {
        Boolean toEnable = call.getBoolean("enabled");

        if(toEnable == null) {
            call.reject("Bad parameter given to networkErrorRequestEnabled");
            return;
        }

        if(toEnable) {
            NewRelic.enableFeature(FeatureFlag.NetworkErrorRequests);
        } else {
            NewRelic.disableFeature(FeatureFlag.NetworkErrorRequests);
        }

        call.resolve();
    }

    @PluginMethod
    public void httpRequestBodyCaptureEnabled(PluginCall call) {
        Boolean toEnable = call.getBoolean("enabled");

        if(toEnable == null) {
            call.reject("Bad parameter given to httpRequestBodyCaptureEnabled");
            return;
        }

        if(toEnable) {
            NewRelic.enableFeature(FeatureFlag.HttpResponseBodyCapture);
        } else {
            NewRelic.disableFeature(FeatureFlag.HttpResponseBodyCapture);
        }

        call.resolve();
    }

}
