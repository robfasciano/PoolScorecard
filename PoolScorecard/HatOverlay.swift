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
        
    var body: some View {
        Text(score[which] >= (score.max() ?? 0) && score[which] > 0 ? "👑" : PoolScorecardApp.Constants.hats[which])
            .rotationEffect(Angle(degrees: which < 5 ? 20 :
                (score[which] >= (score.max() ?? 0) ? 20 : 50)))
            .overlay(
                Text("\(score[which])")
                    .fontWeight(.black)
                    .scaleEffect(0.6)
                    .shadow(color: .white, radius: 6)
                    .foregroundStyle(score[which] == 0 ? .clear : .black)
            )
            .scaleEffect(0.5, anchor: UnitPoint(x: xOffset(name: name), y: yOffset(name: name)))
    }
    
    func xOffset(name: String) -> CGFloat {
        let normalOffset:CGFloat = 1.3
        guard let lastChar = name.last else { return normalOffset }
        if lastChar == "A" { return 0.8 }
        if lastChar == "L" { return 0.5 }
        return normalOffset
    }
    
    func yOffset(name: String) -> CGFloat {
        guard let lastChar = name.last else { return -0.1 }
        if lastChar.isUppercase { return 0.0 }
        return ["d", "f", "l", "t"].contains(String(lastChar)) ? -0.1 : 0.2
    }
}

#Preview {
    let Names = ["short", "A really, reall, really, really super duper long name", "Bobby", "A", "Fasciano", "Bubba Joe"]
    ForEach(0..<Names.count, id: \.self) { i in
        Text(Names[i])
            .overlay(alignment: .topTrailing) {HatOverlay(score: [6, 1, 2, 3, 4, 5], which: i, name: Names[i])}
            .font(Font.custom(PoolScorecardApp.Constants.fontName, size: 80))
            .minimumScaleFactor(0.1)
            .lineLimit(1)
    }
    .padding(.horizontal, 100)
}

