# Changelog

## 1.3.2

## New in this release
* Implementing HTTP Instrumentation for Angular HTTP Client
* Integrated HTTP Instrumentation for XMLHttpRequest and Axios HTTP clients
* Introduced support for custom attributes in the `recordError` method

## 1.3.1

## New in this release
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