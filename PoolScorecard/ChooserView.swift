//
//  ContentView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI


struct ChooserView: View {
    let feltColor = Color(red: 0.153, green: 0.365, blue: 0.167).gradient
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle().foregroundStyle(feltColor)
                VStack {
                    Text("Select Number of Players")
                    NavigationLink("🙄🤓") {StripeSolidView(players: 2)}
                    NavigationLink("🙈🙉🙊") {CutthroatView()}
                    NavigationLink("🐛🦋🐝🪲") {StripeSolidView(players: 4)}
                    NavigationLink("🤾🏼⛹🏽‍♀️🏌️🤺🏋🏽‍♀️") {StripeSolidView(players: 1)}
                }
                .padding()
            }
            .ignoresSafeArea()
        }
//        .navigationTitle("My List")
//        .scrollContentBackground(.hidden)// Add this
//        .background(feltColor)
//        .backgroundStyle(feltColor)
        .font(.system(size: 200))
        .minimumScaleFactor(0.01)
        .lineLimit(1)
    }
}

#Preview {
    ChooserView()
}
