//
//  OverlayView.swift
//  ActivateMacOverlay
//
//  Created by Rafael Neuwirth Swierczynski on 25/07/25.
//

import SwiftUI

struct OverlayView: View {
    var customText: String
    var replace: Replace?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            let forceEnglish = UserDefaults.standard.bool(forKey: UserDefaults.Keys.forceEnglish)
            
            let translatedTitle = String(format: NSLocalizedString("windowsActivateTitle", comment: ""), customText)
            let englishTitle = "Activate \(customText)";
            let stockTitle = forceEnglish ? englishTitle : translatedTitle
            let title = replace == nil ? stockTitle : replace?.title ?? "EMPTY_TITLE"
            
            Text(title)
                .font(.system(size: 19.5))
                .foregroundColor(Color.gray)
            
            let translatedDescription = String(format: NSLocalizedString("windowsActivateDescription", comment: ""), customText);
            let englishDescription = "Go to Settings to activate \(customText).";
            let stockDescription = forceEnglish ? englishDescription : translatedDescription;
            let description = replace == nil ? stockDescription : replace?.description ?? "EMPTY_DESCRIPTION"
            

            Text(description)
                .font(.system(size: 16))
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
        }
        .padding(10)
    }
}
