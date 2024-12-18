//
//  StripeSolidView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI

struct StripeSolidView: View {
    let players: Int
    
    @State private var Player1 = ""
    @State private var Player2 = ""
    @State private var Player3 = ""
    @State private var Player4 = ""
    
    private let solids = 1..<8
    private let stripes = 9..<16

    var body: some View {
        
        let nameSize: CGFloat = 100
        VStack{
            Spacer()
            showTopNames
            show(solids)
            showBottomNames
            show(stripes)
            Spacer()
            showBottomButtons
        }
        .font(.system(size: nameSize))
        .textFieldStyle(.automatic)
        .multilineTextAlignment(.center)
        .padding(50)
        .background(Color(red: 0.153, green: 0.365, blue: 0.167).gradient)
        .minimumScaleFactor(0.01)

    }
       
    var showTopNames: some View {
        HStack {
            TextField("Player 1", text: $Player1)
            if players == 4 {
                TextField("Player 3", text: $Player3)
            }
        }
    }
    
    var showBottomNames: some View{
        HStack {
            TextField("Player 2", text: $Player2)
            if players == 4 {
                TextField("Player 4", text: $Player4)
            }
        }
    }
        
    func show(_ balls: Range<Int>) -> some View {
        HStack {
            ForEach(balls, id: \.self) { ball in
                PoolBallView(num: ball)
            }
        }
    }
    
    var showBottomButtons: some View {
        HStack {
            swapBalls
            if players == 4 {
                Spacer()
                swapTeams
            }
        }
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
                    .minimumScaleFactor(0.01)
                Text("Swap Names")
                    .font(.system(size: 40))
                    .minimumScaleFactor(0.01)
            }
        }
    }

    var swapTeams: some View {
        Button(action: {
            let playerArray = [Player1, Player2, Player3, Player4].shuffled()
            Player1 = playerArray[0]
            Player2 = playerArray[1]
            Player3 = playerArray[2]
            Player4 = playerArray[3]
        })
        {
            VStack{
                Image(systemName: "person.line.dotted.person.fill")
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.01)
                Text("Change Teams")
                    .font(.system(size: 40))
                    .minimumScaleFactor(0.01)

            }

        }
    }

}

#Preview {
    StripeSolidView(players: 2)
    StripeSolidView(players: 4)
}
