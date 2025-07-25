//
//  OverlayView.swift
//  ActivateMacOverlay
//
//  Created by Rafael Neuwirth Swierczynski on 25/07/25.
//

import SwiftUI

struct OverlayView: View {
    var customText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text((String(format: NSLocalizedString("windowsActivateTitle", comment: ""), customText)))
                .font(.system(size: 19.5))
                .foregroundColor(Color.gray)

            Text((String(format: NSLocalizedString("windowsActivateDescription", comment: ""), customText)))
                .font(.system(size: 16))
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
        }
        .padding(10)
    }
}
