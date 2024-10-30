//
//  ContentView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI

struct ChooserView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("2 Players") {StripeSolidView(players: 2)}
            NavigationLink("3 Players") {StripeSolidView(players: 1)}
            NavigationLink("4 Players") {StripeSolidView(players: 4)}
            NavigationLink("5 Players") {StripeSolidView(players: 1)}
        }
        .font(.system(size: 200))
        .minimumScaleFactor(0.01)
        .lineLimit(1)
        .padding()

    }
}

#Preview {
    ChooserView()
}
