package com.newrelic.capacitor.plugin;

import android.Manifest;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.newrelic.agent.android.ApplicationFramework;
import com.newrelic.agent.android.NewRelic;
import com.newrelic.com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

@CapacitorPlugin(name = "NewRelicCapacitorPlugin",
        permissions = {
                @Permission(
                        strings = {Manifest.permission.ACCESS_NETWORK_STATE},
                        alias = "network"
                ),
                @Permission(strings = {Manifest.permission.INTERNET}, alias = "internet")})
public class NewRelicCapacitorPluginPlugin extends Plugin {

    private NewRelicCapacitorPlugin implementation = new NewRelicCapacitorPlugin();


    @Override
    public void load() {
        super.load();
        NewRelic.withApplicationToken("AA0bdcf0840aa947658bfb3c276ca6760e00dba650-NRMA")
                .withApplicationFramework(ApplicationFramework.Cordova, "0.0.1")
                .withLoggingEnabled(true)
                .start(this.getActivity().getApplication());
    }

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod
    public void setUserId(PluginCall call) {
        String value = call.getString("userId");

        NewRelic.setUserId(value);
        call.resolve();
    }

    @PluginMethod
    public void setAttribute(PluginCall call) {
        String name = call.getString("name");
        String value = call.getString("value");

        NewRelic.setAttribute(name,value);
        call.resolve();
    }

    @PluginMethod
    public void removeAttribute(PluginCall call) {
        String name = call.getString("name");

        NewRelic.removeAttribute(name);
        call.resolve();
    }

    @PluginMethod
    public void recordBreadcrumb(PluginCall call) {
        String name = call.getString("name");
        JSONObject eventAttributes = call.getObject("eventAttributes");

        Map yourHashMap = new Gson().fromJson(String.valueOf(eventAttributes), Map.class);


        NewRelic.recordBreadcrumb(name,yourHashMap);
        call.resolve();
    }

    @PluginMethod
    public void recordCustomEvent(PluginCall call) {
        String name = call.getString("eventName");
        String eventType = call.getString("eventType");
        JSONObject attributes = call.getObject("attributes");

        Map yourHashMap = new Gson().fromJson(String.valueOf(attributes), Map.class);

        NewRelic.recordCustomEvent(eventType,name,yourHashMap);
        call.resolve();
    }

    @PluginMethod
    public void startInteraction(PluginCall call) {
        String actionName = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", NewRelic.startInteraction(actionName));
        call.resolve(ret);
    }

    @PluginMethod
    public void endInteraction(PluginCall call) {
        String interactionId = call.getString("interactionId");

        NewRelic.endInteraction(interactionId);
        call.resolve();
    }
}
