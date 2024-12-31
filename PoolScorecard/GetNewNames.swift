//
//  GetNewnames.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 12/30/24.
//

import SwiftUI

struct GetNewNames: View {
    @Binding var names: [String]
    var count: Int
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(PoolScorecardApp.Constants.feltColor)
                .ignoresSafeArea()
            
            VStack {
                BackButton()
                    .onTapGesture(perform: { dismiss() })
                Text("Edit Player Names")
                    .fontWeight(.black)
                Spacer()
                ForEach(0..<6) { i in
                    TextField("Player \(i+1)", text: $names[i])
                        .background(i < count ? PoolScorecardApp.Constants.feltColor : .gray)
                }
                Spacer()
            }
            .font(Font.custom(PoolScorecardApp.Constants.fontName, size: 80))
            .foregroundStyle(PoolScorecardApp.Constants.textColor1)
            .textFieldStyle(.automatic)
            .multilineTextAlignment(.center)
            .autocorrectionDisabled()
            .padding()
            .minimumScaleFactor(0.1)
        }
    }
}

#Preview {
        GetNewNames(names: .constant(["Test Name That is Really, Really, Really, Really Long", "Player2", "X", "Test", "Player5", "Bubba"]), count: 6)
}
