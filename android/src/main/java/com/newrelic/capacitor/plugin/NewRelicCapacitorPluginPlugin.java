/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

package com.newrelic.capacitor.plugin;

import android.Manifest;
import android.util.Log;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.newrelic.agent.android.ApplicationFramework;
import com.newrelic.agent.android.FeatureFlag;
import com.newrelic.agent.android.HttpHeaders;
import com.newrelic.agent.android.NewRelic;
import com.newrelic.agent.android.distributedtracing.TraceContext;
import com.newrelic.agent.android.distributedtracing.TracePayload;
import com.newrelic.agent.android.logging.LogLevel;
import com.newrelic.agent.android.logging.LogReporting;
import com.newrelic.agent.android.metric.MetricUnit;
import com.newrelic.agent.android.logging.AgentLog;
import com.newrelic.agent.android.util.NetworkFailure;
import com.newrelic.com.google.gson.Gson;
import com.newrelic.com.google.gson.JsonArray;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@CapacitorPlugin(name = "NewRelicCapacitorPlugin", permissions = {
        @Permission(strings = { Manifest.permission.ACCESS_NETWORK_STATE }, alias = "network"),
        @Permission(strings = { Manifest.permission.INTERNET }, alias = "internet") })
public class NewRelicCapacitorPluginPlugin extends Plugin {

    private final NewRelicCapacitorPlugin implementation = new NewRelicCapacitorPlugin();
    private static final String TAG = "NewRelicCapacitorPlugin";
    private AgentConfig agentConfig;
    private static class AgentConfig {
        boolean analyticsEventEnabled;
        boolean crashReportingEnabled;
        boolean interactionTracingEnabled;
        boolean networkRequestEnabled;
        boolean networkErrorRequestEnabled;
        boolean httpResponseBodyCaptureEnabled;
        boolean loggingEnabled;
        String logLevel;
        String collectorAddress;
        String crashCollectorAddress;
        boolean sendConsoleEvents;
        boolean fedRampEnabled;
        boolean offlineStorageEnabled;
        boolean logReportingEnabled;
        boolean backgroundReportingEnabled;
        boolean distributedTracingEnabled;

        public AgentConfig() {
            this.analyticsEventEnabled = true;
            this.crashReportingEnabled = true;
            this.interactionTracingEnabled = true;
            this.networkRequestEnabled = true;
            this.networkErrorRequestEnabled = true;
            this.httpResponseBodyCaptureEnabled = true;
            this.loggingEnabled = true;
            this.logLevel = "INFO";
            this.collectorAddress = "mobile-collector.newrelic.com";
            this.crashCollectorAddress = "mobile-crash.newrelic.com";
            this.sendConsoleEvents = true;
            this.fedRampEnabled = false;
            this.offlineStorageEnabled = true;
            this.backgroundReportingEnabled = false;
            this.distributedTracingEnabled = true;
        }
    }

    private final Pattern chromeStackTraceRegex =
            Pattern.compile("^\\s*at (.*?) ?\\(((?:file|https?|blob|chrome-extension|native|eval|webpack|<anonymous>|\\/|[a-z]:\\\\|\\\\\\\\).*?)(?::(\\d+))?(?::(\\d+))?\\)?\\s*$",
                    Pattern.CASE_INSENSITIVE);
    private final Pattern nodeStackTraceRegex =
            Pattern.compile("^\\s*at (?:((?:\\[object object\\])?[^\\\\/]+(?: \\[as \\S+\\])?) )?\\(?(.*?):(\\d+)(?::(\\d+))?\\)?\\s*$",
                    Pattern.CASE_INSENSITIVE);

    protected static final class NRTraceConstants {
        public static final String TRACE_PARENT = "traceparent";
        public static final String TRACE_STATE = "tracestate";
        public static final String TRACE_ID = "trace.id";
        public static final String GUID = "guid";
        public static final String ID = "id";
    }

    @Override
    public void load() {
        super.load();
        agentConfig = new AgentConfig();
    }

    @PluginMethod
    public void start(PluginCall call) {
        String appKey = call.getString("appKey");
        JSObject agentConfiguration = call.getObject("agentConfiguration");

        if(appKey == null) {
            call.reject("Null appKey given to New Relic agent start");
            return;
        }

        boolean loggingEnabled = true;
        int logLevel = AgentLog.INFO;
        String collectorAddress = null;
        String crashCollectorAddress = null;

        if(agentConfiguration != null) {

            if(Boolean.FALSE.equals(agentConfiguration.getBool("analyticsEventEnabled"))) {
                NewRelic.disableFeature(FeatureFlag.AnalyticsEvents);
                agentConfig.analyticsEventEnabled = false;
            } else {
                NewRelic.enableFeature(FeatureFlag.AnalyticsEvents);
                agentConfig.analyticsEventEnabled = true;
            }

            if(Boolean.FALSE.equals(agentConfiguration.getBool("crashReportingEnabled"))) {
                NewRelic.disableFeature(FeatureFlag.CrashReporting);
                agentConfig.crashReportingEnabled = false;
            } else {
                NewRelic.enableFeature(FeatureFlag.CrashReporting);
                agentConfig.crashReportingEnabled = true;
            }

            if(Boolean.FALSE.equals(agentConfiguration.getBool("interactionTracingEnabled"))) {
                NewRelic.disableFeature(FeatureFlag.InteractionTracing);
                agentConfig.interactionTracingEnabled = false;
            } else {
                NewRelic.enableFeature(FeatureFlag.InteractionTracing);
                agentConfig.interactionTracingEnabled = true;
            }

            if(Boolean.FALSE.equals(agentConfiguration.getBool("networkRequestEnabled"))) {
                NewRelic.disableFeature(FeatureFlag.NetworkRequests);
                agentConfig.networkRequestEnabled = false;
            } else {
                NewRelic.enableFeature(FeatureFlag.NetworkRequests);
                agentConfig.networkRequestEnabled = true;
            }

            if(Boolean.FALSE.equals(agentConfiguration.getBool("networkErrorRequestEnabled"))) {
                NewRelic.disableFeature(FeatureFlag.NetworkErrorRequests);
                agentConfig.networkErrorRequestEnabled = false;
            } else {
                NewRelic.enableFeature(FeatureFlag.NetworkErrorRequests);
                agentConfig.networkErrorRequestEnabled = true;
            }

            if(Boolean.FALSE.equals(agentConfiguration.getBool("httpResponseBodyCaptureEnabled"))) {
                NewRelic.disableFeature(FeatureFlag.HttpResponseBodyCapture);
                agentConfig.httpResponseBodyCaptureEnabled = false;
            } else {
                NewRelic.enableFeature(FeatureFlag.HttpResponseBodyCapture);
                agentConfig.httpResponseBodyCaptureEnabled = true;
            }


            if(Boolean.FALSE.equals(agentConfiguration.getBool("distributedTracingEnabled"))) {
                NewRelic.disableFeature(FeatureFlag.DistributedTracing);
                agentConfig.distributedTracingEnabled = false;
            } else {
                NewRelic.enableFeature(FeatureFlag.DistributedTracing);
                agentConfig.distributedTracingEnabled = true;
            }

            if(Boolean.TRUE.equals(agentConfiguration.getBool("fedRampEnabled"))) {
                NewRelic.enableFeature(FeatureFlag.FedRampEnabled);
                agentConfig.fedRampEnabled = true;
            } else {
                NewRelic.disableFeature(FeatureFlag.FedRampEnabled);
                agentConfig.fedRampEnabled = false;
            }

            if(Boolean.FALSE.equals(agentConfiguration.getBool("backgroundReportingEnabled"))) {
                NewRelic.disableFeature(FeatureFlag.BackgroundReporting);
                agentConfig.backgroundReportingEnabled = false;
            } else {
                NewRelic.enableFeature(FeatureFlag.BackgroundReporting);
                agentConfig.backgroundReportingEnabled = true;
            }


            if(agentConfiguration.getBool("loggingEnabled") != null) {
                loggingEnabled = Boolean.TRUE.equals(agentConfiguration.getBool("loggingEnabled"));
                agentConfig.loggingEnabled = loggingEnabled;
            }


            if(agentConfiguration.getString("logLevel") != null) {
                Map<String, Integer> strToLogLevel = new HashMap<>();
                strToLogLevel.put("ERROR", AgentLog.ERROR);
                strToLogLevel.put("WARNING", AgentLog.WARN);
                strToLogLevel.put("INFO", AgentLog.INFO);
                strToLogLevel.put("VERBOSE", AgentLog.VERBOSE);
                strToLogLevel.put("AUDIT", AgentLog.AUDIT);

                Integer configLogLevel = strToLogLevel.get(agentConfiguration.getString("logLevel"));
                if(configLogLevel != null) {
                    logLevel = configLogLevel;
                    agentConfig.logLevel = agentConfiguration.getString("logLevel");
                }

            }

            String newCollectorAddress = agentConfiguration.getString("collectorAddress");
            if(newCollectorAddress != null && !newCollectorAddress.isEmpty()) {
                collectorAddress = newCollectorAddress;
                agentConfig.collectorAddress = newCollectorAddress;
            }

            String newCrashCollectorAddress = agentConfiguration.getString("crashCollectorAddress");
            if(newCrashCollectorAddress != null && !newCrashCollectorAddress.isEmpty()) {
                crashCollectorAddress = newCrashCollectorAddress;
                agentConfig.crashCollectorAddress = newCrashCollectorAddress;
            }

            if(agentConfiguration.getBool("sendConsoleEvents") != null) {
                agentConfig.sendConsoleEvents = Boolean.TRUE.equals(agentConfiguration.getBool("sendConsoleEvents"));
            } 
            
            if(Boolean.FALSE.equals(agentConfiguration.getBool("offlineStorageEnabled"))) {
                NewRelic.disableFeature(FeatureFlag.OfflineStorage);
                agentConfig.offlineStorageEnabled = false;
            } else {
                NewRelic.enableFeature(FeatureFlag.OfflineStorage);
                agentConfig.offlineStorageEnabled = true;
            }
         

        }

        // Use default collector addresses if not set
        if(collectorAddress == null && crashCollectorAddress == null) {
            NewRelic.withApplicationToken(appKey)
                    .withApplicationFramework(ApplicationFramework.Capacitor, "1.5.15")
                    .withLoggingEnabled(loggingEnabled)
                    .withLogLevel(logLevel)
                    .start(this.getActivity().getApplication());
        } else {
            if(collectorAddress == null) {
                collectorAddress = "mobile-collector.newrelic.com";
            }
            if(crashCollectorAddress == null) {
                crashCollectorAddress = "mobile-crash.newrelic.com";
            }
            NewRelic.withApplicationToken(appKey)
                    .withApplicationFramework(ApplicationFramework.Capacitor, "1.5.15")
                    .withLoggingEnabled(loggingEnabled)
                    .withLogLevel(logLevel)
                    .usingCollectorAddress(collectorAddress)
                    .usingCrashCollectorAddress(crashCollectorAddress)
                    .start(this.getActivity().getApplication());
        }

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
    public void addHTTPHeadersTrackingFor(PluginCall call) {
        JSArray headersArray = call.getArray("headers");

        List headersList = new Gson().fromJson(String.valueOf(headersArray), List.class);



        NewRelic.addHTTPHeadersTrackingFor(headersList);
        call.resolve();
    }

    @PluginMethod
    public void getHTTPHeadersTrackingFor(PluginCall call) {

        JSObject headers = new JSObject();
        List<String> arr = new ArrayList<>(HttpHeaders.getInstance().getHttpHeaders());
        JsonArray array = new JsonArray();
        for(int i=0 ;i < arr.size();i++) {
            array.add(arr.get(i));
        }
        headers.put("headersList",array);
        call.resolve(headers);
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

        JSONObject traceAttributes = call.getObject("traceAttributes");
        Map<String, Object> traceHeadersMap = new HashMap<String, Object>();
        if (traceAttributes != null) {
          traceHeadersMap = new Gson().fromJson(String.valueOf(traceAttributes), Map.class);
        }

        JSONObject params = call.getObject("params");
        Map<String, String> paramsMap = new HashMap<>();
        if (params != null) {
            paramsMap = new Gson().fromJson(String.valueOf(params), Map.class);
        }

        NewRelic.noticeHttpTransaction(url, method, status, startTime, endTime, bytesSent, bytesReceived, body, paramsMap, null, traceHeadersMap);
        call.resolve();
    }

    @PluginMethod
    public void noticeNetworkFailure(PluginCall call) {
        String url = call.getString("url");
        String method = call.getString("method");
        Long startTime = call.getLong("startTime");
        Long endTime = call.getLong("endTime");
        String failure = call.getString("failure");

        if (url == null ||
                method == null ||
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
        strToNetworkFailure.put("DNSLookupFailed", NetworkFailure.DNSLookupFailed);
        strToNetworkFailure.put("BadServerResponse", NetworkFailure.BadServerResponse);
        strToNetworkFailure.put("SecureConnectionFailed", NetworkFailure.SecureConnectionFailed);

        NewRelic.noticeNetworkFailure(url, method, startTime, endTime,strToNetworkFailure.get(failure));
        call.resolve();
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
    public void setMaxOfflineStorageSize(PluginCall call) {
        Integer megabytes = call.getInt("megaBytes");

        if (megabytes == null) {
            call.reject("Bad megabytes in setMaxOfflineStorageSize");
            return;
        }

        NewRelic.setMaxEventPoolSize(megabytes);
        call.resolve();
    }

    public StackTraceElement[] parseStackTrace(String stack) {
        String[] lines = stack.split("\n");
        ArrayList<StackTraceElement> stackTraceList = new ArrayList<>();

        for (String line : lines) {
            Matcher chromeMatcher = chromeStackTraceRegex.matcher(line);
            Matcher nodeMatcher = nodeStackTraceRegex.matcher(line);
            if (chromeMatcher.matches() || nodeMatcher.matches()){
                Matcher matcher = chromeMatcher.matches() ? chromeMatcher : nodeMatcher;
                try {
                    String method = matcher.group(1) == null ? " " : matcher.group(1);
                    String file = matcher.group(2) == null ? " " : matcher.group(2);
                    int lineNumber = matcher.group(3) == null ? 1 : Integer.parseInt(matcher.group(3));
                    stackTraceList.add(new StackTraceElement("", method, file, lineNumber));
                } catch (Exception e) {
                    NewRelic.recordHandledException(e);
                    return new StackTraceElement[0];
                }
            }
        }

        return stackTraceList.toArray(new StackTraceElement[0]);
    }

    @PluginMethod
    public void recordError(PluginCall call) {
        String name = call.getString("name");
        String message = call.getString("message");
        String stack = call.getString("stack");
        Boolean isFatal = call.getBoolean("isFatal");

        // We do not reject calls in this method since it will cause an infinite loop with the error listener.
        name = (name == null) ? "null" : name;
        message = (message == null) ? "null" : message;

        HashMap<String, Object> exceptionMap = new HashMap<>();
        exceptionMap.put("name", name);
        exceptionMap.put("message", message);
        exceptionMap.put("isFatal", isFatal);

        stack = (stack == null) ? "null" : stack;

        StackTraceElement[] stackFrames = parseStackTrace(stack);
        JSONObject customAttributes = call.getObject("attributes");
        if(customAttributes != null) {
            Map yourHashMap = new Gson().fromJson(String.valueOf(customAttributes), Map.class);
            exceptionMap.putAll(yourHashMap);
        }
        NewRelicCapacitorException exception = new NewRelicCapacitorException(message, stackFrames);
        NewRelic.recordHandledException(exception, exceptionMap);

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

        if(agentConfig != null) {
            agentConfig.analyticsEventEnabled = toEnable;
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

        if(agentConfig != null) {
            agentConfig.networkRequestEnabled = toEnable;
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

        if(agentConfig != null) {
            agentConfig.networkErrorRequestEnabled = toEnable;
        }

        call.resolve();
    }

    @PluginMethod
    public void httpResponseBodyCaptureEnabled(PluginCall call) {
        Boolean toEnable = call.getBoolean("enabled");

        if(toEnable == null) {
            call.reject("Bad parameter given to httpResponseBodyCaptureEnabled");
            return;
        }

        if(toEnable) {
            NewRelic.enableFeature(FeatureFlag.HttpResponseBodyCapture);
        } else {
            NewRelic.disableFeature(FeatureFlag.HttpResponseBodyCapture);
        }

        if(agentConfig != null) {
            agentConfig.httpResponseBodyCaptureEnabled = toEnable;
        }

        call.resolve();
    }

    @PluginMethod
    public void getAgentConfiguration(PluginCall call) {
        JSObject ret = new JSObject();
        // Returns empty object if plugin not loaded
        if (agentConfig != null) {
            ret.put("analyticsEventEnabled", agentConfig.analyticsEventEnabled);
            ret.put("crashReportingEnabled", agentConfig.crashReportingEnabled);
            ret.put("interactionTracingEnabled", agentConfig.interactionTracingEnabled);
            ret.put("networkRequestEnabled", agentConfig.networkRequestEnabled);
            ret.put("networkErrorRequestEnabled", agentConfig.networkErrorRequestEnabled);
            ret.put("httpResponseBodyCaptureEnabled", agentConfig.httpResponseBodyCaptureEnabled);
            ret.put("logLevel", agentConfig.logLevel);
            ret.put("collectorAddress", agentConfig.collectorAddress);
            ret.put("crashCollectorAddress", agentConfig.crashCollectorAddress);
            ret.put("sendConsoleEvents", agentConfig.sendConsoleEvents);
            ret.put("fedRampEnabled", agentConfig.fedRampEnabled);
            ret.put("offlineStorageEnabled", agentConfig.offlineStorageEnabled);
            ret.put("distributedTracingEnabled", agentConfig.distributedTracingEnabled);


        }
        call.resolve(ret);
    }

    @PluginMethod
    public void shutdown(PluginCall call) {
        NewRelic.shutdown();
        call.resolve();
    }

    @PluginMethod
    public void generateDistributedTracingHeaders(PluginCall call) {

        JSObject dtHeaders = new JSObject();
        TraceContext traceContext = NewRelic.noticeDistributedTrace(null);
        TracePayload tracePayload = traceContext.getTracePayload();

        String headerName = tracePayload.getHeaderName();
        String headerValue = tracePayload.getHeaderValue();
        String spanId = tracePayload.getSpanId();
        String traceId = tracePayload.getTraceId();
        String parentId = traceContext.getParentId();
        String vendor = traceContext.getVendor();
        String accountId = traceContext.getAccountId();
        String applicationId = traceContext.getApplicationId();

        dtHeaders.put(headerName, headerValue);
        dtHeaders.put(NRTraceConstants.TRACE_PARENT, "00-" + traceId + "-" + parentId + "-00");
        dtHeaders.put(NRTraceConstants.TRACE_STATE, vendor + "=0-2-" + accountId + "-" + applicationId + "-" + parentId + "----" + System.currentTimeMillis());
        dtHeaders.put(NRTraceConstants.TRACE_ID, traceId);
        dtHeaders.put(NRTraceConstants.ID, spanId);
        dtHeaders.put(NRTraceConstants.GUID, spanId);

        call.resolve(dtHeaders);
    }

    @PluginMethod
    public void logAttributes(PluginCall call) {
        JSObject attributes = call.getObject("attributes");

        if(attributes == null) {
            call.reject("Null attributes given to logAttributes");
            return;
        }

        Map logAttributes = new Gson().fromJson(String.valueOf(attributes), Map.class);
        logAttributes(logAttributes);
        call.resolve();
    }


    private boolean  log(LogLevel logLevel, String message, PluginCall call) {

        if(message == null || message.isEmpty()) {
            Log.w(TAG, "Empty message given to log");
            call.reject("Empty message given to log");
            return false;
        }

        if(logLevel == null) {
            Log.w(TAG, "Null logLevel given to log");
            call.reject("Null logLevel given to log");
            return false;
        }
        NewRelic.log(logLevel, message);
        return true;
    }
    private boolean logAttributes(Map<String,Object> logAttributes) {

        if(logAttributes.isEmpty()) {
            Log.w(TAG, "Empty attributes given to logAttributes");
            return false;
        }
        NewRelic.logAttributes(logAttributes);
        return true;
    }

    public void log(PluginCall call) {
        String message = call.getString("message");
        String level = call.getString("level");

        Map<String, LogLevel> strToLogLevel = new HashMap<>();
        strToLogLevel.put("ERROR", LogLevel.ERROR);
        strToLogLevel.put("WARNING", LogLevel.WARN);
        strToLogLevel.put("INFO", LogLevel.INFO);
        strToLogLevel.put("VERBOSE", LogLevel.VERBOSE);
        strToLogLevel.put("AUDIT", LogLevel.DEBUG);

        LogLevel logLevel = strToLogLevel.get(level);

        boolean result = log(logLevel, message,call);
        if (result) {
            call.resolve();
        } else {
            call.reject("Empty message or level given to logInfo");
        }
    }



    @PluginMethod
    public void logInfo(PluginCall call) {
        String message = call.getString("message");
        boolean result = log(LogLevel.INFO, message, call);
        if (result) {
            call.resolve();
        } else {
            call.reject("Empty message given to logInfo");
        }
    }

    @PluginMethod
    public void logVerbose(PluginCall call) {
        String message = call.getString("message");
        boolean result = log(LogLevel.VERBOSE, message,call);
        if (result) {
            call.resolve();
        } else {
            call.reject("Empty message given to logVerbose");
        }
    }

    @PluginMethod
    public void logError(PluginCall call) {
        String message = call.getString("message");
        boolean result = log(LogLevel.ERROR, message,call);
        if (result) {
            call.resolve();
        } else {
            call.reject("Empty message given to logError");
        }
    }

    @PluginMethod
    public void logWarning(PluginCall call) {
        String message = call.getString("message");
        boolean result = log(LogLevel.WARN, message,call);
        if (result) {
            call.resolve();
        } else {
            call.reject("Empty message given to logWarning");
        }
    }

    @PluginMethod
    public void logDebug(PluginCall call) {
        String message = call.getString("message");
        boolean result = log(LogLevel.DEBUG, message,call);
        if (result) {
            call.resolve();
        } else {
            call.reject("Empty message given to logDebug");
        }
    }

    @PluginMethod
    public void logAll(PluginCall call) {
        String error = call.getString("error");
        JSObject attributes = call.getObject("attributes");

        if(attributes == null) {
            call.reject("Null attributes given to logAttributes");
            return;
        }

        Map<String,Object> logAttributes = new Gson().fromJson(String.valueOf(attributes), Map.class);

        Map<String,Object> logAttributesMap = new HashMap<>();
        logAttributesMap.put("message", error);
        logAttributesMap.putAll(logAttributes);

        logAttributes(logAttributesMap);

        call.resolve();
    }

}
