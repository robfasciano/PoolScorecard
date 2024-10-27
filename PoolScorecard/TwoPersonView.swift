//
//  TwoPersonView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI

struct TwoPersonView: View {
    private struct ball: Identifiable {
        let color: Color
        let number: Int
        var id: String { "\(number)" }
    }

    static let ballColors: [Color] = [.yellow, .blue, .red, .purple, .orange, .green, Color(red: 1.0, green: 0.2, blue: 0.2)]
    
    //must be a better way
    private let solids: [ball] = [
        ball(color: ballColors[0], number: 1),
        ball(color: ballColors[1], number: 2),
        ball(color: ballColors[2], number: 3),
        ball(color: ballColors[3], number: 4),
        ball(color: ballColors[4], number: 5),
        ball(color: ballColors[5], number: 6),
        ball(color: ballColors[6], number: 7)
    ]
    private let stripes: [ball] = [
        ball(color: ballColors[0], number: 9),
        ball(color: ballColors[1], number: 10),
        ball(color: ballColors[2], number: 11),
        ball(color: ballColors[3], number: 12),
        ball(color: ballColors[4], number: 13),
        ball(color: ballColors[5], number: 14),
        ball(color: ballColors[6], number: 15)
    ]


    var body: some View {
        
        let ballSize: CGFloat = 100
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .font(.largeTitle)

            HStack{
                ForEach(solids) { ball in
                    Image(systemName: "\(ball.number).circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, ball.color)
                        .font(.system(size: ballSize))
                }
            }
            HStack {
                ForEach(stripes) { ball in
                    Image(systemName: "\(ball.number).circle")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, ball.color)
                        .font(.system(size: ballSize))
                }
            }
        }
    }
    
}

#Preview {
    TwoPersonView()
}
