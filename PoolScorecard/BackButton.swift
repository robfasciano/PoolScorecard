//
//  BackButton.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 12/26/24.
//

import SwiftUI

struct BackButton: View {
    
    var body: some View {
        HStack {
            Text("⬅️Back")
                .font(.title)
                .foregroundStyle(PoolScorecardApp.Constants.textColor1)
                .fontWeight(.black)
            Spacer()
        }
    }
}

#Preview {
    BackButton()
}
