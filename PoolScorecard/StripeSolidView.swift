//
//  StripeSolidView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI

struct StripeSolidView: View {
    let players: Int
    
    @State private var Player1 = "Player 1"
    @State private var Player2 = "Player 2"
    @State private var Player3 = "Player 3"
    @State private var Player4 = "Player 4"

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
            Spacer()
            HStack {
                TextField("Top Left Name", text: $Player1)
                if players == 4 {
                    TextField("Top Right Name", text: $Player3)
                }
            }
            .font(.system(size: ballSize))
            HStack{
                ForEach(solids) { ball in
                    Image(systemName: "\(ball.number).circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, ball.color)
                        .font(.system(size: ballSize))
                }
            }
            HStack {
                TextField("Bottom Left Name", text: $Player2)
                if players == 4 {
                    TextField("Bottom Right Name", text: $Player4)
                }
            }
            .font(.system(size: ballSize))

            HStack {
                ForEach(stripes) { ball in
                    Image(systemName: "\(ball.number).circle")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, ball.color)
                        .font(.system(size: ballSize))
                }
            }
            Spacer()
            HStack {
                swapBalls
                if players == 4 {
                    Spacer()
                    swapTeams
                }
            }
        }
        .textFieldStyle(.roundedBorder)
        .multilineTextAlignment(.center)
        .padding()
    }
    
    
    var swapBalls: some View {
        Button(action: {
            var temp = Player1
            Player1 = Player2
            Player2 = temp
            temp = Player3
            Player3 = Player4
            Player4 = temp
        })
        {
            VStack{
                Image(systemName: "arrow.trianglehead.swap")
                    .font(.system(size: 100))
                Text("Swap Names")
                    .font(.system(size: 40))
            }
        }
    }

    var swapTeams: some View {
        Button(action: {
            let playerArray = [Player1, Player2, Player3, Player4].shuffled()
            print(playerArray)
            Player1 = playerArray[0]
            Player2 = playerArray[1]
            Player3 = playerArray[2]
            Player4 = playerArray[3]
        })
        {
            VStack{
                Image(systemName: "person.line.dotted.person.fill")
                    .font(.system(size: 100))
                Text("Change Teams")
                    .font(.system(size: 40))
            }
        }
    }

}

#Preview {
    StripeSolidView(players: 4)
}
