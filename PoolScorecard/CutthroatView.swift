//
//  CutthroatView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 11/1/24.
//

import SwiftUI

struct CutthroatView: View {
    let feltColor = Color(red: 0.153, green: 0.365, blue: 0.167).gradient
    
    @State private var names = ["", "", ""]
    @State private var results = [
        [false, false, false], //L M H for p1
        [false, false, false], //L M H for p2
        [false, false, false]  //L M H for p3
    ]
    
    private let lowBalls = [1, 2, 3, 4, 5]
    private let midBalls = [6, 7 ,8, 9, 10]
    private let hiBalls = [11, 12, 13, 14, 15]
    
    
    var body: some View {
        let nameSize: CGFloat = 100
        VStack {
            Spacer()
            Grid() {
                ballGroups
                nameRow(0)
                nameRow(1)
                nameRow(2)
            }
            Spacer()
        }
        .font(.system(size: nameSize))
        .textFieldStyle(.automatic)
        .multilineTextAlignment(.center)
//        .padding(50)
        .padding()
        .background(feltColor)
        .minimumScaleFactor(0.01)
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
    
    func OneBallGroup(_ balls: [Int]) -> some View {
        return VStack {
            ballRow([balls[0], balls[1]])
            ballRow([balls[2]])
            ballRow([balls[3], balls[4]])
        }
        .padding()
    }
    
    func ballRow(_ balls: [Int]) -> some View {
        let ballSize = 80.0 //should calculate based on geometery
        return HStack {
            PoolBallView(num: balls[0])
                .frame(idealWidth: ballSize, idealHeight: ballSize)
            if balls.count == 2 {
                PoolBallView(num: balls[1])
                    .frame(idealWidth: ballSize, idealHeight: ballSize)
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
    
    
     func nameRow(_ which: Int) -> some View {
        GridRow {
            Spacer()
            TextField("Player \(which+1)", text: $names[which])
            statButton(which, "L")
            statButton(which, "M")
            statButton(which, "H")
            Spacer()
        }
        
    }
    
    
     func statButton(_ player: Int, _ level: String) -> some View {
        let indicators = ["L", "M", "H"]
        var  notIndicators = indicators
        let i = indicators.firstIndex(of: level)!
        notIndicators.remove(at: i)
        var otherIndicators: [Int] = []
        for i in 0..<indicators.count {
            if indicators[i] != level {
                otherIndicators.append(i)
            }
        }
        
        var otherPlayers = [0, 1, 2]
        otherPlayers.remove(at: player)
        
        return ZStack {
            if results[player][i] {
                Text(level)
                Text("❌").foregroundStyle(.red)
            } else {
                if results[otherPlayers[0]][i] && results[otherPlayers[1]][i] {
                    circleALevel(level)
                } else if results[player][otherIndicators[0]] &&
                            results[player][otherIndicators[1]] {
                    circleALevel(level)
                } else {
                    Text(level)
                }
            }
        }

        .onTapGesture {
            if results[otherPlayers[0]][i] && results[otherPlayers[1]][i] {
                return
            }
            if results[player][otherIndicators[0]] &&
                results[player][otherIndicators[1]] {
                return
            }
            results[player][i].toggle()
            if setCompleted(player, i) {
                findCircles()
            }

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
    }
    
    func MButton(_ which: Int) -> some View {
        ZStack {
            Text("M")
            if results[which][1] {
                Text("X").foregroundStyle(.red)
            }
        }
        .onTapGesture {
            results[which][1].toggle()
        }
    }
    
    func HButton(_ which: Int) -> some View {
        ZStack {
            Text("H")
            if results[which][2] {
                Text("X").foregroundStyle(.red)
            }
        }
        .onTapGesture {
            results[which][2].toggle()
        }
    }
    
    
    
    var newGame: some View {
        Button(action: {
            results = [
                [false, false, false], //L M H for p1
                [false, false, false], //L M H for p2
                [false, false, false]  //L M H for p3
            ]
        })
        {
            VStack{
                Image(systemName: "arrow.trianglehead.counterclockwise.rotate.90")
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.01)
                Text("New Game")
                    .font(.system(size: 40))
                    .minimumScaleFactor(0.01)
            }
        }
    }
    
    
}


#Preview {
    CutthroatView()
}