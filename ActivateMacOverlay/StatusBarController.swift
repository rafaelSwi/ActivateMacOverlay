//
//  StatusBarController.swift
//  ActivateMacOverlay
//
//  Created by Rafael Neuwirth Swierczynski on 25/07/25.
//

import AppKit
import ServiceManagement
import LaunchAtLogin

class StatusBarController {
    private var statusItem: NSStatusItem
    private var menu: NSMenu

    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        menu = NSMenu()

        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "key.horizontal.fill",
                accessibilityDescription: "Key Icon"
            )
            button.image?.isTemplate = true
        }

        constructMenu()
        statusItem.menu = menu
    }

    private func constructMenu() {
        
        let titleItem = NSMenuItem(title: String(localized: "about"), action: #selector(showInfoPopup), keyEquivalent: "")
           titleItem.target = self
           menu.addItem(titleItem)

        menu.addItem(NSMenuItem.separator())
        
        let setTextItem = NSMenuItem(title: String(localized: "changeLabel"), action: #selector(promptTextChange), keyEquivalent: "")
        setTextItem.target = self
        menu.addItem(setTextItem)
        
        let setFullTextReplace = NSMenuItem(title: String(localized: "replaceText"), action: #selector(promptFullTextChange), keyEquivalent: "")
        setFullTextReplace.target = self
        menu.addItem(setFullTextReplace)
        
        menu.addItem(NSMenuItem.separator())
        
        let forceEnglishItem = NSMenuItem(
            title: String(localized: "forceEnglish"),
            action: #selector(toggleForceEnglish(_:)),
            keyEquivalent: ""
        )
        forceEnglishItem.state = UserDefaults.standard.bool(forKey: UserDefaults.Keys.forceEnglish) ? .on : .off
        forceEnglishItem.target = self
        menu.addItem(forceEnglishItem)

        let loginItem = NSMenuItem(title: String(localized: "startOnLogin"), action: #selector(toggleLogin), keyEquivalent: "")
        loginItem.state = UserDefaults.standard.bool(forKey: "loginItemEnabled") ? .on : .off
        loginItem.target = self
        menu.addItem(loginItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: String(localized: "exit"), action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        let restartItem = NSMenuItem(title: String(localized: "restart"), action: #selector(restartApp), keyEquivalent: "r")
        restartItem.target = self
        menu.addItem(restartItem)
    }
    
    @objc func showInfoPopup() {
        let alert = NSAlert()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
        alert.messageText = "ActivateMacOverlay"
        alert.informativeText = String(localized: "aboutDescription") + "\n\n" + "v\(version) (\(build))"
        alert.alertStyle = .informational
        alert.addButton(withTitle: String(localized: "confirm"))
        alert.runModal()
    }
    
    @objc func restartApp() {
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = ["-n", Bundle.main.bundlePath]
        task.launch()
        NSApp.terminate(nil)
    }

    @objc func promptTextChange() {
        let alert = NSAlert()
        alert.messageText = String(localized: "customLabel")
        alert.informativeText = String(localized: "customLabelDescription")
        alert.alertStyle = .informational

        let input = NSTextField(string: UserDefaults.standard.string(forKey: UserDefaults.Keys.customOverlayText) ?? "")
        input.translatesAutoresizingMaskIntoConstraints = false
        input.widthAnchor.constraint(equalToConstant: 250).isActive = true

        let suggestions = ["macOS", "Windows", "Linux"]
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        for suggestion in suggestions {
            let button = NSButton(title: suggestion, target: self, action: #selector(suggestionClicked(_:)))
            button.bezelStyle = .rounded
            button.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(button)
        }

        let container = NSStackView(views: [input, stack])
        container.orientation = .vertical
        container.spacing = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        container.setFrameSize(NSSize(width: 280, height: 70))

        let accessory = NSView(frame: NSRect(x: 0, y: 0, width: 280, height: 70))
        accessory.translatesAutoresizingMaskIntoConstraints = false
        accessory.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: accessory.topAnchor),
            container.leadingAnchor.constraint(equalTo: accessory.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: accessory.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: accessory.bottomAnchor),
        ])

        alert.accessoryView = accessory

        alert.addButton(withTitle: String(localized: "confirm"))
        alert.addButton(withTitle: String(localized: "cancel"))

        let response = alert.runModal()

        if response == .alertFirstButtonReturn {
            let text = input.stringValue
            UserDefaults.standard.set(text, forKey: UserDefaults.Keys.customOverlayText)
            UserDefaults.standard.set("", forKey: UserDefaults.Keys.titleReplace)
            UserDefaults.standard.set("", forKey: UserDefaults.Keys.descriptionReplace)
            UserDefaults.standard.set(false, forKey: UserDefaults.Keys.replace)
            NSApp.delegate.map {
                ($0 as? AppDelegate)?.overlayWindow.show(message: text, replace: nil)
            }
        }
    }
    
    @objc func promptFullTextChange() {
        let alert = NSAlert()
        alert.messageText = String(localized: "replaceText")
        alert.informativeText = String(localized: "replaceTextDescription")
        alert.alertStyle = .informational

        let titleInput = NSTextField(string: UserDefaults.standard.string(forKey: UserDefaults.Keys.titleReplace) ?? "")
        titleInput.translatesAutoresizingMaskIntoConstraints = false
        titleInput.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        let descriptionInput = NSTextField(string: UserDefaults.standard.string(forKey: UserDefaults.Keys.descriptionReplace) ?? "")
        descriptionInput.translatesAutoresizingMaskIntoConstraints = false
        descriptionInput.widthAnchor.constraint(equalToConstant: 250).isActive = true

        let container = NSStackView(views: [titleInput, descriptionInput])
        container.orientation = .vertical
        container.spacing = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        container.setFrameSize(NSSize(width: 280, height: 120))

        let accessory = NSView(frame: NSRect(x: 0, y: 0, width: 280, height: 120))
        accessory.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: accessory.topAnchor),
            container.leadingAnchor.constraint(equalTo: accessory.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: accessory.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: accessory.bottomAnchor),
        ])

        alert.accessoryView = accessory

        alert.addButton(withTitle: String(localized: "confirm"))
        alert.addButton(withTitle: String(localized: "cancel"))
        alert.addButton(withTitle: String(localized: "disableReplace"))

        let response = alert.runModal()

        switch response {
        case .alertFirstButtonReturn:
            let title = titleInput.stringValue
            let description = descriptionInput.stringValue
            
            UserDefaults.standard.set(title, forKey: UserDefaults.Keys.titleReplace)
            UserDefaults.standard.set(description, forKey: UserDefaults.Keys.descriptionReplace)
            UserDefaults.standard.set(true, forKey: UserDefaults.Keys.replace)
            UserDefaults.standard.set(false, forKey: UserDefaults.Keys.forceEnglish)
            
            NSApp.delegate.map {
                ($0 as? AppDelegate)?.overlayWindow.show(message: "EMPTY", replace: Replace(title: title, description: description))
            }
            
        case .alertThirdButtonReturn:
            UserDefaults.standard.set("", forKey: UserDefaults.Keys.titleReplace)
            UserDefaults.standard.set("", forKey: UserDefaults.Keys.descriptionReplace)
            UserDefaults.standard.set("", forKey: UserDefaults.Keys.customOverlayText)
            UserDefaults.standard.set(false, forKey: UserDefaults.Keys.replace)
            
            NSApp.delegate.map {
                ($0 as? AppDelegate)?.overlayWindow.show(message: "EMPTY", replace: nil)
            }
            
        default:
            break
        }
    }

    @objc func suggestionClicked(_ sender: NSButton) {
        guard let container = sender.superview?.superview as? NSStackView,
              let input = container.arrangedSubviews.first as? NSTextField else {
            return
        }
        input.stringValue = sender.title
    }

    @objc func setSuggestionText(_ sender: NSButton) {
        guard let inputField = (sender.superview?.superview as? NSStackView)?
            .arrangedSubviews.first as? NSTextField else { return }
        inputField.stringValue = sender.title
    }

    @objc func toggleLogin(_ sender: NSMenuItem) {
        let newState = !LaunchAtLogin.isEnabled
        LaunchAtLogin.isEnabled = newState
        UserDefaults.standard.set(newState, forKey: "loginItemEnabled")
        sender.state = newState ? .on : .off
    }
    
    @objc func toggleForceEnglish(_ sender: NSMenuItem) {
        let currentState = UserDefaults.standard.bool(forKey: UserDefaults.Keys.forceEnglish)
        let newState = !currentState
        UserDefaults.standard.set(newState, forKey: UserDefaults.Keys.forceEnglish)
        UserDefaults.standard.set(false, forKey: UserDefaults.Keys.replace)
        sender.state = newState ? .on : .off
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
