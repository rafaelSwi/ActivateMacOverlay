//
//  LoginItemManager.swift
//  ActivateMacOverlay
//
//  Created by Rafael Neuwirth Swierczynski on 25/07/25.
//

import ServiceManagement

struct LoginItemManager {
    static let identifier = Bundle.main.bundleIdentifier!

    static func enableLoginItem() {
        SMLoginItemSetEnabled(identifier as CFString, true)
    }

    static func disableLoginItem() {
        SMLoginItemSetEnabled(identifier as CFString, false)
    }

    static func isLoginItemEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "loginItemEnabled")
    }
}
