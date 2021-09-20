fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## Android
### android adhoc
```
fastlane android adhoc
```
Upload a new Android adhoc Build to Apple App Connect
### android beta
```
fastlane android beta
```
Submit a new android Beta Build to Google Play Store
### android release
```
fastlane android release
```
Deploy a new version to the Google Play

----

## iOS
### ios adhoc
```
fastlane ios adhoc
```
Upload a new ios adhoc Build to Apple App Connect
### ios beta
```
fastlane ios beta
```
Upload a new ios Beta Build to Apple App Connect
### ios release
```
fastlane ios release
```
Push a new release build to the App Store

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
