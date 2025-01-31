//
//  PoolScorecardApp.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI

@main
struct PoolScorecardApp: App {

    var body: some Scene {
        WindowGroup {
            ChooserView()
        }
    }
//    UIApplication.shared.isIdleTimerDisabled = false

    struct Constants {
        static let textColor1 = Color(red: 0.600, green: 0.922, blue: 0.878) //#99EBE0 gray
        static let textColor2 = Color(red: 0.278, green: 0.169, blue: 0.424) //#472B6C purple
        static let symbolColor = Color(red: 0.918, green: 0.643, blue: 0.271) //#AB8148 brown
        static let XCharacter = "❌"
//        static let XCharacter = "☠️"
        static let fontName = "Red Hat Display"
        static let hats = ["🧢", "🎩", "🎓", "👒", "⛑️", "🪖"]
        static let buttonHeight:CGFloat = 90
    }
}


