//
//  AppDelegate.swift
//  Straw
//
//  Created by Max Goedjen on 2/9/20.
//  Copyright © 2020 Max Goedjen. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    let simulatorController = SimulatorController()
    lazy var state: StateHolder = { StateHolder(targetSimulator: simulatorController.availableSimulators.first!) }()
    lazy var contentView: ContentView = {
        ContentView(state: state, simulatorController: simulatorController)
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        assertChangedBundleID()
        NSApplication.shared.registerForRemoteNotifications()
    }

    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let hex = deviceToken.map { String(format: "%02X", $0) }.joined()
        state.pushToken = hex
        registerWithYourService(deviceToken: deviceToken)
    }

    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        assertionFailure("Failed to register with error \(error)")
    }

    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: [])
            let payload = String(data: jsonData, encoding: .utf8) ?? ""
            state.lastNotification = payload
            try simulatorController.sendAPNS(payload: userInfo, to: state.targetSimulator)
        } catch {
            print("Error: \(error)")
        }
    }

}

extension AppDelegate {

    func registerWithYourService(deviceToken: Data) {
        // Perform whatever action your normal app does when it gets a push token back.
        // Probably register it with your backend.
//        assertionFailure("You need to change this ^.")
    }

}

extension AppDelegate {

    func assertChangedBundleID() {
//        assert(Bundle.main.bundleIdentifier != "com.maxgoedjen.straw", "You need to change the bundle ID of the app to match your iOS App.")
    }

}
