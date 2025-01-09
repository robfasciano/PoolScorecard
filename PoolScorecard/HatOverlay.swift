//
//  HatOverlay.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 12/31/24.
//

import SwiftUI

struct HatOverlay: View {
    var score: [Int]
    var which: Int
    var name: String
    var size: CGFloat = 80
    
    var body: some View {
        Text(score[which] >= (score.max() ?? 0) && score[which] > 0 ? "👑" : PoolScorecardApp.Constants.hats[which])
            .font(.system(size: size * 2/3))
            .border(.red)
            .rotationEffect(Angle(degrees: (which == 5) &&
                                    (score[which] <= (score.max() ?? 0)) ? 50 : 20))
            .minimumScaleFactor(1)
            .overlay(
                Text("\(score[which])")
                    .fontWeight(.black)
                    .scaleEffect(0.6)
                    .shadow(color: .white, radius: 6)
                    .foregroundStyle(score[which] == 0 ? .clear : .black)
            )
        //TODO: add additinal y offset if tophat
                    .offset(x: xOffset(name: name), y: yOffset(name: name))
        
    }
    
    func xOffset(name: String) -> CGFloat {
        let normalOffset:CGFloat = -2
        guard let lastChar = name.last else { return normalOffset }
        if lastChar == "A" { return name.count == 1 ? -17 : 0.8 }
        if lastChar == "L" { return name.count == 1 ? -19 : 0.2 }
        return normalOffset
    }
    
    func yOffset(name: String) -> CGFloat {
        guard let lastChar = name.last else { return 0.0 }
        if lastChar.isUppercase { return -30 }
        if lastChar.isNumber { return -30 }
        return ["d", "f", "l", "t"].contains(String(lastChar)) ? -20 : -8
    }
}

#Preview {
    let Names = ["I", "A really, really, really, really super duper long name", "L", "A", "Player t", "Bubba Joe"]
    let fontSize: CGFloat = 100
    let scores = [1, 1, 6, 3, 4, 5]
//    let scores = [0, 0, 0, 0, 0, 0]

    VStack {
        ForEach(0..<Names.count, id: \.self) { i in
            Text(Names[i])
                .padding(.horizontal, 25)
                .overlay(alignment: .trailing) {HatOverlay(score: scores, which: i, name: Names[i], size: fontSize)}
                .font(Font.custom(PoolScorecardApp.Constants.fontName, size: fontSize))
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        }
        .padding(.horizontal, 400)
    }
}

