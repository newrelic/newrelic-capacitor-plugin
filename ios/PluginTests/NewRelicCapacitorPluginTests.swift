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
        let callWithKey = CAPPluginCall(callbackId: "start",
                                        options: ["appKey": "fake-key"],
                                        success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                        error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        let callWithNoKey = CAPPluginCall(callbackId: "start",
                                          options: [:],
                                          success: { (result, call) in
            XCTFail("Agent start should not work with nil key")
        },
                                          error:{ (err) in
            XCTAssertEqual(err!.message,"Nil API key given to New Relic Agent start")
        })
        NewRelicCapacitorPlugin.start(callWithKey!)
        NewRelicCapacitorPlugin.start(callWithNoKey!)
    }
    
    func testSetUserId() {
        let callWithKey = CAPPluginCall(callbackId: "setUserId",
                                        options: ["userId": "fakeId"],
                                        success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                        error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        let callWithNoKey = CAPPluginCall(callbackId: "setUserId",
                                          options: [:],
                                          success: { (result, call) in
            XCTFail("setUserId should not be successful with no userId")
        },
                                          error:{ (err) in
            XCTAssertEqual(err!.message, "Nil userId given to setUserId")
        })
        NewRelicCapacitorPlugin.setUserId(callWithKey!)
        NewRelicCapacitorPlugin.setUserId(callWithNoKey!)
    }
    
    func testSetAttribute() {
        let callWithGoodParams = CAPPluginCall(callbackId: "setAttribute",
                                               options: ["name": "fakeAttributeName",
                                                         "value": "21"],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        let callWithBadName = CAPPluginCall(callbackId: "setAttribute",
                                            options: ["value": "01"],
                                            success: { (result, call) in
            XCTFail("setAttribute should not work with nil name")
        },
                                            error: { (err) in
            XCTAssertTrue(err!.message == "Nil name or value given to setAttribute")
        })
        
        let callWithBadValue = CAPPluginCall(callbackId: "setAttribute",
                                             options: ["name": "fakeName"],
                                             success: { (result, call) in
            XCTFail("setAttribute should not work with nil value")
        },
                                             error: { (err) in
            XCTAssertEqual(err!.message, "Nil name or value given to setAttribute")
        })
        
        NewRelicCapacitorPlugin.setAttribute(callWithGoodParams!)
        NewRelicCapacitorPlugin.setAttribute(callWithBadName!)
        NewRelicCapacitorPlugin.setAttribute(callWithBadValue!)
    }
    
    func testRemoveAttribute() {
        let callWithGoodParams = CAPPluginCall(callbackId: "removeAttribute",
                                               options: ["name": "fakeAttributeName"],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        let callWithBadName = CAPPluginCall(callbackId: "removeAttribute",
                                            options: [:],
                                            success: { (result, call) in
            XCTFail("removeAttribute should not work with nil name")
        },
                                            error: { (err) in
            XCTAssertEqual(err!.message, "Nil name given to removeAttribute")
        })
        
        
        NewRelicCapacitorPlugin.removeAttribute(callWithGoodParams!)
        NewRelicCapacitorPlugin.removeAttribute(callWithBadName!)
    }
    
    func testRecordBreadcrumb() {
        let callWithGoodParams = CAPPluginCall(callbackId: "recordBreadcrumb",
                                               options: ["name": "fakeBreadName",
                                                         "eventAttributes": ["{'fakeAttr': 1}"]
                                                        ],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        let callWithNoAttributes = CAPPluginCall(callbackId: "recordBreadcrumb",
                                                 options: ["name": "fakeBreadName"],
                                                 success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                                 error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        let callWithBadName = CAPPluginCall(callbackId: "recordBreadcrumb",
                                            options: [:],
                                            success: { (result, call) in
            XCTFail("recordBreadcrumb should not work with nil name")
        },
                                            error: { (err) in
            XCTAssertEqual(err!.message, "Nil name given to recordBreadcrumb")
        })
        
        
        NewRelicCapacitorPlugin.recordBreadcrumb(callWithGoodParams!)
        NewRelicCapacitorPlugin.recordBreadcrumb(callWithNoAttributes!)
        NewRelicCapacitorPlugin.recordBreadcrumb(callWithBadName!)
        
    }
    
    func testRecordCustomEvent() {
        let callWithGoodParams = CAPPluginCall(callbackId: "recordCustomEvent",
                                               options: ["name": "fakeEventName",
                                                         "eventType": "fakeEventType",
                                                         "eventAttributes": ["{'fakeAttr': 1}"]
                                                        ],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        let callWithNoType = CAPPluginCall(callbackId: "recordCustomEvent",
                                           options: ["name": "fakeEventName",
                                                     "eventAttributes": ["{'fakeAttr': 1}"]],
                                           success: { (result, call) in
            XCTFail("recordBreadcrumb should not be successful without eventType")
        },
                                           error:{ (err) in
            XCTAssertEqual(err!.message, "Nil eventType given to recordCustomEvent")
        })
        
        let callWithNoNameOrAttributes = CAPPluginCall(callbackId: "recordCustomEvent",
                                                       options: ["eventType": "fakeEventType"],
                                                       success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                                       error: { (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        NewRelicCapacitorPlugin.recordCustomEvent(callWithGoodParams!)
        NewRelicCapacitorPlugin.recordCustomEvent(callWithNoType!)
        NewRelicCapacitorPlugin.recordCustomEvent(callWithNoNameOrAttributes!)
        
    }
    
    func testStartInteraction() {
        let callWithGoodParams = CAPPluginCall(callbackId: "startInteraction",
                                               options: ["value": "interactionName"],
                                               success: { (result, call) in
            let resultValue = result?.data!["value"]
            XCTAssertNotNil(resultValue)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        let callWithNoName = CAPPluginCall(callbackId: "startInteraction",
                                           options: [:],
                                           success: { (result, call) in
            XCTFail("startInteraction should not be successful without name")
        },
                                           error:{ (err) in
            XCTAssertEqual(err!.message, "Nil value given to startInteraction")
        })
        
        
        NewRelicCapacitorPlugin.startInteraction(callWithGoodParams!)
        NewRelicCapacitorPlugin.startInteraction(callWithNoName!)
    }
    
    func testEndInteraction() {
        let callWithGoodParams = CAPPluginCall(callbackId: "endInteraction",
                                               options: ["interactionId": "interactionName"],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        let callWithNoName = CAPPluginCall(callbackId: "endInteraction",
                                           options: [:],
                                           success: { (result, call) in
            XCTFail("endInteraction should not be successful without name")
        },
                                           error:{ (err) in
            XCTAssertEqual(err!.message, "Nil interactionId given to endInteraction")
        })
        
        NewRelicCapacitorPlugin.endInteraction(callWithGoodParams!)
        NewRelicCapacitorPlugin.endInteraction(callWithNoName!)
    }
    
    func testCurrentSessionId() {
        
        let call = CAPPluginCall(callbackId: "currentSessionId",
                                 options: [:],
                                 success: { (result, call) in
            let resultValue = result?.data!["sessionId"]
            XCTAssert(resultValue != nil)
        },
                                 error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        NewRelicCapacitorPlugin.currentSessionId(call!)
    }
    
    func testIncrementAttribute() {
        let callWithGoodParams = CAPPluginCall(callbackId: "incrementAttribute",
                                               options: ["name": "incrAttr",
                                                         "value": 20],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        let callWithNoValue = CAPPluginCall(callbackId: "incrementAttribute",
                                            options: ["name": "incrAttr"],
                                            success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                            error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        let callWithStrValue = CAPPluginCall(callbackId: "incrementAttribute",
                                            options: ["name": "incrAttr",
                                                      "value": "17"],
                                            success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                            error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        let callWithNoName = CAPPluginCall(callbackId: "incrementAttribute",
                                            options: ["value": 12],
                                            success: { (result, call) in
            XCTFail("incrementAttribute")
        },
                                            error:{ (err) in
            XCTAssertEqual(err!.message, "Nil name in incrementAttribute")
        })
        
        NewRelicCapacitorPlugin.incrementAttribute(callWithGoodParams!)
        NewRelicCapacitorPlugin.incrementAttribute(callWithNoValue!)
        NewRelicCapacitorPlugin.incrementAttribute(callWithStrValue!)
        NewRelicCapacitorPlugin.incrementAttribute(callWithNoName!)
        
    }
    
    func testNoticeHttpTransaction() {
        let callWithGoodParams = CAPPluginCall(callbackId: "noticeHttpTransaction",
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
        })
        
        let callWithNoParams = CAPPluginCall(callbackId: "noticeHttpTransaction",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("noticeHttpTransaction should not work with nil params")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad parameters given to noticeHttpTransaction")
        })
        
        NewRelicCapacitorPlugin.noticeHttpTransaction(callWithGoodParams!)
        NewRelicCapacitorPlugin.noticeHttpTransaction(callWithNoParams!)
    }
    
    func testNoticeNetworkFailure() {
        let callWithGoodParams = CAPPluginCall(callbackId: "noticeNetworkFailure",
                                               options: ["url": "https://fakewebsite.com",
                                                         "method": "GET",
                                                         "status": 404,
                                                         "startTime": Date().timeIntervalSince1970,
                                                         "endTime": Date().timeIntervalSince1970,
                                                         "failure": "DNSLookupFailed"],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        let callWithBadFailureName = CAPPluginCall(callbackId: "noticeNetworkFailure",
                                                   options: ["url": "https://fakewebsite.com",
                                                             "method": "GET",
                                                             "status": 404,
                                                             "startTime": Date().timeIntervalSince1970,
                                                             "endTime": Date().timeIntervalSince1970,
                                                             "failure": "FakeFailure"],
                                                   success: { (result, call) in
            XCTFail("noticeNetworkFailure should fail with bad failure name")
        },
                                               error:{ (err) in
            XCTAssertEqual(err!.message, "Bad failure name given to noticeNetworkFailure. Use one of: Unknown, BadURL, TimedOut, CannotConnectToHost, DNSLookupFailed, BadServerResponse, or SecureConnectionFailed")
        })
        
        let callWithNoParams = CAPPluginCall(callbackId: "noticeNetworkFailure",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("noticeHttpTransaction should not work with nil params")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad parameters given to noticeNetworkFailure")
        })
        
        NewRelicCapacitorPlugin.noticeNetworkFailure(callWithGoodParams!)
        NewRelicCapacitorPlugin.noticeNetworkFailure(callWithBadFailureName!)
        NewRelicCapacitorPlugin.noticeNetworkFailure(callWithNoParams!)
    }
    
    func testRecordMetric() {
        let callWithGoodParams = CAPPluginCall(callbackId: "recordMetric",
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
        })
        let callWithGoodParams2 = CAPPluginCall(callbackId: "recordMetric",
                                                options: ["name": "metricName",
                                                         "category": "metricCategory",
                                                          "value": 27],
                                                success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                                error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        let callWithGoodParams3 = CAPPluginCall(callbackId: "recordMetric",
                                                options: ["name": "metricName",
                                                         "category": "metricCategory"],
                                                success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                                error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        let callWithBadMetricUnit = CAPPluginCall(callbackId: "recordMetric",
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
          })
        let callWithBadParams = CAPPluginCall(callbackId: "recordMetric",
                                              options: ["name": "metricName",
                                                            "category": "metricCategory",
                                                        "value": 27,
                                                            "valueUnit": "OPERATIONS",
                                                           ],
                                              success: { (result, call) in
              XCTFail("recordMetric should not work with bad metric unit")
          },
                                                  error:{ (err) in
            XCTAssertEqual(err!.message, "countUnit and valueUnit must both be set together in recordMetric")
          })
        let callWithNoParams = CAPPluginCall(callbackId: "recordMetric",
                                             options: [:],
                                             success: { (result, call) in
              XCTFail("recordMetric should not work with no params")
          },
                                                  error:{ (err) in
            XCTAssertEqual(err!.message, "Bad name or category given to recordMetric")
          })
        
        NewRelicCapacitorPlugin.recordMetric(callWithGoodParams!)
        NewRelicCapacitorPlugin.recordMetric(callWithGoodParams2!)
        NewRelicCapacitorPlugin.recordMetric(callWithGoodParams3!)
        NewRelicCapacitorPlugin.recordMetric(callWithBadMetricUnit!)
        NewRelicCapacitorPlugin.recordMetric(callWithBadParams!)
        NewRelicCapacitorPlugin.recordMetric(callWithNoParams!)
    }
    
    func testRemoveAllAttributes() {
        let callWithGoodParams = CAPPluginCall(callbackId: "removeAllAttributes",
                                               options: [:],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        NewRelicCapacitorPlugin.removeAllAttributes(callWithGoodParams!)
    }
    
    func testSetMaxEventBufferTime() {
        let callWithGoodParams = CAPPluginCall(callbackId: "setMaxEventBufferTime",
                                               options: ["maxBufferTimeInSeconds": 60],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        // Should work since it will go to default value
        let callWithNoParams = CAPPluginCall(callbackId: "setMaxEventBufferTime",
                                             options: [:],
                                             success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                             error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        NewRelicCapacitorPlugin.setMaxEventBufferTime(callWithGoodParams!)
        NewRelicCapacitorPlugin.setMaxEventBufferTime(callWithNoParams!)
        
    }
    
    func testSetMaxEventPoolSize() {
        let callWithGoodParams = CAPPluginCall(callbackId: "setMaxEventPoolSize",
                                               options: ["maxPoolSize": 5000],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        // Should work since it will go to default value
        let callWithNoParams = CAPPluginCall(callbackId: "setMaxEventPoolSize",
                                             options: [:],
                                             success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                             error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        NewRelicCapacitorPlugin.setMaxEventPoolSize(callWithGoodParams!)
        NewRelicCapacitorPlugin.setMaxEventPoolSize(callWithNoParams!)
    }
    
    func testRecordError() {
        let callWithGoodParams = CAPPluginCall(callbackId: "recordError",
                                               options: ["name": "fakeError",
                                                         "message": "fakeMsg",
                                                         "stack": "fakeStack",
                                                         "isFatal": false],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        let callWithNoParams = CAPPluginCall(callbackId: "recordError",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("recordError should fail with no parameters")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad parameters given to recordError")
        })
        
        NewRelicCapacitorPlugin.recordError(callWithGoodParams!)
        NewRelicCapacitorPlugin.recordError(callWithNoParams!)
    }
    
    func testNetworkRequestEnabled() {
        let callWithGoodParams = CAPPluginCall(callbackId: "networkRequestEnabled",
                                               options: ["enabled": false],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        let callWithNoParams = CAPPluginCall(callbackId: "networkRequestEnabled",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("networkRequestEnabled should fail with no parameters")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad value in networkRequestEnabled")
        })
        
        NewRelicCapacitorPlugin.networkRequestEnabled(callWithGoodParams!)
        NewRelicCapacitorPlugin.networkRequestEnabled(callWithNoParams!)
    }
    
    func testNetworkErrorRequestEnabled() {
        let callWithGoodParams = CAPPluginCall(callbackId: "networkErrorRequestEnabled",
                                               options: ["enabled": false],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        let callWithNoParams = CAPPluginCall(callbackId: "networkRequestEnabled",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("networkErrorRequestEnabled should fail with no parameters")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad value in networkErrorRequestEnabled")
        })
        
        NewRelicCapacitorPlugin.networkErrorRequestEnabled(callWithGoodParams!)
        NewRelicCapacitorPlugin.networkErrorRequestEnabled(callWithNoParams!)
    }
    
    func testHttpRequestBodyCaptureEnabled() {
        let callWithGoodParams = CAPPluginCall(callbackId: "httpRequestBodyCaptureEnabled",
                                               options: ["enabled": false],
                                               success: { (result, call) in
            XCTAssertNotNil(result)
        },
                                               error:{ (err) in
            XCTFail("Error shouldn't have been called")
        })
        
        let callWithNoParams = CAPPluginCall(callbackId: "httpRequestBodyCaptureEnabled",
                                             options: [:],
                                             success: { (result, call) in
            XCTFail("httpRequestBodyCapture should fail with no parameters")
        },
                                             error:{ (err) in
            XCTAssertEqual(err!.message, "Bad value in httpRequestBodyCaptureEnabled")
        })
        
        NewRelicCapacitorPlugin.httpRequestBodyCaptureEnabled(callWithGoodParams!)
        NewRelicCapacitorPlugin.httpRequestBodyCaptureEnabled(callWithNoParams!)
    }
    
}
