//
//  PoolBallView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/30/24.
//

import SwiftUI

struct PoolBallView: View {
    let num: Int
    
    static let halfBallColors = [
        Color(red: 1.00, green: 0.601, blue: 0.013), //yellow
        Color(red: 0.043, green: 0.181, blue: 0.564), //blue
        Color(red: 1.00, green: 0.000, blue: 0.065), //red
        Color(red: 0.365, green: 0.064, blue: 0.337), //purple
        Color(red: 1.000, green: 0.300, blue: 0.150), //orange
        Color(red: 0.100, green: 0.348, blue: 0.051), //green
        Color(red: 0.500, green: 0.050, blue: 0.150)] //magenta
    static let ballColors = [.white] + halfBallColors + [.black] + halfBallColors
    
    var body: some View {
        Rectangle()
            .fill(num<9 ? PoolBallView.ballColors[num] : .white)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Rectangle()
                    .fill(PoolBallView.ballColors[num])
                    .aspectRatio(2, contentMode: .fit)
                
                    .overlay {
                        Circle()
                            .fill(.white)
                            .aspectRatio(0.75, contentMode: .fit)
                            .overlay {
                                Text(num > 0 ? String(num) : "")
                                    .font(.system(size: 200))
                                    .fontWeight(.bold)
                                    .minimumScaleFactor(0.001)
                                    .foregroundStyle(.black)
                                    .aspectRatio(num<10 ? 0.45 : 0.7, contentMode: .fit)
                            }
                    }
            }
            .rotationEffect(Angle(degrees: Double.random(in: -35...35)))
    }
    
}


#Preview {
    HStack(spacing: 3) {
        PoolBallView(num: 0)
            .spherify()
        PoolBallView(num: 2)
            .spherify()
        PoolBallView(num: 3)
            .spherify()
        PoolBallView(num: 4)
            .spherify()
        PoolBallView(num: 5)
            .spherify()
    }
    HStack(spacing: 3) {
        PoolBallView(num: 6)
            .spherify()
        PoolBallView(num: 7)
            .spherify()
        PoolBallView(num: 8)
            .spherify()
        PoolBallView(num: 9)
            .spherify()
        PoolBallView(num: 10)
            .spherify()
    }
    HStack(spacing: 3) {
        PoolBallView(num: 11)
            .spherify()
        PoolBallView(num: 12)
            .spherify()
        PoolBallView(num: 13)
            .spherify()
        PoolBallView(num: 14)
            .spherify()
        PoolBallView(num: 15)
            .spherify()
    }
//    PoolBallView(num: 8)
//        .spherify()

}
