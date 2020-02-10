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
    let pushController = PushController()
    let simulatorController = SimulatorController()
    lazy var contentView: ContentView = {
        ContentView(simulatorController: simulatorController)
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
        NSApplication.shared.registerForRemoteNotifications()
    }

    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let hex = deviceToken.map { String(format: "%02X", $0) }.joined()
        print("Registered with token: \(hex)")
    }

    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register with error \(error)")
    }

    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        print("Received \(userInfo)")
        do {
            let url = try pushController.writeToDisk(userInfo: userInfo)
            guard let selected = contentView.selectedSimulator else { return }
            try simulatorController.sendAPNS(at: url, to: selected)
        } catch {
            print("Error: \(error)")
        }
    }

}
