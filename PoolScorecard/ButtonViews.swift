//
//  ButtonView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 12/30/24.
//

import SwiftUI

struct ShuffleTeamsButtonView: View {
    var body: some View {
        simpleButton(image: "person.line.dotted.person.fill", text: "Shuffle")
    }
}

struct SwapBallsButtonView: View {
    var body: some View {
        simpleButton(image: "arrow.trianglehead.swap", text: "Swop")
    }
}

func simpleButton(image: String, text: String) -> some View {
    VStack(spacing: 0) {
        Image(systemName: image)
            .resizable()
            .font(.system(size: 100))
            .aspectRatio(contentMode: .fit)
        Text(text)
            .font(.system(size: 80))
            .minimumScaleFactor(0.1)
    }
    .foregroundStyle(.blue)
}

#Preview {
    HStack {
        SwapBallsButtonView()
        ShuffleTeamsButtonView()
    }
    .frame(maxHeight: 200)
}
