//
//  AppDelegate.swift
//  ActivateMacOverlay
//
//  Created by Rafael Neuwirth Swierczynski on 25/07/25.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let mainAppURL = Bundle.main.bundleURL.deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("MacOS/ActivateMacOverlay.app") {
            NSWorkspace.shared.open(mainAppURL)
        }
        NSWorkspace.shared.open(URL(fileURLWithPath: path))
        NSApp.terminate(nil)
    }
}
