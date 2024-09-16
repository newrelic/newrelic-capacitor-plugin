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
        var fedRampEnabled: Bool = false;
        var offlineStorageEnabled: Bool = true;
        var backgroundReportingEnabled: Bool = false;
        var newEventSystemEnabled: Bool = true;
        var distributedTracingEnabled: Bool = true;

    }
    
    private let jscRegex = try! NSRegularExpression(pattern: #"^\s*(?:([^@]*)(?:\((.*?)\))?@)?(\S.*?):(\d+)(?::(\d+))?\s*$"#,
                                                    options: .caseInsensitive)
    private let geckoRegex = try! NSRegularExpression(pattern:#"^\s*(.*?)(?:\((.*?)\))?(?:^|@)((?:file|https?|blob|chrome|webpack|resource|\[native).*?|[^@]*bundle)(?::(\d+))?(?::(\d+))?\s*$"#,
                                                      options: .caseInsensitive)
    private let nodeRegex = try! NSRegularExpression(pattern:#"^\s*at (?:((?:\[object object\])?[^\\/]+(?: \[as \S+\])?) )?\(?(.*?):(\d+)(?::(\d+))?\)?\s*$"#,
                                                     options: .caseInsensitive)
    
    struct NRTraceConstants {
        static let TRACE_PARENT = "traceparent";
        static let TRACE_STATE = "tracestate";
        static let NEWRELIC = "newrelic";
        static let TRACE_ID = "trace.id";
        static let GUID = "guid";
        static let ID = "id";
    }
    
    public override func load() {
    }

    @objc func start(_ call: CAPPluginCall) {
        
        guard let appKey = call.getString("appKey") else {
            call.reject("Nil API key given to New Relic Agent start")
            return
        }
        
        var logLevel = NRLogLevelInfo.rawValue
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

            if agentConfiguration["distributedTracingEnabled"] as? Bool == false {
                NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_DistributedTracing)
                agentConfig.distributedTracingEnabled = false
            }
            
            if agentConfiguration["webViewInstrumentation"] as? Bool == false {
                NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_WebViewInstrumentation)
                agentConfig.webViewInstrumentation = false;
            }

             if agentConfiguration["offlineStorageEnabled"] as? Bool == false {
                NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_OfflineStorage)
                agentConfig.offlineStorageEnabled = false;
            } else {
                NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_OfflineStorage)
                agentConfig.offlineStorageEnabled = true;
            }


            if agentConfiguration["newEventSystemEnabled"] as? Bool == false {
               NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_NewEventSystem)
               agentConfig.newEventSystemEnabled = false;
           } else {
               NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_NewEventSystem)
               agentConfig.newEventSystemEnabled = true;
           }

            if agentConfiguration["backgroundReportingEnabled"] as? Bool == true {
                  NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_BackgroundReporting)
               agentConfig.backgroundReportingEnabled = true;
           } else {
               NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_BackgroundReporting)
               agentConfig.backgroundReportingEnabled = false;
           }

            if agentConfiguration["fedRampEnabled"] as? Bool == true {
                NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_FedRampEnabled)
                agentConfig.fedRampEnabled = true;
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
                if let configCollectorAddress = agentConfiguration["collectorAddress"] as? String, !configCollectorAddress.isEmpty {
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
        
        NewRelic.setPlatform(NRMAApplicationPlatform.platform_Capacitor)
        let selector = NSSelectorFromString("setPlatformVersion:")
        NewRelic.perform(selector, with:"1.5.2")

        DispatchQueue.main.async {
            if collectorAddress == nil && crashCollectorAddress == nil {
                NewRelic.start(withApplicationToken: appKey)
            } else {
                NewRelic.start(withApplicationToken: appKey,
                               andCollectorAddress: collectorAddress ?? "mobile-collector.newrelic.com",
                               andCrashCollectorAddress: crashCollectorAddress ?? "mobile-crash.newrelic.com")
            }

            call.resolve()
        }
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
            "value": interactionId as Any
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
            "sessionId": sessionId as Any
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
        let traceAttributes = call.getObject("traceAttributes")
        
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
            traceHeaders: traceAttributes,
            andParams: nil
        )
        call.resolve()
    }
    
    @objc func noticeNetworkFailure(_ call: CAPPluginCall) {
        guard let url = call.getString("url"),
              let method = call.getString("method"),
              let startTime = call.getDouble("startTime"),
              let endTime = call.getDouble("endTime"),
              let failure = call.getString("failure")
        else {
            
            call.reject("Bad parameters given to noticeNetworkFailure")
            return
        }
        
        let nsurl = URL(string: url)
        
        let dict: [String: NSNumber] = [
            "Unknown": NSNumber(value: NRURLErrorUnknown.rawValue),
            "BadURL": NSNumber(value: NRURLErrorBadURL.rawValue),
            "TimedOut": NSNumber(value: NRURLErrorTimedOut.rawValue),
            "CannotConnectToHost": NSNumber(value: NRURLErrorCannotConnectToHost.rawValue),
            "DNSLookupFailed": NSNumber(value: NRURLErrorDNSLookupFailed.rawValue),
            "BadServerResponse": NSNumber(value: NRURLErrorBadServerResponse.rawValue),
            "SecureConnectionFailed": NSNumber(value: NRURLErrorSecureConnectionFailed.rawValue)
        ]
        
        let iOSFailureCode = dict[failure]
        NewRelic.noticeNetworkFailure(for: nsurl,httpMethod: method,
                                      startTime: startTime,endTime: endTime, andFailureCode:iOSFailureCode as! Int)
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

    @objc func setMaxOfflineStorageSize(_ call: CAPPluginCall) {

        let megaBytes = call.getInt("megaBytes") ?? 100
        
        let uint_megaBytes = UInt32(megaBytes)
        
        NewRelic.setMaxOfflineStorageSize(uint_megaBytes)
        call.resolve()
    }    
    func parseStackTrace(stackString : String) -> NSMutableArray {
        let lines = stackString.split(whereSeparator: \.isNewline)

        let linesStr = lines.map { subString -> String in
            return String(subString)
        }
        let stackFramesArr : NSMutableArray = []
        var stringRange : NSRange
        
        for line in linesStr {
            var result : [NSTextCheckingResult]
            stringRange = NSRange(location: 0, length: line.utf16.count)
            if (jscRegex.matches(in: line, range: stringRange).first != nil) {
                result = jscRegex.matches(in: line, range: stringRange)
            } else if (geckoRegex.matches(in: line, range: stringRange).first != nil) {
                result = geckoRegex.matches(in: line, range: stringRange)
            } else if (nodeRegex.matches(in: line, range: stringRange).first != nil) {
                result = nodeRegex.matches(in: line, range: stringRange)
            } else {
                continue
            }
            
            let stackTraceElement : NSMutableDictionary = [:]
            
            // iOS agent will automatically add default values if these keys don't exist
            if let methodSubstrRange = Range(result[0].range(at:1), in: line) {
                stackTraceElement["method"] = String(line[methodSubstrRange])
            }
            if let fileSubstrRange = Range(result[0].range(at:3), in: line) {
                stackTraceElement["file"] = String(line[fileSubstrRange])
            }
            if let lineSubstrRange = Range(result[0].range(at:4), in: line) {
                stackTraceElement["line"] = Int(String(line[lineSubstrRange]))
            }
            stackFramesArr.add(stackTraceElement)
        }
        
        return stackFramesArr
    }
    
    @objc func recordError(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? "null"
        let message = call.getString("message") ?? "null"
        let isFatal = call.getBool("isFatal") ?? false
        
        let stack = call.getString("stack") ?? ""
        let stackFramesArr = parseStackTrace(stackString: stack)
        var attributes : [String: Any] = [
            "name" : name,
            "reason": message,
            "fatal": isFatal,
            "stackTraceElements": stackFramesArr
        ]
        if let customAttributes = call.getObject("attributes") {
            for (key, value) in customAttributes {
                attributes[key] = value
            }
        }
        NewRelic.recordHandledException(withStackTrace: attributes)

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
            "sendConsoleEvents": agentConfig.sendConsoleEvents,
            "fedRampEnabled": agentConfig.fedRampEnabled,
            "offlineStorageEnabled":agentConfig.offlineStorageEnabled,
            "distributedTracingEnabled": agentConfig.distributedTracingEnabled,
        ])
    }

    @objc func shutdown(_ call: CAPPluginCall) {
        NewRelic.shutdown()
        call.resolve()
    }

    @objc func generateDistributedTracingHeaders(_ call: CAPPluginCall) {
        let headersDict = NewRelic.generateDistributedTracingHeaders()
        call.resolve([
            NRTraceConstants.TRACE_PARENT: headersDict[NRTraceConstants.TRACE_PARENT] as Any,
            NRTraceConstants.TRACE_STATE: headersDict[NRTraceConstants.TRACE_STATE] as Any,
            NRTraceConstants.NEWRELIC: headersDict[NRTraceConstants.NEWRELIC] as Any
        ])
    }
    
    @objc func addHTTPHeadersTrackingFor(_ call: CAPPluginCall) {
        
        guard let headers = call.getArray("headers")?.capacitor.replacingNullValues() as? [String] else {
            return ;
        }
        
        NewRelic.addHTTPHeaderTracking(for: headers)
    }
    
    @objc func getHTTPHeadersTrackingFor(_ call: CAPPluginCall) {
        
        let headerArray = NewRelic.httpHeadersAddedForTracking();
        var headerArrayString = "[]";
        if let jsonData = try? JSONSerialization.data(withJSONObject: headerArray, options: .prettyPrinted) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                headerArrayString = jsonString;
            }
        }
        call.resolve([
            "headersList": headerArrayString
        ])
    }

     @objc func logDebug(_ call: CAPPluginCall) {

            let message = call.getString("message") ?? "null"

            NewRelic.log(message, level: NRLogLevelDebug)


        }

        @objc func logWarning(_ call: CAPPluginCall) {

            let message = call.getString("message") ?? "null"

            NewRelic.log(message, level: NRLogLevelWarning)


        }

        @objc func logError(_ call: CAPPluginCall) {

            let message = call.getString("message") ?? "null"

            NewRelic.log(message, level: NRLogLevelError)


        }

        @objc func logVerbose(_ call: CAPPluginCall) {

            let message = call.getString("message") ?? "null"

            NewRelic.log(message, level: NRLogLevelVerbose)


        }

        @objc func logInfo(_ call: CAPPluginCall) {

            let message = call.getString("message") ?? "null"

            NewRelic.log(message, level: NRLogLevelInfo)

        }

        @objc func log(_ call: CAPPluginCall) {

            let message = call.getString("message") ?? "null"
            let level = call.getString("level")

            let strToLogLevel = [
                "ERROR": NRLogLevelError,
                "WARNING": NRLogLevelWarning,
                "INFO": NRLogLevelInfo,
                "VERBOSE": NRLogLevelVerbose,
                "AUDIT": NRLogLevelAudit
            ]

            let configLogLevel =  strToLogLevel[level!]

            NewRelic.log(message, level: configLogLevel!)
        }



        @objc func logAll(_ call: CAPPluginCall) {

            let error = call.getString("error") ?? "null"

            let attributes = call.getObject("attributes")

            var allAttributes: [String: Any] = ["message":error];

            for (key,value) in attributes! {
                allAttributes[key] = value;
            }

            NewRelic.logAttributes(allAttributes)

        }

        @objc func logAttributes(_ call: CAPPluginCall) {

            let attributes = call.getObject("attributes")

            if(attributes!.isEmpty){
                print("Attributes are Empty")
                return
            }

            NewRelic.logAttributes(attributes!);
        }
}
