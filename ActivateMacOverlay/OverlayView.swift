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
            
            let forceEnglish = UserDefaults.standard.bool(forKey: "forceEnglish")
            
            let translatedTitle = String(format: NSLocalizedString("windowsActivateTitle", comment: ""), customText)
            let englishTitle = "Activate \(customText)";
            let title = forceEnglish ? englishTitle : translatedTitle
            
            Text(title)
                .font(.system(size: 19.5))
                .foregroundColor(Color.gray)
            
            let translatedDescription = String(format: NSLocalizedString("windowsActivateDescription", comment: ""), customText);
            let englishDescription = "Go to Settings to activate \(customText).";
            let description = forceEnglish ? englishDescription : translatedDescription;
            

            Text(description)
                .font(.system(size: 16))
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
        }
        .padding(10)
    }
}
