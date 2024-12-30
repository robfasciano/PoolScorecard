//
//  SixPlayerSelectorView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 12/30/24.
//

import SwiftUI


struct SixPlayerSelectorView: View {
    @StateObject var scorecard = ultraViewModel()  //this is kind of @ObservedObject??
    
    @State private var showingStripeSolid6Sheet = false
    @State private var showingCutthroat6Sheet = false
    
    @State private var cueOnScreen = [false, false]
    @State private var selectorOnScreen = [true, true]
    
    @Environment(\.dismiss) var dismiss
    
    
    let baseFontSize = 400.0
    
    var body: some View {
        GeometryReader {geometry in
            Rectangle().foregroundStyle(PoolScorecardApp.Constants.feltColor)
                .ignoresSafeArea()
            VStack {
                BackButton()
                    .onTapGesture(perform: { dismiss() })
                Spacer()
                Text("Select 6-Player Configuration")
                    .foregroundStyle(PoolScorecardApp.Constants.textColor1)
                VStack {
                    Spacer()
                    stripeSolidNav6()
                    Spacer()
                    cutthroatNav6()
                    Spacer()
                }
            }
            .padding()
        }
        .font(.system(size: baseFontSize))
        .minimumScaleFactor(0.01)
        .lineLimit(1)
    }
    
    
    func stripeSolidNav6() -> some View {
        let option = 0
        return HStack(spacing: 0) {
            PoolBallView(num: 0).spherify()
                .offset(x: cueOnScreen[option] ? Constants.offset : -300)
            Group {
                PoolBallView(num: 1).spherify()
                PoolBallView(num: 1).spherify()
                PoolBallView(num: 2).spherify()
                PoolBallView(num: 2).spherify()
                PoolBallView(num: 3).spherify()
                PoolBallView(num: 3).spherify()
            }
            .opacity(showingStripeSolid6Sheet ? 0 : 1)
            .offset(x: selectorOnScreen[option] ? Constants.offset : 800)
            .onTapGesture {
                withAnimation(.linear) {
                    cueOnScreen[option] = true
                } completion: {
                    withAnimation(.easeOut) {
                        selectorOnScreen[option] = false
                    } completion: {
                        showingStripeSolid6Sheet.toggle()
                        cueOnScreen[option] = false
                        selectorOnScreen[option] = true
                    }
                }
            }
            .fullScreenCover(isPresented: $showingStripeSolid6Sheet) {
                CutthroatView(numPlayers: 6)
            }
        }
    }
    
    
    func cutthroatNav6() -> some View {
        let option = 1
        return HStack(spacing: 0) {
            PoolBallView(num: 0).spherify()
                .offset(x: cueOnScreen[option] ? Constants.offset : -300)
            Group {
                PoolBallView(num: 1).spherify()
                PoolBallView(num: 1).spherify()
                PoolBallView(num: 1).spherify()
                PoolBallView(num: 2).spherify()
                PoolBallView(num: 2).spherify()
                PoolBallView(num: 2).spherify()
            }
            .opacity(showingCutthroat6Sheet ? 0 : 1)
            .offset(x: selectorOnScreen[option] ? Constants.offset : 800)
            .opacity(showingCutthroat6Sheet ? 0 : 1)
            .onTapGesture {
                withAnimation(.linear) {
                    cueOnScreen[option] = true
                } completion: {
                    withAnimation(.easeOut) {
                        selectorOnScreen[option] = false
                    } completion: {
                        showingCutthroat6Sheet.toggle()
                        cueOnScreen[option] = false
                        selectorOnScreen[option] = true
                    }
                }
            }
            .fullScreenCover(isPresented: $showingCutthroat6Sheet) {
                StripeSolidView(numPlayers: 6)
            }
        }
    }
    
    
    struct Constants {
        static let offset = -95.0
    }
}


#Preview {
    SixPlayerSelectorView()
}
