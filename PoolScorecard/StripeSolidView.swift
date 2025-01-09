//
//  StripeSolidView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI

struct StripeSolidView: View {
    let numPlayers: Int
    @Binding var lightAngle: Double
    @Binding var names: [String]
    
//    @Binding private var names = ["", "", "", "", "", ""]
    @State private var score = [0, 0, 0, 0, 0, 0]
    
    @State private var marked: [Bool] = Array.init(repeating: false, count: 16)

    @State private var showingNameSheet = false

    @State private var ballsVisible = false
    @Environment(\.dismiss) var dismiss
    
    private let solids = 1..<8
    private let stripes = 9..<16

    var body: some View {
        VStack {
            HStack {
                BackButton()
                    .onTapGesture(perform: {
                        lightAngle = ChooserView.Constants.lightAngle.initial
                        withAnimation(.easeInOut(duration: ChooserView.Constants.lightAngle.duration)) {
                            lightAngle = ChooserView.Constants.lightAngle.final
                        }
                        dismiss()
                    })
            showOtherButtons
            }
            .frame(maxHeight: PoolScorecardApp.Constants.buttonHeight)
            VStack(spacing: 0) {
                showNames(LeftmostName: 1)
                show(solids)
            }
            Spacer()
            VStack(spacing: 0) {
                showNames(LeftmostName: 2)
                show(stripes)
            }
        }
        .font(Font.custom(PoolScorecardApp.Constants.fontName, size: Constants.nameSize))
        .textFieldStyle(.automatic)
        .multilineTextAlignment(.center)
        .padding(50)
        .background(Color("Felt"))
        .minimumScaleFactor(0.01)
        .onAppear {
            ballsVisible = true
        }
    }
       
    func showNames(LeftmostName: Int) -> some View {
        return HStack(spacing: 50) {
            nameView(which: LeftmostName - 1)
            if numPlayers >= 4 {
                nameView(which: LeftmostName + 1)
            }
            if numPlayers >= 6 {
                nameView(which: LeftmostName + 3)
            }

        }
    }
    
    func nameView(which: Int) -> some View {
        Text(names[which] == "" ? "Player \(which+1)" : names[which])
            .onTapGesture {
                showingNameSheet.toggle()
            }
            .fullScreenCover(isPresented: $showingNameSheet) {
                GetNewNames(names: $names, count: numPlayers)
           }
            .foregroundStyle(names[which] == "" ? .gray : PoolScorecardApp.Constants.textColor1)
            .padding(.horizontal, 25)
            .overlay(alignment: .trailing) {
                HatOverlay(score: score, which: which, name: names[which],size: Constants.nameSize)
                    .onTapGesture() {
                        addToRow(player: which, amount: 1)
                    }
                    .onLongPressGesture {
                        score[which] -= score[which] > 0 ? 1 : 0
                    }
            }
    }
        
    func addToRow(player: Int, amount: Int) {
        switch player {
        case 0, 2, 4:
            score[0] += amount
            score[2] += amount
            score[4] += amount
        default:
            score[1] += amount
            score[3] += amount
            score[5] += amount
        }
    }
            
    func show(_ balls: Range<Int>) -> some View {
        return HStack {
            ForEach(balls, id: \.self) { ball in
                PoolBallView(num: ball)
                    .rotationEffect(ballsVisible ? Angle(degrees: 0) : Angle(degrees: 720))
//                    .spherify(mark: marked[ball])
                    .spherify(mark: marked[ball])
                    .onTapGesture {
                        marked[ball].toggle()
                    }
                    .offset(x: ballsVisible ? 0 : 2000, y: 0)
                    .animation(.easeInOut(duration: ballsVisible ? 1.6 : 0)
                        .delay(TimeInterval(Double(ball)/20)),value: ballsVisible)
            }
        }
    }
    
    var showOtherButtons: some View {
        HStack {
            swapBalls
            if numPlayers > 2 {
                Spacer()
                swapTeams
            }
        }
    }
    
    var swapBalls: some View {
        Button(action: {
            marked = Array.init(repeating: false, count: 16)

            swapTwoPlayers(first: 0)
            swapTwoPlayers(first: 2)
            swapTwoPlayers(first: 4)
            withAnimation() {
                ballsVisible = false
            } completion: {
                ballsVisible = true
            }
        })
        {
            SwapBallsButtonView()
        }
    }

    func swapTwoPlayers(first: Int) {
        let temp = names[first]
        let tempScore = score[first]
        names[first] = names[first+1]
        score[first] = score[first+1]
        names[first+1] = temp
        score[first+1] = tempScore
    }
    
    
    var swapTeams: some View {
        Button(action: {
            marked = Array.init(repeating: false, count: 16)
            
            let tempPlayers = names
            let tempScores = score
            var shuffleOrder: [Int] = []
            for i in 0...numPlayers - 1 {
                shuffleOrder.append(i)
            }
            shuffleOrder = shuffleOrder.shuffled()
            
            for i in 0...numPlayers - 1 {
                names[i] = tempPlayers[shuffleOrder[i]]
                score[i] = tempScores[shuffleOrder[i]]
            }
            withAnimation() {
                ballsVisible = false
            } completion: {
                ballsVisible = true
            }
        })
        {
            ShuffleTeamsButtonView()
        }
    }

    private struct Constants {
        static let nameSize: CGFloat = 100
    }
    
}

#Preview {
//    StripeSolidView(players: 2)
    StripeSolidView(numPlayers: 6, lightAngle: .constant(90), names: .constant(["A", "B", "C", "D", "E", "F"]))
}
