//
//  ContentView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI


struct ChooserView: View {
    @StateObject var scorecard = ultraViewModel()  //this is kind of @ObservedObject??

    let feltColor = Color(red: 0.153, green: 0.365, blue: 0.167).gradient
    let baseFontSize = 400.0
    
    var body: some View {
        GeometryReader {geometry in
            NavigationStack {
                let frameWidth = geometry.size.width
                ZStack {
                    Rectangle().foregroundStyle(feltColor)
                        .ignoresSafeArea()
                    VStack {
                        Spacer()
                        Text("Select Number of Players")
                            .foregroundStyle(.teal)
                        Spacer()
                        NavigationLink("🙄🤓") {StripeSolidView(players: 2)}
                            .frame(maxWidth: frameWidth*(2/5))
                        NavigationLink("🙈🙉🙊") {CutthroatView()}
                            .frame(maxWidth: frameWidth*(3/5))
                        NavigationLink("🐛🦋🐝🪲") {StripeSolidView(players: 4)}
                            .frame(maxWidth: frameWidth*(4/5))
                        NavigationLink("🤾🏼⛹🏽‍♀️🏌️🤺🏋🏽‍♀️") {UltraView(scorecard: ultraViewModel())}
                            .frame(maxWidth: frameWidth)
                        Spacer()
                    }
                    .padding()
                }
            }
            .font(.system(size: baseFontSize))
            .minimumScaleFactor(0.01)
            .lineLimit(1)
        }
    }
}

#Preview {
    ChooserView()
}
