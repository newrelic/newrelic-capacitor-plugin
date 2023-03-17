/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(NewRelicCapacitorPluginPlugin, "NewRelicCapacitorPlugin",
           CAP_PLUGIN_METHOD(start, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(setUserId, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(setAttribute, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(removeAttribute, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(recordBreadcrumb, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(recordCustomEvent, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(startInteraction, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(endInteraction, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(crashNow, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(currentSessionId, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(incrementAttribute, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(noticeHttpTransaction, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(recordMetric, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(removeAllAttributes, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(setMaxEventBufferTime, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(setMaxEventPoolSize, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(recordError, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(analyticsEventEnabled, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(networkRequestEnabled, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(networkErrorRequestEnabled, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(httpResponseBodyCaptureEnabled, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(getAgentConfiguration, CAPPluginReturnPromise);
)
