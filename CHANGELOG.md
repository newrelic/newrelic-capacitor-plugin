# Changelog

## 1.3.3

## New in this release
We have made some updates to our system to improve its functionality. These changes include:

- fetch instrumentation for http request
- Adds configurable request header instrumentation to network events 
  The agent will now produce network event attributes for select header values if the headers are detected on the request. The header names to instrument are passed into the agent when started.
- Upgrading the native iOS agent to version 7.4.8.
- Upgrading the native Android agent to version 7.2.0.

These updates are intended to improve overall performance and functionality of our system. We appreciate your patience and understanding as we work to enhance your experience.


## 1.3.2

## New in this release
We have made some updates to our system to improve its functionality. These changes include:

- Adding support for non-text XMLHttpRequest response types for HTTP Instrumentation.
- Fixing an issue where data was not being sent to the correct endpoint in cases where the Agent Configuration was not set up properly.
- Upgrading the native iOS agent to version 7.4.7.
- Upgrading the native Android agent to version 7.1.0.

These updates are intended to improve overall performance and functionality of our system. We appreciate your patience and understanding as we work to enhance your experience.


## 1.3.1

## New in this release
* Implementing HTTP Instrumentation for Angular HTTP Client
* Integrated HTTP Instrumentation for XMLHttpRequest and Axios HTTP clients
* Introduced support for custom attributes in the `recordError` method
* Upgrade native iOS agent to v7.4.6

## 1.3.0

## New in this release
* Upgrade native Android agent to v7.0.0
* AGP 8 and Capacitor 5.0 Support

## 1.2.1

## New in this release
* Upgrade native iOS agent to v7.4.5
* Added FedRAMP agent configuration flag on agent start.

## 1.2.0

### New in this release
* Upgrade native Android Agent to v6.11.1
* Upgrade native iOS agent to v7.4.4
* JavaScript Errors will now be reported as handled exceptions, providing more context and stack traces in the New Relic UI.
* Added shutdown method, providing ability to shut down the agent within the current application lifecycle during runtime.

## 1.1.1
### Fixed in this Release
* Fixed an issue where errors would occur when developing for web-native apps.

## 1.1.0
### New in this Release
* Upgrade to Native Android Agent v6.10.0.
* Upgrade to Native iOS Agent v7.4.3.
* Added ability to configure agent settings on start.

### Fixed in this Release
* Fixed issue where large circular structures printed to console would cause out-of-memory issues on Android.

## 1.0.0 
### New in this Release
* New Relic Capacitor Plugin GA Release