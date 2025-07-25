//
//  OverlayWindow.swift
//  ActivateMacOverlay
//
//  Created by Rafael Neuwirth Swierczynski on 25/07/25.
//

import AppKit
import SwiftUI

class OverlayWindow {
    private var window: NSWindow?

    func show(message: String) {
        if window == nil {
            let width: CGFloat = 370
            let view = NSHostingView(rootView: OverlayView(customText: message))
            view.frame.size.width = width

            let fittingSize = view.fittingSize
            view.frame.size.height = fittingSize.height

            let screen = NSScreen.main?.visibleFrame ?? .zero
            let x = screen.maxX - width - 30
            let y = screen.minY + 50

            window = NSWindow(
                contentRect: NSRect(x: x, y: y, width: width, height: fittingSize.height),
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )
            window?.level = .floating
            window?.isOpaque = false
            window?.backgroundColor = .clear
            window?.ignoresMouseEvents = true
            window?.contentView = view
        }

        window?.makeKeyAndOrderFront(nil)
    }
}
