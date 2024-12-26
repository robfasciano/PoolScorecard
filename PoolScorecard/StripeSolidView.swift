//
//  StripeSolidView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI

struct StripeSolidView: View {
    let players: Int
    
//    @State private var Player1 = ""
//    @State private var Player2 = ""
//    @State private var Player3 = ""
//    @State private var Player4 = ""
    @State private var Players = ["", "", "", ""]
    @State private var score = [0, 0, 0, 0]

    
    @State private var ballsVisible = false
    @Environment(\.dismiss) var dismiss
    
    private let solids = 1..<8
    private let stripes = 9..<16

    var body: some View {
        
        let nameSize: CGFloat = 100
        VStack{
            BackButton()
                .onTapGesture(perform: { dismiss() })
            showNames(LeftmostName: 1)
            show(solids)
            showNames(LeftmostName: 2)
            show(stripes)
            Spacer()
            showBottomButtons
        }
        .font(.system(size: nameSize))
        .textFieldStyle(.automatic)
        .multilineTextAlignment(.center)
        .padding(50)
        .background(PoolScorecardApp.Constants.feltColor)
        .minimumScaleFactor(0.01)
        .onAppear {
            ballsVisible = true
        }
    }
       
    func showNames(LeftmostName: Int) -> some View {
        let which = LeftmostName - 1
        return HStack {
            TextField("Player \(which+1)", text: $Players[which])
                .overlay(
                    Text(score[which] >= (score.max() ?? 0) && score[which] > 0 ? "👑" : PoolScorecardApp.Constants.hats[which])
                    .rotationEffect(Angle(degrees: 20))
                    .overlay(
                        Text("\(score[which])").offset(y: 40)
                            .fontWeight(.black)
                            .scaleEffect(0.6)
                            .shadow(color: .white, radius: 5)
                    )
                    .scaleEffect(0.5, anchor: UnitPoint(x: 3, y: -0.2))
                    .onTapGesture(count: 2) {
                        score[which] += 1
                    }
                        .onLongPressGesture {
                            score[which] -= score[which] > 0 ? 1 : 0
                        }
                )
            if players == 4 {
                TextField("Player \(which+3)", text: $Players[which+2])
                    .overlay(
                        Text(score[which+2] >= (score.max() ?? 0) && score[which+2] > 0 ? "👑" : PoolScorecardApp.Constants.hats[which+2])
                        .rotationEffect(Angle(degrees: 20))
                        .overlay(
                            Text("\(score[which+2])").offset(y: 40)
                                .fontWeight(.black)
                                .scaleEffect(0.6)
                                .shadow(color: .white, radius: 5)
                        )
                        .scaleEffect(0.5, anchor: UnitPoint(x: 3, y: -0.2))
                        .onTapGesture(count: 2) {
                            score[which+2] += 1
                        }
                            .onLongPressGesture {
                                score[which+2] -= score[which+2] > 0 ? 1 : 0
                            }
                    )
            }
        }
    }
    
    var showBottomNames: some View{
        HStack {
            TextField("Player 2", text: $Players[1])
            if players == 4 {
                TextField("Player 4", text: $Players[3])
            }
        }
    }
        
    func show(_ balls: Range<Int>) -> some View {
        return HStack {
            ForEach(balls, id: \.self) { ball in
                PoolBallView(num: ball)
                    .rotationEffect(ballsVisible ? Angle(degrees: 0) : Angle(degrees: 720))
                    .spherify()
                    .offset(x: ballsVisible ? 0 : 2000, y: 0)
                    .animation(.easeInOut(duration: ballsVisible ? 1.6 : 0)
                        .delay(TimeInterval(Double(ball)/20)),value: ballsVisible)
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
            var temp = Players[0]
            var tempScore = score[0]
            Players[0] = Players[1]
            score[0] = score[1]
            Players[1] = temp
            score[1] = tempScore
            temp = Players[2]
            tempScore = score[2]
            Players[2] = Players[3]
            score[2] = score[3]
            Players[3] = temp
            score[3] = tempScore
            withAnimation() {
                ballsVisible = false
            } completion: {
                ballsVisible = true
            }
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
            let tempPlayers = Players.shuffled()
            //adjust scores
            //TODO: fix this.  it currently does not work if there are duplicte names (including blanks)
            let tempScoreArray = score
            for i in 0...3 {
                score[i] = tempScoreArray[Players.firstIndex(of: tempPlayers[i])!]
            }
//            print(tempScoreArray)
//            print(score)
            //adjust names
            Players = tempPlayers
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
