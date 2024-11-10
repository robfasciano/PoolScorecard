//
//  UltraViewModel.swift
//  PoolScorecard
//
//  Created by Robert Fasciano on 11/7/24.
//

import SwiftUI

class ultraViewModel: ObservableObject {
    private static let numberOfPlayers = 5 //should pass in somehow
    
    private static func createUltraScorecard(players: Int) -> ultraScorcard { //ther should be a way to pass in the number of players
        ultraScorcard(players: players)
    }
    
    @Published private var model = createUltraScorecard(players: numberOfPlayers)
    
    func standings(_ player: Int, _ level: Int) -> ultraScorcard.status {
        return model.standings[player][level]
    }
    
    func clearStatus() {
        model.clearStatus()
    }
    
    func selectIndicator(player: Int, indicator: Int) {
        model.selectIndicator(player: player, indicator: indicator)
    }
    
    func resetIndicator(player: Int, indicator: Int) {
        model.resetIndicator(player: player, indicator: indicator)
    }
}

