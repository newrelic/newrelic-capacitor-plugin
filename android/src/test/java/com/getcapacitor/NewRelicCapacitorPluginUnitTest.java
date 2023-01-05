/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

package com.getcapacitor;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.newrelic.capacitor.plugin.NewRelicCapacitorPluginPlugin;

import org.json.JSONException;
import org.junit.Test;
import org.mockito.Mockito;
import static org.junit.Assert.assertEquals;


public class NewRelicCapacitorPluginUnitTest {

    final NewRelicCapacitorPluginPlugin plugin = new NewRelicCapacitorPluginPlugin();

    @Test
    public void testSetUserId() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("userId")).thenReturn("fakeUserId");

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("userId")).thenReturn(null);

        plugin.setUserId(callWithGoodParams);
        plugin.setUserId(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testSetAttribute() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("name")).thenReturn("fakeAttrName");
        when(callWithGoodParams.getString("value")).thenReturn("fakeAttrVal");

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("name")).thenReturn(null);
        when(callWithNoParams.getString("value")).thenReturn(null);

        plugin.setAttribute(callWithGoodParams);
        plugin.setAttribute(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testRemoveAttribute() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("name")).thenReturn("fakeAttrName");

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("name")).thenReturn(null);

        plugin.removeAttribute(callWithGoodParams);
        plugin.removeAttribute(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testRecordBreadcrumb() throws JSONException {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("name")).thenReturn("fakeBreadName");
        when(callWithGoodParams.getObject("eventAttributes")).thenReturn(new JSObject("{'fakeVal': 2}"));

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("name")).thenReturn(null);

        plugin.recordBreadcrumb(callWithGoodParams);
        plugin.recordBreadcrumb(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testRecordCustomEvent() throws JSONException {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("eventName")).thenReturn("fakeEventName");
        when(callWithGoodParams.getString("eventType")).thenReturn("fakeEventType");
        when(callWithGoodParams.getObject("attributes")).thenReturn(new JSObject("{'fakeVal': 2}"));

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("eventName")).thenReturn(null);
        when(callWithNoParams.getString("eventType")).thenReturn(null);
        when(callWithNoParams.getString("attributes")).thenReturn(null);

        plugin.recordCustomEvent(callWithGoodParams);
        plugin.recordCustomEvent(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testStartInteraction() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("value")).thenReturn("fakeName");

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("value")).thenReturn(null);

        plugin.startInteraction(callWithGoodParams);
        plugin.startInteraction(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve(Mockito.any(JSObject.class));
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve(Mockito.any());
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testEndInteraction() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("interactionId")).thenReturn("fakeId");

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("interactionId")).thenReturn(null);

        plugin.endInteraction(callWithGoodParams);
        plugin.endInteraction(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testCrashNow() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("message")).thenReturn("fakeCrashMsg");

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("message")).thenReturn(null);

        try {
            plugin.crashNow(callWithGoodParams);
        } catch (Exception e) {
            assertEquals("fakeCrashMsg", e.getMessage());
        }

        try {
            plugin.crashNow(callWithNoParams);
        } catch (Exception e) {
            assertEquals("This is a demonstration crash courtesy of New Relic", e.getMessage());
        }
    }

    @Test
    public void testCurrentSessionId() {
        PluginCall callWithGoodParams = mock(PluginCall.class);

        plugin.currentSessionId(callWithGoodParams);

        verify(callWithGoodParams, times(1)).resolve(Mockito.any());
    }

    @Test
    public void testIncrementAttribute() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("name")).thenReturn("fakeAttrName");
        when(callWithGoodParams.getDouble("value")).thenReturn(12.0);

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("name")).thenReturn(null);
        when(callWithNoParams.getString("value")).thenReturn(null);

        PluginCall callWithOneParam = mock(PluginCall.class);
        when(callWithOneParam.getString("name")).thenReturn("fakeAttrName");
        when(callWithNoParams.getString("value")).thenReturn(null);

        plugin.incrementAttribute(callWithGoodParams);
        plugin.incrementAttribute(callWithNoParams);
        plugin.incrementAttribute(callWithOneParam);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());

        verify(callWithOneParam, times(1)).resolve();
        verify(callWithOneParam, times(0)).reject(Mockito.anyString());
    }

    @Test
    public void testNoticeHttpTransaction() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("url")).thenReturn("https://fakewebsite.com");
        when(callWithGoodParams.getString("method")).thenReturn("GET");
        when(callWithGoodParams.getInt("status")).thenReturn(200);
        when(callWithGoodParams.getLong("startTime")).thenReturn(12345678L);
        when(callWithGoodParams.getLong("endTime")).thenReturn(12345678L);
        when(callWithGoodParams.getLong("bytesSent")).thenReturn(0L);
        when(callWithGoodParams.getLong("bytesReceived")).thenReturn(10000L);
        when(callWithGoodParams.getString("body")).thenReturn("fakeBody");

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("url")).thenReturn(null);
        when(callWithNoParams.getString("method")).thenReturn(null);
        when(callWithNoParams.getInt("status")).thenReturn(null);
        when(callWithNoParams.getLong("startTime")).thenReturn(null);
        when(callWithNoParams.getLong("endTime")).thenReturn(null);
        when(callWithNoParams.getLong("bytesSent")).thenReturn(null);
        when(callWithNoParams.getLong("bytesReceived")).thenReturn(null);
        when(callWithNoParams.getString("body")).thenReturn(null);

        plugin.noticeHttpTransaction(callWithGoodParams);
        plugin.noticeHttpTransaction(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());

    }

    @Test
    public void testRecordMetric() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("name")).thenReturn("fakeMetricName");
        when(callWithGoodParams.getString("category")).thenReturn("fakeMetricCategory");
        when(callWithGoodParams.getDouble("value")).thenReturn(null);
        when(callWithGoodParams.getString("countUnit")).thenReturn(null);
        when(callWithGoodParams.getString("valueUnit")).thenReturn(null);

        PluginCall callWithGoodParams2 = mock(PluginCall.class);
        when(callWithGoodParams2.getString("name")).thenReturn("fakeMetricName");
        when(callWithGoodParams2.getString("category")).thenReturn("fakeMetricCategory");
        when(callWithGoodParams2.getDouble("value")).thenReturn(12.0);
        when(callWithGoodParams2.getString("countUnit")).thenReturn(null);
        when(callWithGoodParams2.getString("valueUnit")).thenReturn(null);

        PluginCall callWithGoodParams3 = mock(PluginCall.class);
        when(callWithGoodParams3.getString("name")).thenReturn("fakeMetricName");
        when(callWithGoodParams3.getString("category")).thenReturn("fakeMetricCategory");
        when(callWithGoodParams3.getDouble("value")).thenReturn(12.0);
        when(callWithGoodParams3.getString("countUnit")).thenReturn("SECONDS");
        when(callWithGoodParams3.getString("valueUnit")).thenReturn("OPERATIONS");

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("name")).thenReturn(null);
        when(callWithNoParams.getString("category")).thenReturn(null);
        when(callWithNoParams.getDouble("value")).thenReturn(null);
        when(callWithNoParams.getString("countUnit")).thenReturn(null);
        when(callWithNoParams.getString("valueUnit")).thenReturn(null);

        PluginCall callWithBadMetricUnit = mock(PluginCall.class);
        when(callWithBadMetricUnit.getString("name")).thenReturn("fakeMetricName");
        when(callWithBadMetricUnit.getString("category")).thenReturn("fakeMetricCategory");
        when(callWithBadMetricUnit.getDouble("value")).thenReturn(12.0);
        when(callWithBadMetricUnit.getString("countUnit")).thenReturn("FAKE");
        when(callWithBadMetricUnit.getString("valueUnit")).thenReturn("METRIC");

        PluginCall callWithBadMetricUnit2 = mock(PluginCall.class);
        when(callWithBadMetricUnit2.getString("name")).thenReturn("fakeMetricName");
        when(callWithBadMetricUnit2.getString("category")).thenReturn("fakeMetricCategory");
        when(callWithBadMetricUnit2.getDouble("value")).thenReturn(12.0);
        when(callWithBadMetricUnit2.getString("countUnit")).thenReturn("SECONDS");
        when(callWithBadMetricUnit2.getString("valueUnit")).thenReturn(null);


        plugin.recordMetric(callWithGoodParams);
        plugin.recordMetric(callWithGoodParams2);
        plugin.recordMetric(callWithGoodParams3);
        plugin.recordMetric(callWithNoParams);
        plugin.recordMetric(callWithBadMetricUnit);
        plugin.recordMetric(callWithBadMetricUnit2);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithGoodParams2, times(1)).resolve();
        verify(callWithGoodParams2, times(0)).reject(Mockito.anyString());

        verify(callWithGoodParams3, times(1)).resolve();
        verify(callWithGoodParams3, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());

        verify(callWithBadMetricUnit, times(0)).resolve();
        verify(callWithBadMetricUnit, times(1)).reject(Mockito.anyString());

        verify(callWithBadMetricUnit2, times(0)).resolve();
        verify(callWithBadMetricUnit2, times(1)).reject(Mockito.anyString());
    }

//    @Test
//    public void testRemoveAllAttributes() {
//        PluginCall callWithGoodParams = mock(PluginCall.class);
//
//        plugin.removeAllAttributes(callWithGoodParams);
//
//        verify(callWithGoodParams, times(1)).resolve();
//    }

    @Test
    public void testSetMaxEventBufferTime() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getInt("maxBufferTimeInSeconds")).thenReturn(60);

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getInt("maxBufferTimeInSeconds")).thenReturn(null);

        plugin.setMaxEventBufferTime(callWithGoodParams);
        plugin.setMaxEventBufferTime(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testSetMaxEventPoolSize() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getInt("maxPoolSize")).thenReturn(2000);

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getInt("maxPoolSize")).thenReturn(null);

        plugin.setMaxEventPoolSize(callWithGoodParams);
        plugin.setMaxEventPoolSize(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testRecordError() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getString("name")).thenReturn("fakeErrName");
        when(callWithGoodParams.getString("message")).thenReturn("fakeErrMsg");
        when(callWithGoodParams.getString("stack")).thenReturn("fakeErrStack");
        when(callWithGoodParams.getBoolean("isFatal")).thenReturn(false);

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getString("name")).thenReturn(null);
        when(callWithNoParams.getString("message")).thenReturn(null);
        when(callWithNoParams.getString("stack")).thenReturn(null);
        when(callWithNoParams.getBoolean("isFatal")).thenReturn(null);

        plugin.recordError(callWithGoodParams);
        plugin.recordError(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testAnalyticsEventEnabled() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getBoolean("enabled")).thenReturn(false);

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getBoolean("enabled")).thenReturn(null);

        plugin.analyticsEventEnabled(callWithGoodParams);
        plugin.analyticsEventEnabled(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }
    @Test
    public void testNetworkRequestEnabled() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getBoolean("enabled")).thenReturn(false);

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getBoolean("enabled")).thenReturn(null);

        plugin.networkRequestEnabled(callWithGoodParams);
        plugin.networkRequestEnabled(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }


    @Test
    public void testNetworkErrorRequestEnabled() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getBoolean("enabled")).thenReturn(false);

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getBoolean("enabled")).thenReturn(null);

        plugin.networkErrorRequestEnabled(callWithGoodParams);
        plugin.networkErrorRequestEnabled(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }

    @Test
    public void testHttpResponseBodyCaptureEnabled() {
        PluginCall callWithGoodParams = mock(PluginCall.class);
        when(callWithGoodParams.getBoolean("enabled")).thenReturn(false);

        PluginCall callWithNoParams = mock(PluginCall.class);
        when(callWithNoParams.getBoolean("enabled")).thenReturn(null);

        plugin.httpResponseBodyCaptureEnabled(callWithGoodParams);
        plugin.httpResponseBodyCaptureEnabled(callWithNoParams);

        verify(callWithGoodParams, times(1)).resolve();
        verify(callWithGoodParams, times(0)).reject(Mockito.anyString());

        verify(callWithNoParams, times(0)).resolve();
        verify(callWithNoParams, times(1)).reject(Mockito.anyString());
    }


}
