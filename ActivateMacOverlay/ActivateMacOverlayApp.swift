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
    @AppStorage(UserDefaults.Keys.forceEnglish) private var forceEnglish = false
    
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
        let replace: Bool = UserDefaults.standard.bool(forKey: UserDefaults.Keys.replace);
        if (replace) {
            overlayWindow.show(
                message: UserDefaults.standard.string(forKey: UserDefaults.Keys.customOverlayText) ?? "macOS",
                replace: Replace(
                    title: UserDefaults.standard.string(forKey: UserDefaults.Keys.titleReplace) ?? "EMPTY_TITLE",
                    description: UserDefaults.standard.string(forKey: UserDefaults.Keys.descriptionReplace) ?? "EMPTY_DESCRIPTION"
                )
            )
        } else {
            overlayWindow.show(message: UserDefaults.standard.string(forKey: UserDefaults.Keys.customOverlayText) ?? "macOS", replace: nil)
        }
    }
}
