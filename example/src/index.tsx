/*
 * Copyright (c) 2022-present New Relic Corporation. All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 
 */

import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import * as serviceWorkerRegistration from "./serviceWorkerRegistration";
import reportWebVitals from "./reportWebVitals";

import { NewRelicCapacitorPlugin } from "@newrelic/newrelic-capacitor-plugin";
import { Capacitor } from "@capacitor/core";
import {AgentConfiguration} from "../../src";

const container = document.getElementById("root");
const root = createRoot(container!);

var appToken;

let config:AgentConfiguration= {
    logReportingEnabled: true
};
if (Capacitor.getPlatform() === "ios") {
  appToken = "AAa413614341452f701db5d23e4574ff22fd30bf8b-NRMA";
} else {
  appToken = "AAa413614341452f701db5d23e4574ff22fd30bf8b-NRMA";
}
NewRelicCapacitorPlugin.start({appKey:appToken, agentConfiguration:config});

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://cra.link/PWA
serviceWorkerRegistration.unregister();

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
