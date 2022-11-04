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
        let appKey = call.getString("appKey") ?? ""
        
        NewRelic.setPlatform(NRMAApplicationPlatform.platform_Cordova);
        NewRelic.start(withApplicationToken: appKey)
        
        call.resolve()
    }
    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
    
    @objc func setUserId(_ call: CAPPluginCall) {
        let userId = call.getString("userId") ?? ""
        NewRelic.setUserId(userId)
        call.resolve()
    }
    
    @objc func setAttribute(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? ""
        let value = call.getString("value") ?? ""

        NewRelic.setAttribute(name, value:value)
        call.resolve()
    }
    
    @objc func removeAttribute(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? ""
        NewRelic.removeAttribute(name)
        call.resolve()
    }
    
    @objc func recordBreadcrumb(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? ""
        let eventAttributes = call.getObject("eventAttributes")
        
        NewRelic.recordBreadcrumb(name,attributes: eventAttributes);
        call.resolve()
    }
    
    @objc func recordCustomEvent(_ call: CAPPluginCall) {
        let name = call.getString("eventName") ?? ""
        let eventType = call.getString("eventType") ?? ""
        let attributes = call.getObject("attributes")
        
        NewRelic.recordCustomEvent(eventType, name: name,attributes: attributes)
        call.resolve()
    }
    
    @objc func startInteraction(_ call: CAPPluginCall) {
        let actionName = call.getString("value") ?? ""
        
        let interactionId = NewRelic.startInteraction(withName: actionName)
        call.resolve([
            "value": interactionId
        ])
    }
    
    @objc func endInteraction(_ call: CAPPluginCall) {
        let interactionId = call.getString("interactionId") ?? ""
     
        
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
            call.reject("Missing name in incrementAttribute")
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
    
    @objc func noticeNetworkFailure(_ call: CAPPluginCall) {
        let url = call.getString("url")
        let method = call.getString("method")
        let status = call.getInt("status")
        let startTime = call.getDouble("startTime")
        let endTime = call.getDouble("endTime")
        let failure = call.getString("failure")
        
        // Nil checks for our unwrapping in the call below
        if(url == nil || method == nil || status == nil || startTime == nil || endTime == nil || failure == nil) {
            call.reject("Bad parameters given to noticeNetworkFailure")
            return
        }
        
        let nsurl = URL(string: url!)
        
        let strToFailureCode = [
            "Unknown": Int(NRURLErrorUnknown.rawValue),
            "BadURL": Int(NRURLErrorBadURL.rawValue),
            "TimedOut": Int(NRURLErrorTimedOut.rawValue),
            "CannotConnectToHost": Int(NRURLErrorCannotConnectToHost.rawValue),
            "DNSLookupFailed": Int(NRURLErrorDNSLookupFailed.rawValue),
            "BadServerResponse": Int(NRURLErrorBadServerResponse.rawValue),
            "SecureConnectionFailed": Int(NRURLErrorSecureConnectionFailed.rawValue)
        ]
        
        let iOSFailureCode = strToFailureCode[failure!]
        if(iOSFailureCode == nil) {
            call.reject("Bad failure name given to noticeNetworkFailure. Use one of: Unknown, BadURL, TimedOut, CannotConnectToHost, DNSLookupFailed, BadServerResponse, or SecureConnectionFailed")
            return
        }
        
        NewRelic.noticeNetworkFailure(
            for: nsurl,
            httpMethod: method,
            startTime: startTime!,
            endTime: endTime!,
            andFailureCode: iOSFailureCode!
        )
        
        call.resolve()
    }
    
    @objc func recordMetric(_ call: CAPPluginCall) {
        let name = call.getString("name")
        let category = call.getString("category")
        let value = call.getDouble("value")
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
        // Default max event pool size is 1000 events
        let errorName = call.getString("name")
        let errorMessage = call.getString("message")
        let errorStack = call.getString("stack")
        let isFatal = call.getBool("isFatal")

        let crashEvents:[String:Any] = ["Name":errorName ?? "", "Message":errorMessage ?? "" as Any, "isFatal":isFatal ?? false,"errorStack":errorStack]
        
        NewRelic.recordBreadcrumb("JS Error",attributes:crashEvents)
        NewRelic.recordCustomEvent(
            "JS Errors", name: "JS Error",attributes: crashEvents)

        call.resolve()
    }
    
}
