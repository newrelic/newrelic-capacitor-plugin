/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

import XCTest
import Capacitor
import NewRelic

@testable import Plugin

class NewRelicCapacitorPluginTests: XCTestCase {
    
    let NewRelicCapacitorPlugin = NewRelicCapacitorPluginPlugin()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testStartAgent() {
        guard let callWithKey = CAPPluginCall(callbackId: "start",
                                        options: ["appKey": "fake-key"],
                                        success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                        error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testStartAgent")
            return
        }
        
        guard let callWithNoKey = CAPPluginCall(callbackId: "start",
                                          options: [:],
                                          success: { (result, call) in
            XCTFail("Agent start should not work with nil key")
        },
                                          error:{ (err) in
            XCTAssertEqual(err!.message,"Nil API key given to New Relic Agent start")
        }) else {
            XCTFail("Bad call in testStartAgent")
            return
        }
        
        NewRelicCapacitorPlugin.start(callWithKey)
        NewRelicCapacitorPlugin.start(callWithNoKey)
    }
    
    func testSetUserId() {
        guard let callWithKey = CAPPluginCall(callbackId: "setUserId",
                                        options: ["userId": "fakeId"],
                                        success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                        error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testSetUserId")
            return
        }
        
        guard let callWithNoKey = CAPPluginCall(callbackId: "setUserId",
                                          options: [:],
                                          success: { (result, call) in
            XCTFail("setUserId should not be successful with no userId")
        },
                                          error:{ (err) in
            XCTAssertEqual(err!.message, "Nil userId given to setUserId")
        }) else {
            XCTFail("Bad call in testSetUserId")
            return
        }
        
        NewRelicCapacitorPlugin.setUserId(callWithKey)
        NewRelicCapacitorPlugin.setUserId(callWithNoKey)
    }
    
    func testSetAttribute() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "setAttribute",
                                               options: ["name": "fakeAttributeName",
                                                         "value": "21"],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testSetAttribute")
            return
        }
        
        guard let callWithBadName = CAPPluginCall(callbackId: "setAttribute",
                                            options: ["value": "01"],
                                            success: { (result, call) in
            XCTFail("setAttribute should not work with nil name")
        },
                                            error: { (err) in
            XCTAssertTrue(err!.message == "Nil name or value given to setAttribute")
        }) else {
            XCTFail("Bad call in testSetAttribute")
            return
        }
        
        guard let callWithBadValue = CAPPluginCall(callbackId: "setAttribute",
                                             options: ["name": "fakeName"],
                                             success: { (result, call) in
            XCTFail("setAttribute should not work with nil value")
        },
                                             error: { (err) in
            XCTAssertEqual(err!.message, "Nil name or value given to setAttribute")
        }) else {
            XCTFail("Bad call in testSetAttribute")
            return
        }
        
        NewRelicCapacitorPlugin.setAttribute(callWithGoodParams)
        NewRelicCapacitorPlugin.setAttribute(callWithBadName)
        NewRelicCapacitorPlugin.setAttribute(callWithBadValue)
    }
    
    func testRemoveAttribute() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "removeAttribute",
                                               options: ["name": "fakeAttributeName"],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testRemoveAttribute")
            return
        }
        
        guard let callWithBadName = CAPPluginCall(callbackId: "removeAttribute",
                                            options: [:],
                                            success: { (result, call) in
            XCTFail("removeAttribute should not work with nil name")
        },
                                            error: { (err) in
            XCTAssertEqual(err!.message, "Nil name given to removeAttribute")
        }) else {
            XCTFail("Bad call in testRemoveAttribute")
            return
        }
        
        
        NewRelicCapacitorPlugin.removeAttribute(callWithGoodParams)
        NewRelicCapacitorPlugin.removeAttribute(callWithBadName)
    }
    
    func testRecordBreadcrumb() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "recordBreadcrumb",
                                               options: ["name": "fakeBreadName",
                                                         "eventAttributes": ["{'fakeAttr': 1}"]
                                                        ],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testRecordBreadcrumb")
            return
        }
        
        guard let callWithNoAttributes = CAPPluginCall(callbackId: "recordBreadcrumb",
                                                 options: ["name": "fakeBreadName"],
                                                 success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                                 error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testRecordBreadcrumb")
            return
        }
        
        guard let callWithBadName = CAPPluginCall(callbackId: "recordBreadcrumb",
                                            options: [:],
                                            success: { (result, call) in
            XCTFail("recordBreadcrumb should not work with nil name")
        },
                                            error: { (err) in
            XCTAssertEqual(err!.message, "Nil name given to recordBreadcrumb")
        }) else {
            XCTFail("Bad call in testRecordBreadcrumb")
            return
        }
        
        
        NewRelicCapacitorPlugin.recordBreadcrumb(callWithGoodParams)
        NewRelicCapacitorPlugin.recordBreadcrumb(callWithNoAttributes)
        NewRelicCapacitorPlugin.recordBreadcrumb(callWithBadName)
        
    }
    
    func testRecordCustomEvent() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "recordCustomEvent",
                                               options: ["name": "fakeEventName",
                                                         "eventType": "fakeEventType",
                                                         "eventAttributes": ["{'fakeAttr': 1}"]
                                                        ],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testRecordCustomEvent")
            return
        }
        
        guard let callWithNoType = CAPPluginCall(callbackId: "recordCustomEvent",
                                           options: ["name": "fakeEventName",
                                                     "eventAttributes": ["{'fakeAttr': 1}"]],
                                           success: { (result, call) in
            XCTFail("recordBreadcrumb should not be successful without eventType")
        },
                                           error:{ (err) in
            XCTAssertEqual(err!.message, "Nil eventType given to recordCustomEvent")
        }) else {
            XCTFail("Bad call in testRecordCustomEvent")
            return
        }
        
        guard let callWithNoNameOrAttributes = CAPPluginCall(callbackId: "recordCustomEvent",
                                                       options: ["eventType": "fakeEventType"],
                                                       success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                                       error: { (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testRecordCustomEvent")
            return
        }
        
        NewRelicCapacitorPlugin.recordCustomEvent(callWithGoodParams)
        NewRelicCapacitorPlugin.recordCustomEvent(callWithNoType)
        NewRelicCapacitorPlugin.recordCustomEvent(callWithNoNameOrAttributes)
        
    }
    
    func testStartInteraction() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "startInteraction",
                                               options: ["value": "interactionName"],
                                               success: { (result, call) in
            let resultValue = result?.data!["value"]
            XCTAssertNotNil(resultValue)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testStartInteraction")
            return
        }
        
        guard let callWithNoName = CAPPluginCall(callbackId: "startInteraction",
                                           options: [:],
                                           success: { (result, call) in
            XCTFail("startInteraction should not be successful without name")
        },
                                           error:{ (err) in
            XCTAssertEqual(err!.message, "Nil value given to startInteraction")
        }) else {
            XCTFail("Bad call in testStartInteraction")
            return
        }
        
        
        NewRelicCapacitorPlugin.startInteraction(callWithGoodParams)
        NewRelicCapacitorPlugin.startInteraction(callWithNoName)
    }
    
    func testEndInteraction() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "endInteraction",
                                               options: ["interactionId": "interactionName"],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testEndInteraction")
            return
        }
        
        guard let callWithNoName = CAPPluginCall(callbackId: "endInteraction",
                                           options: [:],
                                           success: { (result, call) in
            XCTFail("endInteraction should not be successful without name")
        },
                                           error:{ (err) in
            XCTAssertEqual(err!.message, "Nil interactionId given to endInteraction")
        }) else {
            XCTFail("Bad call in testEndInteraction")
            return
        }
        
        NewRelicCapacitorPlugin.endInteraction(callWithGoodParams)
        NewRelicCapacitorPlugin.endInteraction(callWithNoName)
    }
    
    func testCurrentSessionId() {
        
        guard let call = CAPPluginCall(callbackId: "currentSessionId",
                                 options: [:],
                                 success: { (result, call) in
            let resultValue = result?.data!["sessionId"]
            XCTAssert(resultValue != nil)
        },
                                 error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testCurrentSessionId")
            return
        }
        
        NewRelicCapacitorPlugin.currentSessionId(call)
    }
    
    func testIncrementAttribute() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "incrementAttribute",
                                               options: ["name": "incrAttr",
                                                         "value": 20],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testIncrementAttribute")
            return
        }
        
        guard let callWithNoValue = CAPPluginCall(callbackId: "incrementAttribute",
                                            options: ["name": "incrAttr"],
                                            success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                            error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testIncrementAttribute")
            return
        }
        
        guard let callWithStrValue = CAPPluginCall(callbackId: "incrementAttribute",
                                            options: ["name": "incrAttr",
                                                      "value": "17"],
                                            success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                            error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testIncrementAttribute")
            return
        }
        
        guard let callWithNoName = CAPPluginCall(callbackId: "incrementAttribute",
                                            options: ["value": 12],
                                            success: { (result, call) in
            XCTFail("incrementAttribute")
        },
                                            error:{ (err) in
            XCTAssertEqual(err!.message, "Nil name in incrementAttribute")
        }) else {
            XCTFail("Bad call in testIncrementAttribute")
            return
        }
        
        NewRelicCapacitorPlugin.incrementAttribute(callWithGoodParams)
        NewRelicCapacitorPlugin.incrementAttribute(callWithNoValue)
        NewRelicCapacitorPlugin.incrementAttribute(callWithStrValue)
        NewRelicCapacitorPlugin.incrementAttribute(callWithNoName)
        
    }
    
    func testNoticeHttpTransaction() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "noticeHttpTransaction",
                                               options: ["url": "https://fakewebsite.com",
                                                         "method": "GET",
                                                         "status": 200,
                                                         "startTime": Date().timeIntervalSince1970,
                                                         "endTime": Date().timeIntervalSince1970,
                                                         "bytesSent": 1000,
                                                         "bytesReceived": 1000,
                                                         "body": "fake body"],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testNoticeHttpTransaction")
            return
        }
        
        guard let callWithTraceParams = CAPPluginCall(callbackId: "noticeHttpTransaction",
                                               options: ["url": "https://fakewebsite.com",
                                                         "method": "GET",
                                                         "status": 200,
                                                         "startTime": Date().timeIntervalSince1970,
                                                         "endTime": Date().timeIntervalSince1970,
                                                         "bytesSent": 1000,
                                                         "bytesReceived": 1000,
                                                         "body": "fake body",
                                                         "eventAttributes": ["{'traceTest': '12345'}"]],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testNoticeHttpTransaction")
            return
        }

        guard let callWithNoParams = CAPPluginCall(callbackId: "noticeHttpTransaction",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("noticeHttpTransaction should not work with nil params")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad parameters given to noticeHttpTransaction")
        }) else {
            XCTFail("Bad call in testNoticeHttpTransaction")
            return
        }
        
        NewRelicCapacitorPlugin.noticeHttpTransaction(callWithGoodParams)
        NewRelicCapacitorPlugin.noticeHttpTransaction(callWithTraceParams)
        NewRelicCapacitorPlugin.noticeHttpTransaction(callWithNoParams)
    }
    
    func testNoticeNetworkFailure() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "noticeNetworkFailure",
                                               options: ["url": "https://fakewebsite.com",
                                                         "method": "GET",
                                                         "startTime": Date().timeIntervalSince1970,
                                                         "endTime": Date().timeIntervalSince1970,
                                                         "failure": "BadURL"],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in noticeNetworkFailure")
            return
        }
        

        guard let callWithNoParams = CAPPluginCall(callbackId: "noticeNetworkFailure",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("noticeHttpTransaction should not work with nil params")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad parameters given to noticeHttpTransaction")
        }) else {
            XCTFail("Bad call in testNoticeHttpTransaction")
            return
        }
        
        NewRelicCapacitorPlugin.noticeHttpTransaction(callWithGoodParams)
        NewRelicCapacitorPlugin.noticeHttpTransaction(callWithNoParams)
    }
    
    func testRecordMetric() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "recordMetric",
                                                     options: ["name": "metricName",
                                                               "category": "metricCategory",
                                                               "value": 27,
                                                               "countUnit": "PERCENT",
                                                               "valueUnit": "SECONDS"],
                                                     success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                                     error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testRecordMetric")
            return
        }
        
        guard let callWithGoodParams2 = CAPPluginCall(callbackId: "recordMetric",
                                                      options: ["name": "metricName",
                                                                "category": "metricCategory",
                                                                "value": 27],
                                                      success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                                      error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testRecordMetric")
            return
        }
        
        guard let callWithGoodParams3 = CAPPluginCall(callbackId: "recordMetric",
                                                      options: ["name": "metricName",
                                                                "category": "metricCategory"],
                                                      success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                                      error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testRecordMetric")
            return
        }
        
        guard let callWithBadMetricUnit = CAPPluginCall(callbackId: "recordMetric",
                                                        options: ["name": "metricName",
                                                                  "category": "metricCategory",
                                                                  "value": 27,
                                                                  "valueUnit": "FAKE",
                                                                  "countUnit": "SECONDS"
                                                                 ],
                                                        success: { (result, call) in
            XCTFail("recordMetric should not work with bad metric unit")
        },
                                                        error:{ (err) in
            XCTAssertEqual(err!.message, "Bad countUnit or valueUnit in recordMetric. Must be one of: PERCENT, BYTES, SECONDS, BYTES_PER_SECOND, OPERATIONS")
        }) else {
            XCTFail("Bad call in testRecordMetric")
            return
        }

        guard let callWithBadParams = CAPPluginCall(callbackId: "recordMetric",
                                              options: ["name": "metricName",
                                                        "category": "metricCategory",
                                                        "value": 27,
                                                        "valueUnit": "OPERATIONS",
                                                           ],
                                              success: { (result, call) in
            XCTAssertNotNil(result)
          },
                                                  error:{ (err) in
            XCTFail("recordMetric should send value without metricUnit if only one metricUnit is set")
        }) else {
            XCTFail("Bad call in testRecordMetric")
            return
        }
        
        guard let callWithNoParams = CAPPluginCall(callbackId: "recordMetric",
                                             options: [:],
                                             success: { (result, call) in
              XCTFail("recordMetric should not work with no params")
          },
                                                  error:{ (err) in
            XCTAssertEqual(err!.message, "Bad name or category given to recordMetric")
        }) else {
            XCTFail("Bad call in testRecordMetric")
            return
        }
        
        NewRelicCapacitorPlugin.recordMetric(callWithGoodParams)
        NewRelicCapacitorPlugin.recordMetric(callWithGoodParams2)
        NewRelicCapacitorPlugin.recordMetric(callWithGoodParams3)
        NewRelicCapacitorPlugin.recordMetric(callWithBadMetricUnit)
        NewRelicCapacitorPlugin.recordMetric(callWithBadParams)
        NewRelicCapacitorPlugin.recordMetric(callWithNoParams)
    }
    
    func testRemoveAllAttributes() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "removeAllAttributes",
                                               options: [:],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testRemoveAllAttributes")
            return
        }
        
        NewRelicCapacitorPlugin.removeAllAttributes(callWithGoodParams)
    }
    
    func testSetMaxEventBufferTime() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "setMaxEventBufferTime",
                                               options: ["maxBufferTimeInSeconds": 60],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testSetMaxEventBufferTime")
            return
        }
        
        // Should work since it will go to default value
        guard let callWithNoParams = CAPPluginCall(callbackId: "setMaxEventBufferTime",
                                             options: [:],
                                             success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                             error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testSetMaxEventBufferTime")
            return
        }
        
        NewRelicCapacitorPlugin.setMaxEventBufferTime(callWithGoodParams)
        NewRelicCapacitorPlugin.setMaxEventBufferTime(callWithNoParams)
        
    }

       func testSetMaxOfflineStorageSize() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "setMaxOfflineStorageSize",
                                               options: ["megaBytes": 100],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testSetMaxOfflineStorageSize")
            return
        }
        
        // Should work since it will go to default value
        guard let callWithNoParams = CAPPluginCall(callbackId: "setMaxOfflineStorageSize",
                                             options: [:],
                                             success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                             error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testSetMaxOfflineStorageSize")
            return
        }
        
        NewRelicCapacitorPlugin.setMaxOfflineStorageSize(callWithGoodParams)
        NewRelicCapacitorPlugin.setMaxOfflineStorageSize(callWithNoParams)
        
    }
    
    func testSetMaxEventPoolSize() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "setMaxEventPoolSize",
                                               options: ["maxPoolSize": 5000],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testSetMaxEventPoolSize")
            return
        }
        
        
        // Should work since it will go to default value
        guard let callWithNoParams = CAPPluginCall(callbackId: "setMaxEventPoolSize",
                                             options: [:],
                                             success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                             error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testSetMaxEventPoolSize")
            return
        }
        
        
        NewRelicCapacitorPlugin.setMaxEventPoolSize(callWithGoodParams)
        NewRelicCapacitorPlugin.setMaxEventPoolSize(callWithNoParams)
    }
    
    func testParseStackTrace() {
        let stackFramesArr = NewRelicCapacitorPlugin.parseStackTrace(stackString: "decodeURI@[native code]\nonClick@capacitor://localhost/static/js/main.512e3679.js:2:616972\n@capacitor://localhost/static/js/main.512e3679.js:2:549141\nAe@capacitor://localhost/static/js/main.512e3679.js:2:104370\nWe@capacitor://localhost/static/js/main.512e3679.js:2:104524\n@capacitor://localhost/static/js/main.512e3679.js:2:124424\njr@capacitor://localhost/static/js/main.512e3679.js:2:124513\nzr@capacitor://localhost/static/js/main.512e3679.js:2:124930\n@capacitor://localhost/static/js/main.512e3679.js:2:130372\ncc@capacitor://localhost/static/js/main.512e3679.js:2:194040\nRe@capacitor://localhost/static/js/main.512e3679.js:2:103499\nBr@capacitor://localhost/static/js/main.512e3679.js:2:126224\nUt@capacitor://localhost/static/js/main.512e3679.js:2:110620\nFt@capacitor://localhost/static/js/main.512e3679.js:2:110404\nFt@[native code]")
        XCTAssertTrue((stackFramesArr as Any) is NSMutableArray)
        XCTAssertEqual(15, stackFramesArr.count)
        for stackFrame in stackFramesArr {
            XCTAssertTrue((stackFrame as Any) is NSMutableDictionary)
            let stackFrameDict = stackFrame as! NSMutableDictionary
            XCTAssertNotNil(stackFrameDict["file"])
            XCTAssertNotNil(stackFrameDict["method"])
        }
        
        let badStackFrame = NewRelicCapacitorPlugin.parseStackTrace(stackString: "fakestacktrace\n poor structure\n testing")
        XCTAssertTrue((badStackFrame as Any) is NSMutableArray)
        XCTAssertEqual(0, badStackFrame.count)
    }
    
    func testRecordError() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "recordError",
                                               options: ["name": "URIError",
                                                         "message": "URI error",
                                                         "stack": "decodeURI@[native code]\nonClick@capacitor://localhost/static/js/main.512e3679.js:2:616972\n@capacitor://localhost/static/js/main.512e3679.js:2:549141\nAe@capacitor://localhost/static/js/main.512e3679.js:2:104370\nWe@capacitor://localhost/static/js/main.512e3679.js:2:104524\n@capacitor://localhost/static/js/main.512e3679.js:2:124424\njr@capacitor://localhost/static/js/main.512e3679.js:2:124513\nzr@capacitor://localhost/static/js/main.512e3679.js:2:124930\n@capacitor://localhost/static/js/main.512e3679.js:2:130372\ncc@capacitor://localhost/static/js/main.512e3679.js:2:194040\nRe@capacitor://localhost/static/js/main.512e3679.js:2:103499\nBr@capacitor://localhost/static/js/main.512e3679.js:2:126224\nUt@capacitor://localhost/static/js/main.512e3679.js:2:110620\nFt@capacitor://localhost/static/js/main.512e3679.js:2:110404\nFt@[native code]",
                                                         "isFatal": true],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testRecordError")
            return
        }
        
        // Should not reject with null error (avoid infinite loop)
        guard let callWithNoParams = CAPPluginCall(callbackId: "recordError",
                                             options: [:],
                                             success: { (result, call) in
            XCTAssertNotNil(result);
        },
                                             error:{ (err) in
            XCTFail("Error shouldn't have been called since we do not reject null errors")
        }) else {
            XCTFail("Bad call in testRecordError")
            return
        }
        
        NewRelicCapacitorPlugin.recordError(callWithGoodParams)
        NewRelicCapacitorPlugin.recordError(callWithNoParams)
    }
    
    func testNetworkRequestEnabled() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "networkRequestEnabled",
                                               options: ["enabled": false],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testNetworkRequestEnabled")
            return
        }
        
        guard let callWithNoParams = CAPPluginCall(callbackId: "networkRequestEnabled",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("networkRequestEnabled should fail with no parameters")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad value in networkRequestEnabled")
        }) else {
            XCTFail("Bad call in testNetworkRequestEnabled")
            return
        }
        
        NewRelicCapacitorPlugin.networkRequestEnabled(callWithGoodParams)
        NewRelicCapacitorPlugin.networkRequestEnabled(callWithNoParams)
    }
    
    func testNetworkErrorRequestEnabled() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "networkErrorRequestEnabled",
                                               options: ["enabled": false],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testNetworkErrorRequestEnabled")
            return
        }
        
        guard let callWithNoParams = CAPPluginCall(callbackId: "networkRequestEnabled",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("networkErrorRequestEnabled should fail with no parameters")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad value in networkErrorRequestEnabled")
        }) else {
            XCTFail("Bad call in testNetworkErrorRequestEnabled")
            return
        }
        
        NewRelicCapacitorPlugin.networkErrorRequestEnabled(callWithGoodParams)
        NewRelicCapacitorPlugin.networkErrorRequestEnabled(callWithNoParams)
    }
    
    func testHttpResponseBodyCaptureEnabled() {
        guard let callWithGoodParams = CAPPluginCall(callbackId: "httpResponseBodyCaptureEnabled",
                                               options: ["enabled": false],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testHttpResponseBodyCaptureEnabled")
            return
        }
        
        guard let callWithNoParams = CAPPluginCall(callbackId: "httpResponseBodyCaptureEnabled",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("httpResponseBodyCapture should fail with no parameters")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad value in httpResponseBodyCaptureEnabled")
        }) else {
            XCTFail("Bad call in testHttpResponseBodyCaptureEnabled")
            return
        }
        
        NewRelicCapacitorPlugin.httpResponseBodyCaptureEnabled(callWithGoodParams)
        NewRelicCapacitorPlugin.httpResponseBodyCaptureEnabled(callWithNoParams)
    }
    
    func testShutdown() {
        guard let call = CAPPluginCall(callbackId: "shutdown",
                                 options: [:],
                                 success: { (result, call) in
            XCTAssertNotNil(result);
        },
                                 error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in testShutdown")
            return
        }
        
        NewRelicCapacitorPlugin.shutdown(call)
    }

    func testGetAgentConfiguration() {
        guard let call = CAPPluginCall(callbackId: "getAgentConfiguration",
                                 options: [:],
                                 success: { (result, call) in
            XCTAssertNotNil(result);
        },
                                 error:{ (err) in
            XCTFail("Error shouldn't have been called")
        }) else {
            XCTFail("Bad call in getAgentConfiguration")
            return
        }

        NewRelicCapacitorPlugin.getAgentConfiguration(call)
    }

}

