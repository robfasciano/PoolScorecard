//
//  PoolBallView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/30/24.
//

import SwiftUI

struct PoolBallView: View {
    let num: Int
    
    static let halfBallColors = [.yellow, .blue, .red, .purple, .orange, .green, Color(red: 0.5, green: 0.050, blue: 0.150)]
    static let ballColors = halfBallColors + [.black] + halfBallColors
    
    var body: some View {
        Rectangle()
            .fill(num<9 ? PoolBallView.ballColors[num-1] : .white)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Rectangle()
                    .fill(PoolBallView.ballColors[num-1])
                    .aspectRatio(2, contentMode: .fit)
                
                    .overlay {
                        Circle()
                            .fill(.white)
                            .aspectRatio(0.75, contentMode: .fit)
                            .overlay {
                                Text(String(num))
                                    .font(.system(size: 40))
                                    .minimumScaleFactor(0.001)
                                    .foregroundStyle(.black)
                                    .aspectRatio(num<10 ? 0.45 : 0.7, contentMode: .fit)
                            }
                    }
            }
            .clipShape(Circle())
            .shadow(color: .black, radius: 5)
            .rotationEffect(Angle(degrees: Double.random(in: -35...35))) //this may not quite work as coded
    }
}


#Preview {
    HStack(spacing: 0) {
        PoolBallView(num: 1)
        PoolBallView(num: 2)
        PoolBallView(num: 3)
        PoolBallView(num: 4)
        PoolBallView(num: 5)
    }
    HStack(spacing: 5) {
        PoolBallView(num: 6)
        PoolBallView(num: 7)
        PoolBallView(num: 8)
        PoolBallView(num: 9)
        PoolBallView(num: 10)
    }
    HStack {
        PoolBallView(num: 11)
        PoolBallView(num: 12)
        PoolBallView(num: 13)
        PoolBallView(num: 14)
        PoolBallView(num: 15)

    }

}
