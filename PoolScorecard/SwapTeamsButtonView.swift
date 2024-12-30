//
//  SwapTeamsButtonView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 12/30/24.
//

import SwiftUI

struct SwapTeamsButtonView: View {
    
    var body: some View {
        VStack{
            Image(systemName: "person.line.dotted.person.fill")
                .font(.system(size: 100))
                .minimumScaleFactor(0.01)
            Text("Change Teams")
                .font(.system(size: 40))
                .minimumScaleFactor(0.01)
        }
        .foregroundStyle(.blue)
    }
}

#Preview {
    SwapTeamsButtonView()
}
