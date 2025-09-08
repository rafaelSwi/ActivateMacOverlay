//
//  ActivateMacOverlayApp.swift
//  ActivateMacOverlay
//
//  Created by Rafael Neuwirth Swierczynski on 25/07/25.
//

import SwiftUI

@main
struct ActivateMacOverlayApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("forceEnglish") private var forceEnglish = false

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController!
    var overlayWindow: OverlayWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController()
        overlayWindow = OverlayWindow()
        overlayWindow.show(message: UserDefaults.standard.string(forKey: "customOverlayText") ?? "macOS")
    }
}
