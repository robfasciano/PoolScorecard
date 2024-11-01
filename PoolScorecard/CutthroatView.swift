//
//  CutthroatView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 11/1/24.
//

import SwiftUI

struct CutthroatView: View {
    
//    @State private var Player1 = ""
//    @State private var Player2 = ""
//    @State private var Player3 = ""
    
    @State private var names = ["", "", ""]
    @State private var results = [
        [false, false, false],
        [false, false, false],
        [false, false, false]
    ]

    private let lowBalls = [1, 2, 3, 4, 5]
    private let midBalls = [6, 7 ,8, 9, 10]
    private let hiBalls = [11, 12, 13, 14, 15]


    var body: some View {
        let nameSize: CGFloat = 100
        VStack {
            Grid() {
                ballGroups
                nameRow(0)
                nameRow(1)
                nameRow(2)
            }
            Spacer()
            bottomRow
        }
        .font(.system(size: nameSize))
        .textFieldStyle(.automatic)
        .multilineTextAlignment(.center)
        .padding(50)
        .background(Color(red: 0.153, green: 0.365, blue: 0.167).gradient)
        .minimumScaleFactor(0.01)
    }
    
    var ballGroups: some View {
        GridRow {
            Text("")
            OneBallGroup(lowBalls)
            OneBallGroup(midBalls)
            OneBallGroup(hiBalls)
        }
    }
    
    func OneBallGroup(_ balls: [Int]) -> some View {
//        let ballSize = 80.0 //should calculate based on geometery
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
            TextField("Player \(which+1)", text: $names[which])
            statButton(which, "L")
            statButton(which, "M")
            statButton(which, "H")
        }

    }
    
    
    func statButton(_ which: Int, _ level: String) -> some View {
        let indicators = ["L", "M", "H"]
        var otherIndicators = indicators
        let i = indicators.firstIndex(of: level)!
        otherIndicators.remove(at: i)
        print(otherIndicators)
        
        var otherPlayers = [0, 1, 2]
        otherPlayers.remove(at: which)
        
        return ZStack {
            Text(level)
            if results[which][i] {
                Text("X").foregroundStyle(.red)
            } else {
                if results[otherPlayers[0]][i] && results[otherPlayers[1]][i] {
                    Circle().stroke(lineWidth: 3).aspectRatio(0.75, contentMode: .fit)
                }
            }
        }
        .onTapGesture {
            if !results[otherPlayers[0]][i] || !results[otherPlayers[1]][i] {
                results[which][i].toggle()
            }
        }
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

    
    var bottomRow: some View {
        HStack {
            Spacer()
            newGame
        }
    }
    
    
    var newGame: some View {
        Button(action: {
            
        })
        {
            VStack{
                Image(systemName: "repeat.circle")
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
