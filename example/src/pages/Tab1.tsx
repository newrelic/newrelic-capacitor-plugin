/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

import {
  IonButton,
  IonCard,
  IonCardHeader,
  IonCardTitle,
  IonContent,
  IonItem,
  IonLabel,
  IonList,
  IonToggle,
} from "@ionic/react";

import {NewRelicCapacitorPlugin, NREnums} from "@newrelic/newrelic-capacitor-plugin";
import {useState} from "react";
import ErrorBoundary from "../ErrorBoundary";

import './Tab1.css';
import LogLevel = NREnums.LogLevel;


const Tab1: React.FC = () => {

  const crashHandler = () => {
    NewRelicCapacitorPlugin.crashNow();
  };
  const idHandler = async () => {
    let { sessionId } = await NewRelicCapacitorPlugin.currentSessionId();
    alert(sessionId);
  };

  const httpHandler = async () => {

    NewRelicCapacitorPlugin.log({level:LogLevel.INFO, message: "http transaction started"});
    NewRelicCapacitorPlugin.log({level:LogLevel.ERROR, message: "http transaction error"});
    NewRelicCapacitorPlugin.logAll({ error: "http transaction warn", attributes: { "val": "teststtststst", "level": LogLevel.INFO } });
    NewRelicCapacitorPlugin.logAttributes({ attributes: { "name": "CapaCitor APP", "message": "httpHandler", "level": LogLevel.VERBOSE } });

    NewRelicCapacitorPlugin.noticeHttpTransaction({
      url: "https://fakewebsite201.com",
      method: "GET",
      status: 201,
      startTime: Date.now(),
      endTime: Date.now(),
      bytesSent: 10000,
      bytesReceived: 20000,
      body: "fake http response body 201",
    });
    NewRelicCapacitorPlugin.logInfo({ message: "http transaction ended" });

  }
  const networkFailureHandler = () => {
    NewRelicCapacitorPlugin.noticeHttpTransaction({
      url: "https://fakewebsite400.com",
      method: "GET",
      status: 400,
      startTime: Date.now(),
      endTime: Date.now(),
      bytesSent: 10000,
      bytesReceived: 20000,
      body: "fake http response body 400",
    });
  };

  const setAttrHandler = () => {
    NewRelicCapacitorPlugin.logDebug({ message: "set attribute" });
    NewRelicCapacitorPlugin.setAttribute({ name: "testSetAttr", value: "5" });
  };
  const incrementHandler = () => {
    NewRelicCapacitorPlugin.incrementAttribute({
      name: "testIncrAttr",
      value: 4,
    });
    NewRelicCapacitorPlugin.incrementAttribute({ name: "testIncrAttrNoVal" });
  };
  const removeAttrHandler = () => {
    NewRelicCapacitorPlugin.removeAttribute({ name: "testSetAttr" });
  };
  const removeAllHandler = () => {
    NewRelicCapacitorPlugin.removeAllAttributes();
  };

  const bufferHandler = () => {
    NewRelicCapacitorPlugin.setMaxEventBufferTime({
      maxBufferTimeInSeconds: 65,
    });
  };
  const poolHandler = () => {
    NewRelicCapacitorPlugin.setMaxEventPoolSize({ maxPoolSize: 1250 });
  };
  const eventHandler = () => {
    for (let i = 0; i < 1500; i++) {
      NewRelicCapacitorPlugin.recordCustomEvent({
        eventName: "poolSizeEventName",
        eventType: "poolSizeEventType",
        attributes: { num: i },
      });
    }
  };

  const metricHandler = () => {
    NewRelicCapacitorPlugin.log({level:LogLevel.INFO, message: "record metrics"});
    NewRelicCapacitorPlugin.logVerbose({ message: "send many events" });
    NewRelicCapacitorPlugin.recordMetric({
      name: "testMetricName",
      category: "testMetricCategory",
    });
    NewRelicCapacitorPlugin.recordMetric({
      name: "testMetricName2",
      category: "testMetricCategory2",
      value: 25,
    });
    NewRelicCapacitorPlugin.recordMetric({
      name: "testMetricName3",
      category: "testMetricCategory3",
      value: 30,
      countUnit: "SECONDS",
      valueUnit: "OPERATIONS",
    });
  };

  const noticeNetworkHandler = async () => {

    NewRelicCapacitorPlugin.logError({ message: "notice network failure" });
    NewRelicCapacitorPlugin.logAttributes({attributes: {"test":"test","message":"noticeNetworkHandler", "level":LogLevel.VERBOSE}});
    const response = await fetch("https://reactnative.dev/movies.json");
    const movies = await response.json();
    console.log(movies);

    // NewRelicCapacitorPlugin.noticeNetworkFailure({
    //   url: "https://fakewebsite400.com",
    //   method: "GET",
    //   startTime: Date.now(),
    //   endTime: Date.now() + 200,
    //   failure: "BadURL"
    // });
  };

  const errorHandler = () => {

    NewRelicCapacitorPlugin.logAll({error: "record error", attributes: {"test":"test", "level":LogLevel.INFO}});
    try {
      throw new Error('testMsg');
    } catch (e: any) {
      NewRelicCapacitorPlugin.recordError({
        name: e.name,
        message: e.message,
        stack: e.stack,
        isFatal: false,
      });
    }
  };
  const breadcrumbHandler = () => {
    NewRelicCapacitorPlugin.recordBreadcrumb({
      name: "fakebreadname",
      eventAttributes: {
        test1: 5,
        test2: false,
        test3: "str",
      },
    });
  };

  const [analyticsFlag, setAnalyticsFlag] = useState(true);
  const [networkFlag, setNetworkFlag] = useState(true);
  const [networkErrorFlag, setNetworkErrorFlag] = useState(true);
  const [httpBodyFlag, setHttpBodyFlag] = useState(true);
  // We use !flag in the New Relic call because the state does not change immediately
  const analyticsFlagHandler = () => {
    NewRelicCapacitorPlugin.analyticsEventEnabled({ enabled: !analyticsFlag});
    setAnalyticsFlag(!analyticsFlag);
  };
  const networkFlagHandler = () => {
    NewRelicCapacitorPlugin.networkRequestEnabled({ enabled: !networkFlag});
    setNetworkFlag(!networkFlag);
  };
  const networkErrorFlagHandler = () => {
    NewRelicCapacitorPlugin.networkErrorRequestEnabled({ enabled: !networkErrorFlag });
    setNetworkErrorFlag(!networkErrorFlag);
  };
  const httpBodyFlagHandler = () => {
    NewRelicCapacitorPlugin.httpResponseBodyCaptureEnabled({ enabled: !httpBodyFlag });
    setHttpBodyFlag(!httpBodyFlag);
  };

  return (
    <ErrorBoundary>
    <IonContent>
      <IonList>
        <IonCard>
          <IonCardHeader>
            <IonCardTitle>Basics</IonCardTitle>
          </IonCardHeader>
          <IonButton onClick={crashHandler}>crash</IonButton>
          <IonButton onClick={idHandler}>session id</IonButton>
        </IonCard>
        <IonCard>
          <IonCardHeader>
            <IonCardTitle>Network Requests</IonCardTitle>
          </IonCardHeader>
          <IonButton onClick={httpHandler}>HTTP Transaction</IonButton>
          <IonButton onClick={networkFailureHandler}>
            network failure
          </IonButton>
        </IonCard>
        <IonCard>
          <IonCardHeader>
            <IonCardTitle>Attributes</IonCardTitle>
          </IonCardHeader>
          <IonButton onClick={setAttrHandler}>Set attribute</IonButton>
          <IonButton onClick={incrementHandler}>Increment</IonButton>
          <IonButton onClick={removeAttrHandler}>Remove attribute</IonButton>
          <IonButton onClick={removeAllHandler}>Remove all</IonButton>
        </IonCard>
        <IonCard>
          <IonCardHeader>
            <IonCardTitle>Events/Metric</IonCardTitle>
          </IonCardHeader>
          <IonButton onClick={bufferHandler}>Buffer Time</IonButton>
          <IonButton onClick={poolHandler}>Pool Size</IonButton>
          <IonButton onClick={eventHandler}>Send many events</IonButton>
          <IonButton onClick={metricHandler}>Record Metrics</IonButton>
          <IonButton onClick={noticeNetworkHandler}>Notice Network Failure</IonButton>
        </IonCard>
        <IonCard>
          <IonCardHeader>
            <IonCardTitle>Errors</IonCardTitle>
          </IonCardHeader>
          <IonButton onClick={errorHandler}>Record Error</IonButton>
          <IonButton onClick={breadcrumbHandler}>Record Breadcrumb</IonButton>
        </IonCard>
        <IonCard>
          <IonCardHeader>
            <IonCardTitle>Feature Flags</IonCardTitle>
          </IonCardHeader>
          <IonItem>
            <IonLabel>Analytics</IonLabel>
            <IonToggle checked={analyticsFlag} onIonChange={analyticsFlagHandler}></IonToggle>
          </IonItem>
          <IonItem>
            <IonLabel>Network Requests</IonLabel>
            <IonToggle checked={networkFlag} onIonChange={networkFlagHandler}></IonToggle>
          </IonItem>
          <IonItem>
            <IonLabel>Network Error Requests</IonLabel>
            <IonToggle checked={networkErrorFlag} onIonChange={networkErrorFlagHandler}></IonToggle>
          </IonItem>
          <IonItem>
            <IonLabel>Http Body</IonLabel>
            <IonToggle checked={httpBodyFlag} onIonChange={httpBodyFlagHandler}></IonToggle>
          </IonItem>
        </IonCard>
      </IonList>
    </IonContent>
  </ErrorBoundary>
);
};


export default Tab1;
