# straw-push
Piping macOS app notifications to the simulator

## Live iOS Notifications in the Simulator

![demo](demo.gif)

Tired of seeing this?

```Error Domain=NSCocoaErrorDomain Code=3010 "remote notifications are not supported in the simulator" UserInfo={NSLocalizedDescription=remote notifications are not supported in the simulator}```

Starting with Xcode 11.4, Xcode allows simulators to open `.apns` files representing push payloads. Unfortunately, the Simulator itself is still incapable of registering directly with APNS. This project is a bridge app that allows a Mac app to register on your iPhone Simulator's behalf, and relays the push notifications it receives.

## Getting Started

To get set up, clone the project and open it in Xcode. You'll need to replace Straw's Bundle ID with whatever your iOS app's Bundle ID is. After that, you'll need to replace the `AppDelegate` `registerWithYourService` method to do something with the push token the Mac app receives (you'll probably want to register it with whatever backend handles your push notifications). After that, build, run, and select the simulator you want. Your app should be able to receive notifications now!