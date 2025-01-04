//
//  PoolBallView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/30/24.
//

import SwiftUI

struct PoolBallView: View {
    let num: Int
    let mark: Bool
    
    init(num: Int, mark: Bool) {
        self.num = num
        self.mark = mark
    }

    init(num: Int) {
        self.num = num
        self.mark = false
    }

    static let halfBallColors = [
        Color(red: 1.00, green: 0.601, blue: 0.013), //yellow
        Color(red: 0.043, green: 0.181, blue: 0.564), //blue
        Color(red: 1.00, green: 0.000, blue: 0.065), //red
        Color(red: 0.365, green: 0.064, blue: 0.337), //purple
        Color(red: 1.000, green: 0.300, blue: 0.150), //orange
        Color(red: 0.100, green: 0.348, blue: 0.051), //green
        Color(red: 0.500, green: 0.050, blue: 0.150)] //magenta
    static let ballColors = [Constants.ballWhite] + halfBallColors + [.black] + halfBallColors
    
    var body: some View {
        Rectangle()
            .fill(Constants.ballWhite)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                    Rectangle()
                        .fill(num<9 ? PoolBallView.ballColors[num] : .clear)
                        .aspectRatio(1, contentMode: .fit)

                .overlay {
                    Rectangle()
                        .fill(num<9 ? .clear : PoolBallView.ballColors[num])
                        .aspectRatio(2, contentMode: .fit)
                    
                        .overlay {
                            Circle()
                                .fill(num == 0 ? .clear : Constants.ballWhite)
                                .aspectRatio(0.75, contentMode: .fit)
                                .overlay {
                                    Text(num > 0 ? String(num) : "")
                                        .font(.system(size: Constants.maxTextSize))
                                        .fontWeight(.bold)
                                        .minimumScaleFactor(Constants.textScale)
                                        .foregroundStyle(.black)
                                        .aspectRatio(num<10 ? 0.45 : 0.7, contentMode: .fit)
                                }
                        }
                }
            }
            .rotationEffect(Angle(degrees: Double.random(in: -35...35)))
            .opacity(mark ? 0.3 : 1)
    }
    
    struct Constants {
        static let maxTextSize: CGFloat = 75
        static let minTextSize: CGFloat = 5
        static let textScale: CGFloat = minTextSize / maxTextSize
        static let ballWhite = Color(red: 1.00, green: 0.920, blue: 0.790)
    }
    
}


#Preview {
    HStack(spacing: 3) {
        PoolBallView(num: 0, mark: true)
            .spherify()
        PoolBallView(num: 2, mark: true)
            .spherify()
        PoolBallView(num: 3)
            .spherify()
        PoolBallView(num: 4)
            .spherify()
        PoolBallView(num: 5)
            .spherify()
    }
    HStack(spacing: 3) {
        PoolBallView(num: 6, mark: true)
            .spherify()
        PoolBallView(num: 7, mark: true)
            .spherify()
        PoolBallView(num: 8)
            .spherify()
        PoolBallView(num: 9)
            .spherify()
        PoolBallView(num: 10)
            .spherify()
    }
    HStack(spacing: 3) {
        PoolBallView(num: 11, mark: true)
            .spherify()
        PoolBallView(num: 12, mark: true)
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
