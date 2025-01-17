//
//  NewGameView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 12/24/24.
//

import SwiftUI

struct NewGameView: View {
    let ballsVisible: Bool

    var body: some View {
        ZStack{
            Image(systemName: Constants.restart.image)
                .tint(PoolScorecardApp.Constants.symbolColor)
                .fontWeight(.bold)
                .rotationEffect(Angle(degrees: ballsVisible ? 360 : 0))
                .animation(.easeInOut(duration: ballsVisible ? 0 : 1.0), value: ballsVisible)
            Text("New Game")
                .font(Font.custom(PoolScorecardApp.Constants.fontName, size: Constants.text.maxFont))
                .fontWeight(.bold)
                .minimumScaleFactor(Constants.text.minFontScale)
                .lineLimit(1)
                .tint(PoolScorecardApp.Constants.textColor2)
                .shadow(color: .white, radius: 20)
//                .shadow(color: PoolScorecardApp.Constants.textColor2, radius: 30)
//                .opacity(0.9)
                .padding()
        }
    }
    
    private struct Constants {
        struct text {
            static let maxFont: CGFloat = 80
            static let minFont: CGFloat = 15
            static let minFontScale: CGFloat = minFont / maxFont
//            static let color = Color.white
        }
        struct restart {
            static let image = "arrow.trianglehead.2.counterclockwise"
            static let tint = Color.yellow
        }
    }
}
