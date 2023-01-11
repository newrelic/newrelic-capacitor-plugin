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
    
    public override func load() {
                
  }

    @objc func start(_ call: CAPPluginCall) {
        let appKey = call.getString("appKey")
        
        if(appKey == nil) {
            call.reject("Nil API key given to New Relic Agent start")
            return
        }
        
        NewRelic.setPlatform(NRMAApplicationPlatform.platform_Cordova);
        let selector = NSSelectorFromString("setPlatformVersion:")
        NewRelic.perform(selector, with:"1.0.0")
        NewRelic.start(withApplicationToken: appKey!)
        
        call.resolve()
    }
    
    @objc func setUserId(_ call: CAPPluginCall) {
        let userId = call.getString("userId")
        
        if(userId == nil) {
            call.reject("Nil userId given to setUserId")
            return
        }
        
        NewRelic.setUserId(userId!)
        call.resolve()
    }
    
    @objc func setAttribute(_ call: CAPPluginCall) {
        let name = call.getString("name")
        let value = call.getString("value")

        if(name == nil || value == nil) {
            call.reject("Nil name or value given to setAttribute")
            return
        }
        
        NewRelic.setAttribute(name!, value:value!)
        call.resolve()
    }
    
    @objc func removeAttribute(_ call: CAPPluginCall) {
        let name = call.getString("name")
        
        if(name == nil) {
            call.reject("Nil name given to removeAttribute")
            return
        }
        
        NewRelic.removeAttribute(name!)
        call.resolve()
    }
    
    @objc func recordBreadcrumb(_ call: CAPPluginCall) {
        let name = call.getString("name")
        let eventAttributes = call.getObject("eventAttributes")
        
        if(name == nil) {
            call.reject("Nil name given to recordBreadcrumb")
            return
        }
        
        NewRelic.recordBreadcrumb(name!, attributes: eventAttributes);
        call.resolve()
    }
    
    @objc func recordCustomEvent(_ call: CAPPluginCall) {
        let name = call.getString("eventName") ?? ""
        let eventType = call.getString("eventType")
        let attributes = call.getObject("attributes")
        
        if(eventType == nil) {
            call.reject("Nil eventType given to recordCustomEvent")
            return
        }
        
        NewRelic.recordCustomEvent(eventType!, name: name, attributes: attributes)
        call.resolve()
    }
    
    @objc func startInteraction(_ call: CAPPluginCall) {
        let actionName = call.getString("value")
        
        if(actionName == nil) {
            call.reject("Nil value given to startInteraction")
            return
        }
        
        let interactionId = NewRelic.startInteraction(withName: actionName)
        call.resolve([
            "value": interactionId
        ])
    }
    
    @objc func endInteraction(_ call: CAPPluginCall) {
        let interactionId = call.getString("interactionId")
     
        if(interactionId == nil) {
            call.reject("Nil interactionId given to endInteraction")
            return
        }
        
        NewRelic.stopCurrentInteraction(interactionId)
        call.resolve()
    }
    
    @objc func crashNow(_ call: CAPPluginCall) {
        let message = call.getString("message")
        
        if(message == nil) {
            NewRelic.crashNow()
            call.resolve()
            return
        } else {
            NewRelic.crashNow(message)
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
        let name = call.getString("name")
        let value = call.getDouble("value") ?? 1
        
        // Nil checks for our unwrapping in the call below
        if(name == nil) {
            call.reject("Nil name in incrementAttribute")
            return
        }
        
        let NSNumber_value = NSNumber(value: value)
        
        NewRelic.incrementAttribute(name!, value:NSNumber_value)
        call.resolve()
    }
    
    
    @objc func noticeHttpTransaction(_ call: CAPPluginCall) {
        let url = call.getString("url")
        let method = call.getString("method")
        let status = call.getInt("status")
        let startTime = call.getDouble("startTime")
        let endTime = call.getDouble("endTime")
        let bytesSent = call.getInt("bytesSent")
        let bytesReceived = call.getInt("bytesReceived")
        let body = call.getString("body")
        
        // Nil checks for our unwrapping in the call below
        if(url == nil || method == nil || status == nil || startTime == nil || endTime == nil || bytesSent == nil || bytesReceived == nil || body == nil) {
            call.reject("Bad parameters given to noticeHttpTransaction")
            return
        }
        
        let nsurl = URL(string: url!)
        let uint_bytesSent = UInt(bytesSent!)
        let uint_bytesReceived = UInt(bytesReceived!)
        let data = Data(body!.utf8)
        
        NewRelic.noticeNetworkRequest(
            for: nsurl,
            httpMethod: method,
            startTime: startTime!,
            endTime: endTime!,
            responseHeaders: nil,
            statusCode: status!,
            bytesSent: uint_bytesSent,
            bytesReceived: uint_bytesReceived,
            responseData: data,
            traceHeaders: nil,
            andParams: nil
        )
        call.resolve()
    }
    
    
    @objc func recordMetric(_ call: CAPPluginCall) {
        let name = call.getString("name")
        let category = call.getString("category")
        // Use getInt here since getDouble will return null if not actually a double
        let value = call.getInt("value")
        let countUnit = call.getString("countUnit")
        let valueUnit = call.getString("valueUnit")
        
        // Nil checks for our unwrapping in the call below
        if(name == nil || category == nil) {
            call.reject("Bad name or category given to recordMetric")
            return
        }
        
        if(value == nil) {
            NewRelic.recordMetric(withName: name!, category: category!)
            call.resolve()
            return
        } else {
            let NSNumber_value = NSNumber(value: value!)
            
            if(countUnit == nil && valueUnit == nil) {
                NewRelic.recordMetric(withName: name!, category: category!, value: NSNumber_value)
                call.resolve()
                return
            } else {
                if(countUnit == nil || valueUnit == nil) {
                    call.reject("countUnit and valueUnit must both be set together in recordMetric")
                    return
                } else {
                    let strToMetricUnit = [
                        "PERCENT": "%",
                        "BYTES": "bytes",
                        "SECONDS": "seconds",
                        "BYTES_PER_SECOND": "bytes/second",
                        "OPERATIONS": "op"
                    ]
                    
                    let valueMetricUnit = strToMetricUnit[valueUnit!]
                    let countMetricUnit = strToMetricUnit[countUnit!]
                    if(valueMetricUnit == nil || countMetricUnit == nil) {
                        call.reject("Bad countUnit or valueUnit in recordMetric. Must be one of: PERCENT, BYTES, SECONDS, BYTES_PER_SECOND, OPERATIONS")
                    } else {
                        NewRelic.recordMetric(withName: name!, category: category!, value: NSNumber_value, valueUnits: valueMetricUnit, countUnits: countMetricUnit)
                        call.resolve()
                    }
                }
            }
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
        let name = call.getString("name")
        let message = call.getString("message")
        let stack = call.getString("stack")
        let isFatal = call.getBool("isFatal")
        
        if(name == nil || message == nil || isFatal == nil) {
            call.reject("Bad parameters given to recordError")
            return
        }
        
        var errStack = stack
        
        // Sometimes error stack does not get reported if past a certain length
        if(stack != nil) {
            if(stack!.count > 3994) {
                let endIndex = stack!.index(stack!.startIndex, offsetBy: 3994)
                let substring = stack![..<endIndex]
                errStack = String(substring)
            }
        } else {
            errStack = ""
        }
        
        let attributes: [String: Any] = ["Name" : name!, "Message" : message!, "isFatal" : isFatal!, "errorStack" : errStack!]
        
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
        let toEnable = call.getBool("enabled");
        
        if(toEnable == nil) {
            call.reject("Bad value in networkRequestEnabled")
            return
        }
        
        if(toEnable!) {
            NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_NetworkRequestEvents)
        } else {
            NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_NetworkRequestEvents)
        }
        call.resolve()
    }
    
    @objc func networkErrorRequestEnabled(_ call: CAPPluginCall) {
        let toEnable = call.getBool("enabled");
        
        if(toEnable == nil) {
            call.reject("Bad value in networkErrorRequestEnabled")
            return
        }
        
        if(toEnable!) {
            NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_RequestErrorEvents)
        } else {
            NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_RequestErrorEvents)
        }
        call.resolve()
    }
    
    @objc func httpResponseBodyCaptureEnabled(_ call: CAPPluginCall) {
        let toEnable = call.getBool("enabled");
        
        if(toEnable == nil) {
            call.reject("Bad value in httpResponseBodyCaptureEnabled")
            return
        }
        
        if(toEnable!) {
            NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_HttpResponseBodyCapture)
        } else {
            NewRelic.disableFeatures(NRMAFeatureFlags.NRFeatureFlag_HttpResponseBodyCapture)
        }
        call.resolve()
    }
    
}
