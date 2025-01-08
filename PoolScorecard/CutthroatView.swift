//
//  CutthroatView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 11/1/24.
//

import SwiftUI

var landscape: Bool = true

struct CutthroatView: View {
    let numPlayers: Int
    @Binding var lightAngle: Double
    @Binding var names: [String]

    @State private var showingNameSheet = false
    @State private var showingPopover = Array.init(repeating: false, count: 16)
    
    @State private var score = Array.init(repeating: 0, count: 6)
    @State private var results = [
        Array.init(repeating: false, count: 3), //L M H for p1
        Array.init(repeating: false, count: 3), //L M H for p2
        Array.init(repeating: false, count: 3)  //L M H for p3
    ]
    
    @State private var marked = Array.init(repeating: false, count: 16)
    
    @State var ballsVisible = false
    @Environment(\.dismiss) var dismiss
    
    
    private let lowBalls = [1, 2, 3, 4, 5]
    private let midBalls = [6, 7 ,8, 9, 10]
    private let hiBalls = [11, 12, 13, 14, 15]
    private let teamColor: [Color] = [.red, .white, .blue]
    
    
    var body: some View {
        ZStack{
            GeometryReader {geometry in //TODO: this landscape variable only gets updated when first entering the View
                landscape = true
                if geometry.size.height > geometry.size.width {
                    landscape = false
                }
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
                        swapTeams
                    }
                    .frame(maxHeight: PoolScorecardApp.Constants.buttonHeight)
                    Grid() {
                        ballGroups
                        nameRow(0, height: (geometry.size.height / 3) / (landscape ? 1 / Constants.Names.screenRatio.landscape : 1 / Constants.Names.screenRatio.portrait))
                        nameRow(1, height: (geometry.size.height / 3) / (landscape ? 1 / Constants.Names.screenRatio.landscape : 1 / Constants.Names.screenRatio.portrait))
                        nameRow(2, height: (geometry.size.height / 3) / (landscape ? 1 / Constants.Names.screenRatio.landscape : 1 / Constants.Names.screenRatio.portrait))
                    }
                    Spacer()
                }
                .font(Font.custom(PoolScorecardApp.Constants.fontName, size: Constants.Names.maxFont))
                .textFieldStyle(.automatic)
                .padding()
                .background(Color("Felt"))
                .minimumScaleFactor(0.001)
                .onAppear {
                    ballsVisible = true
                }
            }
        }
    }
    
    var ballGroups: some View {
        GridRow {
            Spacer()
            newGame
            OneBallGroup(lowBalls)
            OneBallGroup(midBalls)
            OneBallGroup(hiBalls)
            Spacer()
        }
    }
    
    var swapTeams: some View {
        Button(action: {
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
            startNewGame()
        })
        { ShuffleTeamsButtonView() }
    }
    
    
    func OneBallGroup(_ balls: [Int]) -> some View {
        GeometryReader {geometry in
            let ballWidth = max(0, geometry.size.width - 2*Constants.ballPadding)
            if landscape {
                VStack(spacing: 0) {
                    Spacer()
                    ballRow([balls[0], balls[1]], HSpacing: Constants.iPad)
                        .frame(width:  ballWidth + Constants.iPad)
                    ballRow([balls[2]])
                        .frame(width:  ballWidth / 2 )
                    ballRow([balls[3], balls[4]], HSpacing: Constants.iPad)
                        .frame(width:  ballWidth + Constants.iPad)
                }
            } else {
                VStack {
                    Spacer()
                    //need id since [Int] dos not conform to identifiable
                    ForEach(balls, id: \.self) { ball in
                        ballRow([ball])
                    }
                }
            }
        }
        .padding(0)
    }
    
    func ballRow(_ balls: [Int], HSpacing: CGFloat = 0) -> some View {
        HStack(spacing: HSpacing) {
            Spacer()
            oneBall(balls[0])
            if balls.count == 2 {
                oneBall(balls[1])
            }
            Spacer()
        }
    }
    
    
    func oneBall(_ ball: Int) -> some View {
        PoolBallView(num: ball)
            .rotationEffect(ballsVisible ? Angle(degrees: 0) : Angle(degrees: 1440))
            .spherify(mark: marked[ball])
            .offset(x: ballsVisible ? 0 : 1000, y: 0)
            .onTapGesture {
                withAnimation(.spring) {
                    marked[ball].toggle()
                }
                if marked[ball] {
                    showingPopover[ball] = true
                }
            }
            .animation(.easeInOut(duration: ballsVisible ? 1.8 : 0)
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
        }
        .font(Font.custom(PoolScorecardApp.Constants.fontName, size: 40))
        .padding()
    }
    
    func processBallSunk(player: Int, level: Int, allowToggle: Bool = false) {
        
        if shouldBeCircled(player: player, level: level) {
            return
        }
        
        if allowToggle {
            results[player][level].toggle()
        } else {
            results[player][level] = true
        }
        if setCompleted(player, level) {
            findCircles()
        }
    }
    
    func nameSelectButton(ball: Int, row: Int) -> some View {
        Button {
            showingPopover[ball] = false
            if lowBalls.contains(ball) {
                processBallSunk(player: row, level: 0)
            } else if midBalls.contains(ball) {
                processBallSunk(player: row, level: 1)
            } else {
                processBallSunk(player: row, level: 2)
            }
        } label: {
            VStack(spacing: 0) {
                getName(numPlayers < 6 ? row : row * 2)
                if numPlayers >= 6 {
                    getName(row * 2 + 1)
                }
            }
        }
        .buttonStyle(.borderedProminent)
    }
    
    func allBallsInSetSunk(level: Int) -> Bool {
    var result = true
        for i in (1+5*level)...(5*(level+1)) {
            if !marked[i] {
                result = false
            }
        }
        return result
    }
    
    func isPlayerDonezo(player: Int) -> Bool {
        for level in 0...2 {
            if shouldBeCircled(player: player, level: level) {
                return allBallsInSetSunk(level: level)
            }
        }
        return false
    }
    
    func nameRow(_ which: Int, height: CGFloat) -> some View {
        GridRow {
            Spacer()
            let first = which * 2
            VStack(spacing: 0) {
                nameView(which: numPlayers >= 6 ? first : which, height: height)
                if numPlayers >= 6 {
                    nameView(which: first + 1, height: height)
                }
            }
            .overlay {
                if isPlayerDonezo(player: which) {
                    Text("☠️")
                        .aspectRatio(contentMode: .fit)
                        .shadow(color: .red, radius: 5)
                        .onTapGesture { showingNameSheet.toggle() }
                        .transition(.asymmetric(insertion: .scale.animation(.bouncy), removal: .opacity))
                }
            }
            .fullScreenCover(isPresented: $showingNameSheet) {
                GetNewNames(names: $names, count: numPlayers)
            }
            statButton(which, "L").frame(maxHeight: height)
            statButton(which, "M").frame(maxHeight: height)
            statButton(which, "H").frame(maxHeight: height)
            Spacer()
        }.minimumScaleFactor(0.01)
    }
    
    func nameView(which: Int, height: CGFloat) -> some View {
        var adjustedHeight = height
        if numPlayers >= 6 {
            adjustedHeight = height/2
        }
        return getName(which)
            .shadow(color: teamColor[which / 2], radius: numPlayers >= 6 ? 15 : 0)
            .fontWeight(.bold)
            .minimumScaleFactor(0.01)
            .foregroundStyle(names[which] == "" ? .gray : PoolScorecardApp.Constants.textColor1)
            .padding(.horizontal)
            .overlay(alignment: .trailing) {
                HatOverlay(score: score, which: which, name: names[which])
                    .onTapGesture() {
                        addToRow(player: which, amount: 1)
                    }
                    .onLongPressGesture {
                        score[which] -= score[which] > 0 ? 1 : 0
                    }
            }
            .frame(maxHeight: adjustedHeight)
            .onTapGesture {
                showingNameSheet.toggle()
            }
    }
    
    
    func addToRow(player: Int, amount: Int) {
        if numPlayers >= 6 {
            switch player {
            case 0, 1:
                score[0] += amount
                score[1] += amount
            case 2, 3:
                score[2] += amount
                score[3] += amount
            default:
                score[4] += amount
                score[5] += amount
            }
        } else {
            score[player] += amount
        }
    }
    
    
    func shouldBeCircled(player: Int, level: Int) -> Bool {
        var otherIndicators = [0, 1, 2]
        otherIndicators.remove(at: level)
        
        var otherPlayers = [0, 1, 2]
        otherPlayers.remove(at: player)
        
        if results[otherPlayers[0]][level] && results[otherPlayers[1]][level] {
            return true
        }
        if results[player][otherIndicators[0]] &&
            results[player][otherIndicators[1]] {
            return true
        }
        return false
    }
    
    
    func statButton(_ player: Int, _ level: String) -> some View {
        let indicators = ["L", "M", "H"]
        //TODO: prefer to not force unwrap this
        let i = indicators.firstIndex(of: level)!
        
        return ZStack {
            if results[player][i] {
                Text(level).fontWeight(.medium)
                Text(PoolScorecardApp.Constants.XCharacter).opacity(0.7)
                    .transition(.asymmetric(insertion: .scale.animation(.bouncy), removal: .identity))
            } else {
                if shouldBeCircled(player: player, level: i) {
                    circleALevel(level)
                } else {
                    Text(level).fontWeight(.medium)
                }
            }
        }
        .font(Font.custom(PoolScorecardApp.Constants.fontName, size: Constants.levelText.maxFont))
        .fontWeight(.bold)
        .minimumScaleFactor(Constants.levelText.minFontScale)
        .foregroundStyle(PoolScorecardApp.Constants.textColor1)
        .onTapGesture {
            processBallSunk(player: player, level: i, allowToggle: true)
        }
    }
    
    
    func setCompleted(_ player: Int, _ indicator: Int) -> Bool {
        var markCount = 0
        for p in 0..<results.count {
            if results[p][indicator] {
                markCount += 1
            }
        }
        if markCount == 2 {
            return true
        }
        markCount = 0
        for i in 0..<results[0].count {
            if results[player][i] {
                markCount += 1
            }
        }
        if markCount == 2 {
            return true
        }
        return false
    }
    
    func findCircles() {
        for p in 0..<results.count {
            for i in 0..<results[0].count {
                if isCircled(p, i) {
                    markOtherLevels(p, i)
                }
            }
        }
    }
    
    func isCircled(_ player: Int, _ indicator: Int) -> Bool {
        var markCount = 0
        for p in 0..<results.count {
            if p != player && results[p][indicator] {
                markCount += 1
            }
        }
        if markCount == 2 {
            return true
        }
        markCount = 0
        for i in 0..<results[0].count {
            if i != indicator && results[player][i] {
                markCount += 1
            }
        }
        if markCount == 2 {
            return true
        }
        return false
    }
    
    func markOtherLevels(_ player: Int, _ indicator: Int) {
        for p in 0..<results.count {
            if p != player {
                results[p][indicator] = true
            }
        }
        for i in 0..<results[0].count {
            if i != indicator {
                results[player][i] = true
            }
        }
    }
    
    
    func circleALevel(_ level: String) -> some View {
        Text(level)
            .overlay(Circle().stroke(lineWidth: 7).aspectRatio(1, contentMode: .fill))
            .foregroundStyle(.red)
            .fontWeight(.heavy)
            .transition(.asymmetric(insertion: .scale(scale: 3).animation(.bouncy), removal: .identity))
    }
    
    func startNewGame() {
        for i in 0..<results.count {
            for j in 0..<results[0].count {
                results[i][j] = false
            }
        }
        marked = Array.init(repeating: false, count: 16)
        withAnimation {
            ballsVisible = false
        } completion: {
            ballsVisible = true
        }
    }
    
    var newGame: some View {
        Button(action: { startNewGame() })
        { NewGameView(ballsVisible: ballsVisible) }
    }
    
    //MARK: Constant Definitions
    private struct Constants {
        static let ballPadding = 5.0
        static let iPad = 5.0 //padding between ball (HStack) when 2 in row
        struct Names {
            static let maxFont: CGFloat = 120
            struct screenRatio {
                static let landscape: CGFloat = 1 / 1.8
                static let portrait: CGFloat = 1 / 2.0
            }
        }
        struct levelText {
            static let maxFont: CGFloat = 200
            static let minFont: CGFloat = 15
            static let minFontScale: CGFloat = minFont / maxFont
        }
    }
}


#Preview {
    CutthroatView(numPlayers: 3,
                  lightAngle: .constant(90),
                  names: .constant(["","","","","",""]))
}
