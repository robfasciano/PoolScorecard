//
//  UltraView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 11/1/24.
//

import SwiftUI

struct UltraView: View {
    @ObservedObject var scorecard: ultraViewModel
    @Binding var lightAngle: Double
    @Binding var names: [String]
    
    @State private var scores = [0, 0, 0, 0, 0]

    @State private var showingNameSheet = false
    
    private let ultraLowBalls = [1, 2, 3]
    private let lowBalls = [4, 5, 6]
    private let midBalls = [7, 8, 9]
    private let hiBalls = [10, 11, 12]
    private let ultraHiBalls = [13, 14, 15]
    
    @State private var marked = Array.init(repeating: false, count: 16)
    @State private var showingPopover = Array.init(repeating: false, count: 16)

    @State private var ballsVisible = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        let nameSize: CGFloat = 100
        ZStack{ //right now, if user changes orientation during game, status resets (but not for cutthroat!)
            GeometryReader {geometry in //TODO: handle orientation better
                //this landscape variable only gets updated when first entering the View
                landscape = geometry.size.height > geometry.size.width ? false : true
                return VStack {
                    HStack {
                        BackButton()
                            .onTapGesture(perform: {
                                lightAngle = ChooserView.Constants.lightAngle.initial
                                withAnimation(.easeInOut(duration: ChooserView.Constants.lightAngle.duration)) {
                                    lightAngle = ChooserView.Constants.lightAngle.final
                                }
                                dismiss()
                            })
                        shuffle
                    }
                    .frame(maxHeight: PoolScorecardApp.Constants.buttonHeight)
                    Grid() {
                            ballGroups
                        nameRow(0, height: (geometry.size.height / 3) / (landscape ? 2.2 : 2.7))
                        nameRow(1, height: (geometry.size.height / 3) / (landscape ? 2.2 : 2.7))
                        nameRow(2, height: (geometry.size.height / 3) / (landscape ? 2.2 : 2.7))
                        nameRow(3, height: (geometry.size.height / 3) / (landscape ? 2.2 : 2.7))
                        nameRow(4, height: (geometry.size.height / 3) / (landscape ? 2.2 : 2.7))
                    }
                    Spacer()
                }
                .font(.system(size: nameSize))
                .textFieldStyle(.automatic)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color("Felt"))
                .minimumScaleFactor(0.001)
                .onAppear {
                    ballsVisible = true
                }
            }
        }
    }
    
    var shuffle: some View {
        Button(action: {
            let tempPlayers = names
            let tempScores = scores
            var shuffleOrder: [Int] = []
            for i in 0...5 - 1 {
                shuffleOrder.append(i)
            }
            shuffleOrder = shuffleOrder.shuffled()
            
            for i in 0...5 - 1 {
                names[i] = tempPlayers[shuffleOrder[i]]
                scores[i] = tempScores[shuffleOrder[i]]
            }
            withAnimation() {
                ballsVisible = false
                scorecard.clearStatus()
            } completion: {
                ballsVisible = true
            }
        })
        {
            ShuffleTeamsButtonView()
        }
    }
    
    var ballGroups: some View {
        GridRow {
            Spacer()
            newGame
            OneBallGroup(ultraLowBalls)
            OneBallGroup(lowBalls)
            OneBallGroup(midBalls)
            OneBallGroup(hiBalls)
            OneBallGroup(ultraHiBalls)
            Spacer()
        }
    }
    
    func OneBallGroup(_ balls: [Int]) -> some View {
        GeometryReader {geometry in
            let ballPadding = 5.0
            let iPad = 5.0 //padding between ball (HStack) when 2 in row
            let ballWidth = geometry.size.width - 2*ballPadding
            
            if landscape {
                VStack(spacing: 0) {
                    Spacer()
                    ballRow([balls[0], balls[1]], HSpacing: iPad)
                        .frame(width:  ballWidth + iPad)
                    ballRow([balls[2]])
                        .frame(width:  ballWidth / 2 )
                }
            } else {
                VStack {
                    Spacer()
                    ballRow([balls[0]])
                    ballRow([balls[1]])
                    ballRow([balls[2]])
                }
                .padding(0)
            }
        }
    }

    
    
    func ballRow(_ balls: [Int], HSpacing: CGFloat = 0) -> some View {
        HStack(spacing: HSpacing) {
            Spacer()
            oneBall(ball: balls[0])
            if balls.count == 2 {
                oneBall(ball: balls[1])
            }
            Spacer()
        }
    }
    
    func oneBall(ball: Int) -> some View {
        PoolBallView(num: ball)
        .rotationEffect(ballsVisible ? Angle(degrees: 0) : Angle(degrees: 1440))
        .spherify(mark: marked[ball])
        .offset(x: ballsVisible ? 0 : 1800, y: 0)
        .onTapGesture {
            withAnimation(.spring) {
                marked[ball].toggle()
            }
            if marked[ball] {
                showingPopover[ball] = true
            }
        }
        .animation(.easeInOut(duration: ballsVisible ? 1.9 : 0)
            .delay(TimeInterval(Double(ball)/20)),value: ballsVisible)
        .popover(isPresented: $showingPopover[ball]) {
            popoverView(ball)
        }
    }
    
    func getName(_ which: Int) -> some View {
        Text(names[which] == "" ? "Player \(which+1)" : names[which])
    }
    
    
    func popoverView(_ ball: Int)-> some View {
        VStack(spacing: 20) {
            nameSelectButton(ball: ball, row: 0)
            nameSelectButton(ball: ball, row: 1)
            nameSelectButton(ball: ball, row: 2)
            nameSelectButton(ball: ball, row: 3)
            nameSelectButton(ball: ball, row: 4)
        }
        .font(Font.custom(PoolScorecardApp.Constants.fontName, size: 40))
        .padding()
    }
    
    func processBallSunk(player: Int, level: Int) {
        switch scorecard.standings(player, level) {
        case ultraScorcard.status.checkedByClick:
            return
        case ultraScorcard.status.checkedByCircle:
            scorecard.selectIndicator(player: player, indicator: level)
        case ultraScorcard.status.circled:
            return
        case ultraScorcard.status.unknown:
            scorecard.selectIndicator(player: player, indicator: level)
        }
    }
    
    func nameSelectButton(ball: Int, row: Int) -> some View {
        Button {
            showingPopover[ball] = false
            if ultraLowBalls.contains(ball) {
                processBallSunk(player: row, level: 0)
            } else if lowBalls.contains(ball) {
                processBallSunk(player: row, level: 1)
            } else if midBalls.contains(ball) {
                processBallSunk(player: row, level: 2)
            } else if hiBalls.contains(ball) {
                processBallSunk(player: row, level: 3)
            } else {
                processBallSunk(player: row, level: 4)
            }
        } label: {
            getName(row)
        }
        .buttonStyle(.borderedProminent)
    }

    func allBallsInSetSunk(level: Int) -> Bool {
    var result = true
        for i in (1+3*level)...(3*(level+1)) {
            if !marked[i] {
                result = false
            }
        }
        return result
    }
    
    func isPlayerDonezo(player: Int) -> Bool {
        for level in 0...4 {
            if scorecard.standings(player, level) == ultraScorcard.status.circled {
                return allBallsInSetSunk(level: level)
            }
        }
        return false
    }

    
    let indicators = ["UL", "L", "M", "H", "UH"]
    
    func nameRow(_ which: Int, height: CGFloat) -> some View {
        GridRow {
            Spacer()
            Text(names[which] == "" ? "Player \(which+1)" : names[which])
                .onTapGesture {
                    showingNameSheet.toggle()
                }
                .fullScreenCover(isPresented: $showingNameSheet) {
                    GetNewNames(names: $names, count: 5)
                }
                .foregroundStyle(names[which] == "" ? .gray : PoolScorecardApp.Constants.textColor1)
                .padding(.horizontal)
                .overlay(alignment: .trailing) {
                    HatOverlay(score: scores, which: which, name: names[which])
                        .onTapGesture() {
                            scores[which] += 1
                        }
                        .onLongPressGesture {
                            scores[which] -= scores[which] > 0 ? 1 : 0
                        }
                }
                .frame(maxHeight: height)
                .overlay {
                    if isPlayerDonezo(player: which) {
                        Text("☠️")
                            .aspectRatio(contentMode: .fit)
                            .shadow(color: .red, radius: 5)
                            .onTapGesture { showingNameSheet.toggle() }
                            .transition(.asymmetric(insertion: .scale.animation(.bouncy), removal: .opacity))
                    }
                }
            statButton(which, indicators[0]).frame(maxHeight: height)
            statButton(which, indicators[1]).frame(maxHeight: height)
            statButton(which, indicators[2]).frame(maxHeight: height)
            statButton(which, indicators[3]).frame(maxHeight: height)
            statButton(which, indicators[4]).frame(maxHeight: height)
            Spacer()
        }.minimumScaleFactor(0.001)
    }

        
     func statButton(_ player: Int, _ level: String) -> some View {
        var  notIndicators = indicators
        let i = indicators.firstIndex(of: level)!
        notIndicators.remove(at: i)
        var otherIndicators: [Int] = []
        for i in 0..<indicators.count {
            if indicators[i] != level {
                otherIndicators.append(i)
            }
        }
        
        var otherPlayers = [0, 1, 2, 3, 4]
        otherPlayers.remove(at: player)
        
        return ZStack {
            switch scorecard.standings(player, i) {
            case ultraScorcard.status.checkedByClick:
                Text(level)
                Text(PoolScorecardApp.Constants.XCharacter).opacity(0.9)
            case ultraScorcard.status.checkedByCircle:
                Text(level)
                Text(PoolScorecardApp.Constants.XCharacter).opacity(0.3)
            case ultraScorcard.status.circled:
                circleALevel(level)
            case ultraScorcard.status.unknown:
                Text(level)
            }
        }
        .onTapGesture {
            scorecard.selectIndicator(player: player, indicator: i)
        }
        .onLongPressGesture {
            scorecard.resetIndicator(player: player, indicator: i)
        }
    }
    
        
    func circleALevel(_ level: String) -> some View {
        Text(level)
            .overlay(Circle().stroke(lineWidth: 10).aspectRatio(1, contentMode: .fill))
            .foregroundStyle(.red)
    }
    
    
    var newGame: some View {
        Button(action: {
            scorecard.clearStatus()
            withAnimation {
                ballsVisible = false
            } completion: {
                ballsVisible = true
            }
        })
        {
            NewGameView(ballsVisible: ballsVisible)
        }
    }
    
    struct Constants {
        static let ballPadding = 5.0
        static let iPad = 5.0 //padding between ball (HStack) when 2 in row
    }

}


#Preview {
    UltraView(scorecard: ultraViewModel(), lightAngle: .constant(90),
              names: .constant(["","","","","",""]))
}
