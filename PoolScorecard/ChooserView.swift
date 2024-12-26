//
//  ContentView.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 10/27/24.
//

import SwiftUI


struct ChooserView: View {
    @StateObject var scorecard = ultraViewModel()  //this is kind of @ObservedObject??
    
    @State private var showingStripesolidSheet = false
    @State private var showingCutthroatSheet = false
    @State private var showingUltraSheet = false
    
    @State private var onScreen4P1 = false
    @State private var onScreen4P2 = true


    let baseFontSize = 400.0
    
    var body: some View {
        GeometryReader {geometry in
            NavigationStack {
               ZStack {
                    Rectangle().foregroundStyle(PoolScorecardApp.Constants.feltColor)
                        .ignoresSafeArea()
                    VStack {
                        Spacer()
                        Text("Select Number of Players")
                            .foregroundStyle(PoolScorecardApp.Constants.textColor1)
                        Spacer()
                        VStack {
                            NavigationLink(
                                destination: StripeSolidView(players: 2),
                                label: {PoolBallView(num: 2).spherify()}
                            )
                            NavigationLink(
                                destination: CutthroatView(),
                                label: {PoolBallView(num: 3).spherify()}
                                )
                            NavigationLink(
                                destination: StripeSolidView(players: 4),
                                label: {PoolBallView(num: 4).spherify()}
                            )
//                            NavigationLink(
//                                destination: UltraView(scorecard: ultraViewModel()),
//                                label: {PoolBallView(num: 5).spherify()}
//                            )
                            HStack(spacing: 0){
                                PoolBallView(num: 0).spherify()
                                    .offset(x: onScreen4P1 ? Constants.offset : -800)
                                PoolBallView(num: 5).spherify()
                                    .offset(x: onScreen4P2 ? Constants.offset : 800)
                                    .onTapGesture {
                                        
                                        showingUltraSheet.toggle()
                                    }
                                    .fullScreenCover(isPresented: $showingUltraSheet) {
                                        UltraView(scorecard: ultraViewModel())
                                    }
                            }
//                                .sheet(isPresented: $showingUltraSheet) {
//                                    UltraView(scorecard: ultraViewModel())
//                                }
                            Spacer()
                        }
                        .padding()
                    }
                }
            }
            .font(.system(size: baseFontSize))
            .minimumScaleFactor(0.01)
            .lineLimit(1)
        }
    }
    
    struct Constants {
        static let offset = -95.0
    }
}

#Preview {
    ChooserView()
}
