//
//  ContentView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI


struct ChooserView: View {
    @StateObject var scorecard = ultraViewModel()  //this is kind of @ObservedObject??
    
    @State private var showing2PSheet = false
    @State private var showing4PSheet = false
    @State private var showingCutthroatSheet = false
    @State private var showingUltraSheet = false
    @State private var showing6SelectorSheet = false
    @State private var lightAngle: Double = Constants.lightAngle.initial
    
    @State private var names = Array.init(repeating: "", count: 6)
    //    @State private var names = ["MattFayTheBrotherInLaw", "Bobby", "Ella", "Mom", "Dad", "Lily"]

    @State private var cueOnScreen = [false, false, false, false, false]
    @State private var selectorOnScreen = [true, true, true, true, true]
    
    var body: some View {
        GeometryReader {geometry in
            //            NavigationStack {
            //               ZStack {
            Rectangle().foregroundStyle(Color("Felt"))
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Select Number of Players")
                    .foregroundStyle(PoolScorecardApp.Constants.textColor1)
                Spacer()
                VStack {
                    ballNavLink(numplayers: 2)
                    ballNavLink(numplayers: 3)
                    ballNavLink(numplayers: 4)
                    ballNavLink(numplayers: 5)
                    ballNavLink(numplayers: 6)
                    Spacer()
                }
                .padding()
            }
            .padding()
            .onAppear {
                withAnimation(.easeInOut(duration: Constants.lightAngle.duration)) {
                    lightAngle = Constants.lightAngle.final
                }
            }
        }
        .font(.system(size: Constants.baseFontSize))
        .minimumScaleFactor(0.01)
        .lineLimit(1)
    }
    
    
    func ballNavLink(numplayers: Int, _ teamsOfThree: Bool = false) -> some View {
        return HStack(spacing: 0) {
            PoolBallView(num: 0).spherify(angle: lightAngle)
                .offset(x: cueOnScreen[numplayers-2] ? Constants.offset : -800)
            switch numplayers {
            case 2:
                stripeSolidNav2()
            case 3:
                cutthroatNav()
            case 4:
                stripeSolidNav4()
            case 5:
                ultraNav()
            case 6:
                chooseWhichSix()
            default:
                Text("error") //should not get here
            }
        }
    }
    
    func stripeSolidNav2() -> some View {
        let numPlayers = 2
        return PoolBallView(num: numPlayers).spherify(angle: lightAngle)
            .opacity(showing2PSheet ? 0 : 1)
            .offset(x: selectorOnScreen[numPlayers-2] ? Constants.offset : 800)
            .onTapGesture {
                withAnimation(.linear) {
                    cueOnScreen[numPlayers-2] = true
                } completion: {
                    withAnimation(.easeOut) {
                        selectorOnScreen[numPlayers-2] = false
                    } completion: {
                        showing2PSheet.toggle()
                        selectorOnScreen[numPlayers-2] = true
                        withAnimation(.easeInOut.delay(1)) {
                            cueOnScreen[numPlayers-2] = false
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showing2PSheet) {
                StripeSolidView(numPlayers: numPlayers, lightAngle: $lightAngle, names: $names)
            }
    }
  
    func stripeSolidNav4() -> some View {
        let numPlayers = 4
        return PoolBallView(num: numPlayers).spherify(angle: lightAngle)
            .opacity(showing4PSheet ? 0 : 1)
            .offset(x: selectorOnScreen[numPlayers-2] ? Constants.offset : 800)
            .onTapGesture {
                withAnimation(.linear) {
                    cueOnScreen[numPlayers-2] = true
                } completion: {
                    withAnimation(.easeOut) {
                        selectorOnScreen[numPlayers-2] = false
                    } completion: {
                        showing4PSheet.toggle()
                        selectorOnScreen[numPlayers-2] = true
                        withAnimation(.easeInOut.delay(1)) {
                            cueOnScreen[numPlayers-2] = false
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showing4PSheet) {
                StripeSolidView(numPlayers: numPlayers, lightAngle: $lightAngle, names: $names)
            }
    }
        
    func chooseWhichSix() -> some View {
        let numPlayers = 6
        return PoolBallView(num: numPlayers).spherify(angle: lightAngle)
            .opacity(showing6SelectorSheet ? 0 : 1)
            .offset(x: selectorOnScreen[numPlayers-2] ? Constants.offset : 800)
            .onTapGesture {
                withAnimation(.linear) {
                    cueOnScreen[numPlayers-2] = true
                } completion: {
                    withAnimation(.easeOut) {
                        selectorOnScreen[numPlayers-2] = false
                    } completion: {
                        showing6SelectorSheet.toggle()
                        selectorOnScreen[numPlayers-2] = true
                        withAnimation(.easeInOut.delay(1)) {
                            cueOnScreen[numPlayers-2] = false
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showing6SelectorSheet) {
                SixPlayerSelectorView(lightAngle: $lightAngle, names: $names)
            }
    }

    
    
    func cutthroatNav() -> some View {
        let numPlayers = 3
        return PoolBallView(num: numPlayers).spherify(angle: lightAngle)
            .opacity(showingCutthroatSheet ? 0 : 1)
            .offset(x: selectorOnScreen[numPlayers-2] ? Constants.offset : 800)
            .opacity(showingCutthroatSheet ? 0 : 1)
            .onTapGesture {
                withAnimation(.linear) {
                    cueOnScreen[numPlayers-2] = true
                } completion: {
                    withAnimation(.easeOut) {
                        selectorOnScreen[numPlayers-2] = false
                    } completion: {
                        showingCutthroatSheet.toggle()
                        selectorOnScreen[numPlayers-2] = true
                        withAnimation(.easeInOut.delay(1)) {
                            cueOnScreen[numPlayers-2] = false
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showingCutthroatSheet) {
                CutthroatView(numPlayers: 3, lightAngle: $lightAngle, names: $names)
            }
    }
    
    func ultraNav() -> some View {
        let numPlayers = 5
        return PoolBallView(num: numPlayers).spherify(angle: lightAngle)
            .opacity(showingUltraSheet ? 0 : 1)
            .offset(x: selectorOnScreen[numPlayers-2] ? Constants.offset : 800)
            .onTapGesture {
                withAnimation(.linear) {
                    cueOnScreen[numPlayers-2] = true
                } completion: {
                    withAnimation(.easeOut) {
                        selectorOnScreen[numPlayers-2] = false
                    } completion: {
                        showingUltraSheet.toggle()
                        selectorOnScreen[numPlayers-2] = true
                        withAnimation(.easeInOut.delay(1)) {
                            cueOnScreen[numPlayers-2] = false
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showingUltraSheet) {
                UltraView(scorecard: ultraViewModel(), lightAngle: $lightAngle, names: $names)
            }
    }
    

    struct Constants {
        static let baseFontSize = 400.0
        static let offset = -95.0
        struct lightAngle {
            static let initial: Double = 130
            static let final: Double = 40
            static let duration: TimeInterval = 1.5        }
    }
}

#Preview {
    ChooserView()
}
