//
//  SixPlayerSelectorView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 12/30/24.
//

import SwiftUI


struct SixPlayerSelectorView: View {
    @Binding var lightAngle: Double
    @Binding var names: [String]

    @StateObject var scorecard = ultraViewModel()  //this is kind of @ObservedObject??
    
    @State private var showingStripeSolid6Sheet = false
    @State private var showingCutthroat6Sheet = false
    
    @State private var cueOnScreen = [false, false]
    @State private var selectorOnScreen = [true, true]
    
    @State private var ballsVisible = false
    
    @Environment(\.dismiss) var dismiss
    
    
    let baseFontSize = 400.0
    
    var body: some View {
        GeometryReader {geometry in
            Rectangle().foregroundStyle(Color("Felt"))
                .ignoresSafeArea()
            VStack {
                BackButton()
                    .onTapGesture(perform: {
                        lightAngle = ChooserView.Constants.lightAngle.initial
                        withAnimation(.easeInOut(duration: ChooserView.Constants.lightAngle.duration)) {
                            lightAngle = ChooserView.Constants.lightAngle.final
                        }
                        dismiss()
                    })
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
            .onAppear{
                withAnimation(.easeInOut(duration: Constants.duration.vertical)) {
                    ballsVisible = true
                }
            }
        }
        .font(.system(size: baseFontSize))
        .minimumScaleFactor(0.01)
        .lineLimit(1)
    }
    
    
    func stripeSolidNav6() -> some View {
        let option = 0
        return HStack(spacing: 0) {
            PoolBallView(num: 0).spherify()
                .offset(x: cueOnScreen[option] ? Constants.offset : -250)
            Group {
                singleBall(ball: 1, row: option)
                singleBall(ball: 1, row: option)
                
                singleBall(ball: 2, row: option)
                singleBall(ball: 2, row: option)
                
                singleBall(ball: 3, row: option)
                singleBall(ball: 3, row: option)
            }
            .opacity(showingStripeSolid6Sheet ? 0 : 1)
            .offset(x: selectorOnScreen[option] ? Constants.offset : 1200)
            .offset(y: ballsVisible ? 0 : 700)
            .onTapGesture {
                withAnimation(.linear(duration: Constants.duration.cueIn)) {
                    cueOnScreen[option] = true
                } completion: {
                    withAnimation(.easeOut(duration: Constants.duration.ballsOut)) {
                        selectorOnScreen[option] = false
                    } completion: {
                        withAnimation(.easeInOut.delay(1))  {
                            showingStripeSolid6Sheet.toggle()
                            selectorOnScreen[option] = true
                        } completion: {
                            cueOnScreen[option] = false
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showingStripeSolid6Sheet) {
                CutthroatView(numPlayers: 6, lightAngle: $lightAngle, names: $names)
            }
        }
    }
    
    
    func cutthroatNav6() -> some View {
        let option = 1
        return HStack(spacing: 0) {
            PoolBallView(num: 0).spherify()
                .offset(x: cueOnScreen[option] ? Constants.offset : -250)
            Group {
                singleBall(ball: 1, row: option)
                singleBall(ball: 1, row: option)
                singleBall(ball: 1, row: option)

                singleBall(ball: 2, row: option)
                singleBall(ball: 2, row: option)
                singleBall(ball: 2, row: option)
            }
            .opacity(showingCutthroat6Sheet ? 0 : 1)
            .offset(x: selectorOnScreen[option] ? Constants.offset : 1200)
            .offset(y: ballsVisible ? 0 : 1000)
            .opacity(showingCutthroat6Sheet ? 0 : 1)
            .onTapGesture {
                withAnimation(.linear(duration: Constants.duration.cueIn)) {
                    cueOnScreen[option] = true
                } completion: {
                    withAnimation(.easeOut(duration: Constants.duration.ballsOut)) {
                        selectorOnScreen[option] = false
                    } completion: {
                        withAnimation(.easeInOut.delay(1))  {
                            showingCutthroat6Sheet.toggle()
                            selectorOnScreen[option] = true
                        } completion: {
                            cueOnScreen[option] = false
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showingCutthroat6Sheet) {
                StripeSolidView(numPlayers: 6, lightAngle: $lightAngle, names: $names)
            }
        }
    }
    
    func singleBall(ball: Int, row: Int) -> some View {
            PoolBallView(num: ball)
            .rotationEffect(Angle(degrees: selectorOnScreen[row] ? 0 : Constants.rotation))
                .rotationEffect(Angle(degrees: ballsVisible ? 0 : Constants.rotation))
               .spherify()
    }
    
    struct Constants {
        static let offset = -95.0
        static let rotation: Double = 720
        struct duration {
            static let vertical: TimeInterval = 1
            static let cueIn: TimeInterval = 0.1
            static let ballsOut: TimeInterval = 1.1
        }
    }
}


#Preview {
    SixPlayerSelectorView(lightAngle: .constant(90), names: .constant(["", "", "", "", "", ""]))
}
