//
//  CutthroatView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 11/1/24.
//

import SwiftUI

struct CutthroatView: View {
    
    @State private var Player1 = ""
    @State private var Player2 = ""
    @State private var Player3 = ""
    
    private let low = [1, 2, 3, 4, 5]
    private let mid = [6, 7 ,8, 9, 10]
    private let hi = [11, 12, 13, 14, 15]
    
    var body: some View {
        let nameSize: CGFloat = 100
        VStack {
            Grid() {
                ballGroups
                nameRow1
                nameRow2
                nameRow3
            }
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
            OneBallGroup(low)
            OneBallGroup(mid)
            OneBallGroup(hi)
        }
    }
    
    func OneBallGroup(_ balls: [Int]) -> some View {
        let ballSize = 80.0 //should calculate based on geometery
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
    
    
    var nameRow1: some View {
        GridRow {
            TextField("Player 1", text: $Player1)
            Text("L")
            Text("M")
            Text("H")
        }
    }
    
    var nameRow2: some View {
        GridRow {
            TextField("Player 2", text: $Player2)
            Text("L")
            Text("M")
            Text("H")
        }
    }
    
    var nameRow3: some View {
        GridRow {
            TextField("Player 3", text: $Player3)
            Text("L")
            Text("M")
            Text("H")
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
