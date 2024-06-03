# Changelog

## 1.4.1

* Improvements

The native iOS Agent has been updated to version 7.4.12, bringing performance enhancements and bug fixes.

* New Features

A new backgroundReportingEnabled feature flag has been introduced to enable background reporting functionality.
A new newEventSystemEnabled feature flag has been added to enable the new event system.

* Bug Fixes
  Resolved a problem where console logs were not being displayed correctly in the console, ensuring that the console logging functionality now works as expected.


## 1.4.0

- Capacitor 6.0 Support
- Upgrading the native iOS agent to version 7.4.11.
- Upgrading the native Android agent to version 7.3.1.

## 1.3.7

* Updated native iOS Agent: We've upgraded the native iOS agent to version 7.4.10, which includes performance improvements and bug fixes.
* fixed an issue where agent is unable to capture fetch request if request body is undefined.


## 1.3.6

## New in this release

In this release, we are introducing several new features and updates:

* Added Offline Harvesting Feature: This new feature enables the preservation of harvest data that would otherwise be lost when the application lacks an internet connection. The stored harvests will be sent once the internet connection is re-established and the next harvest upload is successful.
* Introduced setMaxOfflineStorageSize API: This new API allows the user to determine the maximum volume of data that can be stored locally. This aids in better management and control of local data storage.
* Updated native iOS Agent: We've upgraded the native iOS agent to version 7.4.9, which includes performance improvements and bug fixes.
* Updated native Android Agent: We've also upgraded the native Android agent to version 7.3.0 bringing benefits like improved stability and enhanced features.
* Resolved an issue in the fetch instrumentation where the absence of a body led to failure in recording network requests by the agent.

These enhancements help to improve overall user experience and application performance.

## 1.3.5

## New in this release

This release addresses the following issues in the fetch instrumentation:

- Bug fix: Resolved an issue where options were undefined, causing the HTTP request to break. With this fix, options are properly defined, ensuring smooth functioning of the fetch instrumentation.

- Bug fix: Fixed an issue where the fetch instrumentation was not working correctly on browsers, rendering the customer unable to use the browser for development purposes.

These bug fixes enhance the reliability and compatibility of the fetch instrumentation, ensuring a seamless experience for customers during their development activities.


## 1.3.4

## New in this release
We have made some updates to our system to improve its functionality. These changes include:

- Fixed a bug in the fetch instrumentation where customer options were inadvertently removed when no headers were specified. Now, options will be preserved even when headers are absent.
- Resolved a bug in the XMLHttpRequest instrumentation that was throwing errors when headers were added by the instrumentation. This issue has been fixed to prevent any unexpected errors in such cases.
- Addressed an issue that resulted in app crashes when an invalid URL was encountered in the capacitor plugin. To mitigate this, a valid URL checker has been implemented to ensure that mobilerequest events are created only with valid URLs.

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
