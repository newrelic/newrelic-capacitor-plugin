/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

import Foundation
import Capacitor
import NewRelic
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(NewRelicCapacitorPluginPlugin)
public class NewRelicCapacitorPluginPlugin: CAPPlugin {
    private let implementation = NewRelicCapacitorPlugin()
    private var agentConfig = AgentConfiguration()
    
    struct AgentConfiguration {
        var crashReportingEnabled: Bool = true;
        var interactionTracingEnabled: Bool = true;
        var networkRequestEnabled: Bool = true;
        var networkErrorRequestEnabled: Bool = true;
        var httpResponseBodyCaptureEnabled: Bool = true;
        var webViewInstrumentation : Bool = true;
        var loggingEnabled: Bool = true;
        var logLevel: String = "WARNING"
        var collectorAddress: String = "mobile-collector.newrelic.com"
        var crashCollectorAddress: String = "mobile-crash.newrelic.com"
        var sendConsoleEvents: Bool = true;
    }
    
    public override func load() {
    }

    @objc func start(_ call: CAPPluginCall) {
        
        guard let appKey = call.getString("appKey") else {
            call.reject("Nil API key given to New Relic Agent start")
            return
        }
        
        var logLevel = NRLogLevelWarning.rawValue
        var collectorAddress: String? = nil
        var crashCollectorAddress: String? = nil
        
        if let agentConfiguration = call.getObject("agentConfiguration") {
            
            if agentConfiguration["crashReportingEnabled"] as? Bool == false {
                NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_CrashReporting)
                agentConfig.crashReportingEnabled = false
            }
            
            if agentConfiguration["interactionTracingEnabled"] as? Bool == false {
                NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_InteractionTracing)
                agentConfig.interactionTracingEnabled = false
            }
            
            if agentConfiguration["networkRequestEnabled"] as? Bool == false {
                NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_NetworkRequestEvents)
                agentConfig.networkRequestEnabled = false
            }
            
            if agentConfiguration["networkErrorRequestEnabled"] as? Bool == false {
                NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_RequestErrorEvents)
                agentConfig.networkErrorRequestEnabled = false
            }
            
            if agentConfiguration["httpResponseBodyCaptureEnabled"] as? Bool == false {
                NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_HttpResponseBodyCapture)
                agentConfig.httpResponseBodyCaptureEnabled = false
            }
            
            if agentConfiguration["webViewInstrumentation"] as? Bool == false {
                NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_WebViewInstrumentation)
                agentConfig.webViewInstrumentation = false;
            }
            
            if agentConfiguration["logLevel"] != nil {
                
                let strToLogLevel = [
                    "ERROR": NRLogLevelError.rawValue,
                    "WARNING": NRLogLevelWarning.rawValue,
                    "INFO": NRLogLevelInfo.rawValue,
                    "VERBOSE": NRLogLevelVerbose.rawValue,
                    "AUDIT": NRLogLevelAudit.rawValue
                ]
                
                if let configLogLevel = agentConfiguration["logLevel"] as? String, strToLogLevel[configLogLevel] != nil {
                    logLevel = strToLogLevel[configLogLevel] ?? logLevel
                    if (strToLogLevel[configLogLevel] != nil) {
                        agentConfig.logLevel = configLogLevel
                    }
                        
                }
            }
            
            if agentConfiguration["loggingEnabled"] != nil {
                if agentConfiguration["loggingEnabled"] as? Bool == false {
                    logLevel = NRLogLevelNone.rawValue
                    agentConfig.loggingEnabled = false
                }
                
            }
            
            if agentConfiguration["collectorAddress"] != nil {
                if let configCollectorAddress = agentConfiguration["collectorAdddress"] as? String, !configCollectorAddress.isEmpty {
                    collectorAddress = configCollectorAddress
                    agentConfig.collectorAddress = configCollectorAddress
                }
            }
            
            if agentConfiguration["crashCollectorAddress"] != nil {
                if let configCrashCollectorAddress = agentConfiguration["crashCollectorAddress"] as? String, !configCrashCollectorAddress.isEmpty {
                    crashCollectorAddress = configCrashCollectorAddress
                    agentConfig.crashCollectorAddress = configCrashCollectorAddress
                }
            }

            if agentConfiguration["crashCollectorAddress"] != nil {
                if let configCrashCollectorAddress = agentConfiguration["crashCollectorAddress"] as? String, !configCrashCollectorAddress.isEmpty {
                    crashCollectorAddress = configCrashCollectorAddress
                    agentConfig.crashCollectorAddress = configCrashCollectorAddress
                }
            }

            if agentConfiguration["sendConsoleEvents"] != nil {
                if let configSendConsoleEvents = agentConfiguration["sendConsoleEvents"] as? Bool {
                    agentConfig.sendConsoleEvents = configSendConsoleEvents
                }
            }
        }
        
        NRLogger.setLogLevels(logLevel)
        NewRelic.setPlatform(NRMAApplicationPlatform.platform_Capacitor)
        let selector = NSSelectorFromString("setPlatformVersion:")
        NewRelic.perform(selector, with:"1.1.0")
        
        if collectorAddress == nil && crashCollectorAddress == nil {
            NewRelic.start(withApplicationToken: appKey)
        } else {
            NewRelic.start(withApplicationToken: appKey,
                           andCollectorAddress: collectorAddress ?? "mobile-collector.newrelic.com",
                           andCrashCollectorAddress: crashCollectorAddress ?? "mobile-crash.newrelic.com")
        }
        
        call.resolve()
    }
    
    @objc func setUserId(_ call: CAPPluginCall) {
        guard let userId = call.getString("userId") else {
            call.reject("Nil userId given to setUserId")
            return
        }
        
        NewRelic.setUserId(userId)
        call.resolve()
    }
    
    @objc func setAttribute(_ call: CAPPluginCall) {
        guard let name = call.getString("name"),
              let value = call.getString("value") else {
            call.reject("Nil name or value given to setAttribute")
            return
        }
        
        NewRelic.setAttribute(name, value:value)
        call.resolve()
    }
    
    @objc func removeAttribute(_ call: CAPPluginCall) {
        guard let name = call.getString("name") else {
            call.reject("Nil name given to removeAttribute")
            return
        }
        
        NewRelic.removeAttribute(name)
        call.resolve()
    }
    
    @objc func recordBreadcrumb(_ call: CAPPluginCall) {
        guard let name = call.getString("name") else {
            call.reject("Nil name given to recordBreadcrumb")
            return
        }
        let eventAttributes = call.getObject("eventAttributes")
        
        NewRelic.recordBreadcrumb(name, attributes: eventAttributes);
        call.resolve()
    }
    
    @objc func recordCustomEvent(_ call: CAPPluginCall) {
        guard let eventType = call.getString("eventType") else {
            call.reject("Nil eventType given to recordCustomEvent")
            return
        }
        let name = call.getString("eventName")

        let attributes = call.getObject("attributes")
        
        NewRelic.recordCustomEvent(eventType, name: name, attributes: attributes)
        call.resolve()
    }
    
    @objc func startInteraction(_ call: CAPPluginCall) {
        guard let actionName = call.getString("value") else {
            call.reject("Nil value given to startInteraction")
            return
        }
        
        let interactionId = NewRelic.startInteraction(withName: actionName)
        call.resolve([
            "value": interactionId
        ])
    }
    
    @objc func endInteraction(_ call: CAPPluginCall) {
        guard let interactionId = call.getString("interactionId") else {
            call.reject("Nil interactionId given to endInteraction")
            return
        }
        
        NewRelic.stopCurrentInteraction(interactionId)
        call.resolve()
    }
    
    @objc func crashNow(_ call: CAPPluginCall) {
        if let message = call.getString("message") {
            NewRelic.crashNow(message)
            call.resolve()
            return

        } else {
            NewRelic.crashNow()
            call.resolve()
            return
        }
    }
    
    @objc func currentSessionId(_ call: CAPPluginCall) {
        let sessionId = NewRelic.currentSessionId()
        call.resolve([
            "sessionId": sessionId
        ])
    }
    
    @objc func incrementAttribute(_ call: CAPPluginCall) {
        guard let name = call.getString("name") else {
            call.reject("Nil name in incrementAttribute")
            return
        }
        let value = call.getDouble("value") ?? 1
        
        let NSNumber_value = NSNumber(value: value)
        
        NewRelic.incrementAttribute(name, value:NSNumber_value)
        call.resolve()
    }
    
    
    @objc func noticeHttpTransaction(_ call: CAPPluginCall) {
        guard let url = call.getString("url"),
              let method = call.getString("method"),
              let status = call.getInt("status"),
              let startTime = call.getDouble("startTime"),
              let endTime = call.getDouble("endTime"),
              let bytesSent = call.getInt("bytesSent"),
              let bytesReceived = call.getInt("bytesReceived"),
              let body = call.getString("body") else {
            
            call.reject("Bad parameters given to noticeHttpTransaction")
            return
        }
        
        let nsurl = URL(string: url)
        let uint_bytesSent = UInt(bytesSent)
        let uint_bytesReceived = UInt(bytesReceived)
        let data = Data(body.utf8)
        
        NewRelic.noticeNetworkRequest(
            for: nsurl,
            httpMethod: method,
            startTime: startTime,
            endTime: endTime,
            responseHeaders: nil,
            statusCode: status,
            bytesSent: uint_bytesSent,
            bytesReceived: uint_bytesReceived,
            responseData: data,
            traceHeaders: nil,
            andParams: nil
        )
        call.resolve()
    }
    
    
    @objc func recordMetric(_ call: CAPPluginCall) {
        guard let name = call.getString("name"),
              let category = call.getString("category") else {
            call.reject("Bad name or category given to recordMetric")
            return
        }
        
        // Use getInt here since getDouble will return null if not actually a double
        guard let value = call.getInt("value") else {
            NewRelic.recordMetric(withName: name, category: category)
            call.resolve()
            return
        }
        
        let NSNumber_value = NSNumber(value: value)
        
        guard let countUnit = call.getString("countUnit"),
              let valueUnit = call.getString("valueUnit") else {
            NewRelic.recordMetric(withName: name, category: category, value: NSNumber_value)
            call.resolve()
            return
        }
        
        let strToMetricUnit = [
            "PERCENT": "%",
            "BYTES": "bytes",
            "SECONDS": "seconds",
            "BYTES_PER_SECOND": "bytes/second",
            "OPERATIONS": "op"
        ]
        
        if let valueMetricUnit = strToMetricUnit[valueUnit],
           let countMetricUnit = strToMetricUnit[countUnit] {
            NewRelic.recordMetric(withName: name, category: category, value: NSNumber_value, valueUnits: valueMetricUnit, countUnits: countMetricUnit)
            call.resolve()
            return
            
        } else {
            call.reject("Bad countUnit or valueUnit in recordMetric. Must be one of: PERCENT, BYTES, SECONDS, BYTES_PER_SECOND, OPERATIONS")
            return
        }
        
    }
    
    @objc func removeAllAttributes(_ call: CAPPluginCall) {
        NewRelic.removeAllAttributes()
        call.resolve()
    }
    
    @objc func setMaxEventBufferTime(_ call: CAPPluginCall) {
        // Default event buffer time is 600 seconds
        let seconds = call.getInt("maxBufferTimeInSeconds") ?? 600
        
        let uint_seconds = UInt32(seconds)
        
        NewRelic.setMaxEventBufferTime(uint_seconds)
        call.resolve()
    }
    
    @objc func setMaxEventPoolSize(_ call: CAPPluginCall) {
        // Default max event pool size is 1000 events
        let maxPoolSize = call.getInt("maxPoolSize") ?? 1000
        
        let uint_maxPoolSize = UInt32(maxPoolSize)
        
        NewRelic.setMaxEventPoolSize(uint_maxPoolSize)
        call.resolve()
    }
    
    @objc func recordError(_ call: CAPPluginCall) {
        guard let name = call.getString("name"),
              let message = call.getString("message"),
              let isFatal = call.getBool("isFatal") else {
            call.reject("Bad parameters given to recordError")
            return
        }
        
        var errStack = "No stack available"
        
        // Sometimes error stack does not get reported if past a certain length
        if let stack = call.getString("stack") {
            if stack.count > 3994 {
                let endIndex = stack.index(stack.startIndex, offsetBy: 3994)
                let substring = stack[..<endIndex]
                errStack = String(substring)
            } else {
                errStack = stack
            }
        }
        
        let attributes: [String: Any] = ["Name" : name, "Message" : message, "isFatal" : isFatal, "errorStack" : errStack]
        
        NewRelic.recordBreadcrumb("JS Errors", attributes: attributes)
        NewRelic.recordCustomEvent("JS Errors", attributes: attributes)
        call.resolve()
    }
    
    @objc func analyticsEventEnabled(_ call: CAPPluginCall) {
        // Currently only an android method call, do nothing here
        call.resolve()
        return
    }
    
    @objc func networkRequestEnabled(_ call: CAPPluginCall) {
        guard let toEnable = call.getBool("enabled") else {
            call.reject("Bad value in networkRequestEnabled")
            return
        }
        
        if toEnable {
            NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_NetworkRequestEvents)
        } else {
            NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_NetworkRequestEvents)
        }
        call.resolve()
    }
    
    @objc func networkErrorRequestEnabled(_ call: CAPPluginCall) {
        guard let toEnable = call.getBool("enabled") else {
            call.reject("Bad value in networkErrorRequestEnabled")
            return
        }
        
        if toEnable {
            NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_RequestErrorEvents)
        } else {
            NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_RequestErrorEvents)
        }
        call.resolve()
    }
    
    @objc func httpResponseBodyCaptureEnabled(_ call: CAPPluginCall) {
        guard let toEnable = call.getBool("enabled") else {
            call.reject("Bad value in httpResponseBodyCaptureEnabled")
            return
        }
        
        if toEnable {
            NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_HttpResponseBodyCapture)
        } else {
            NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_HttpResponseBodyCapture)
        }
        call.resolve()
    }
    
    @objc func getAgentConfiguration(_ call: CAPPluginCall) {
        call.resolve([
            "crashReportingEnabled": agentConfig.crashReportingEnabled,
            "interactionTracingEnabled": agentConfig.interactionTracingEnabled,
            "networkRequestEnabled": agentConfig.networkRequestEnabled,
            "networkErrorRequestEnabled": agentConfig.networkErrorRequestEnabled,
            "httpResponseBodyCaptureEnabled" : agentConfig.httpResponseBodyCaptureEnabled,
            "webViewInstrumentation": agentConfig.webViewInstrumentation,
            "loggingEnabled": agentConfig.loggingEnabled,
            "logLevel": agentConfig.logLevel,
            "collectorAddress": agentConfig.collectorAddress,
            "crashCollectorAddress": agentConfig.crashCollectorAddress,
            "sendConsoleEvents": agentConfig.sendConsoleEvents
        ])
    }
    
}
