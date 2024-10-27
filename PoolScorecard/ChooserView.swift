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
            NavigationLink("2 Players") {TwoPersonView()}
            NavigationLink("3 Players") {TwoPersonView()}
            NavigationLink("4 Players") {TwoPersonView()}
            NavigationLink("5 Players") {TwoPersonView()}
        }
        .font(.system(size: 200))
    }
}

#Preview {
    ChooserView()
}
