//
//  ultraScorcard.swift
//  PoolScorecard
//  Model
//
//  Created by Robert Fasciano on 11/6/24.
//

import Foundation

struct ultraScorcard {
    var standings: [[status]] = []
    
    enum status: String {
        case checkedByCircle = "x"
        case checkedByClick = "X"
        case circled = "O"
        case unknown = "?"
    }
    
    //this assumes that # of player is the same as number of ball groups.
    //I am pretty sure this logic only makes sense if this is the case, so we should be good.
    init(players: Int) {
        var aPlayer: [status] = []
        for _ in 0..<players {
            aPlayer.append(status.unknown)
        }
        for _ in 0..<players {
            standings.append(aPlayer)
        }
    }
    
    
    mutating func selectIndicator(player: Int, indicator: Int) {
        switch standings[player][indicator] {
        case .checkedByCircle:
            standings[player][indicator] = .checkedByClick
        case .checkedByClick:
            standings[player][indicator] = .unknown
            //FIXME: may need to uncircle indicators
        case .circled:
            return
        case .unknown:
            standings[player][indicator] = .checkedByClick
            if setCompletedInPlayer(player) { //FIXME: check if only one circle created
                processNewCircledLevel(player: player)
            }
            if setCompletedinLevel(indicator) { //FIXME: check if only one circle created
                processNewCircledPlayer(level: indicator)
            }
        }
        debugStanding()
    }
    
    mutating func processNewCircledLevel(player: Int) {
        for l in 0..<standings[0].count {
            if standings[player][l] == .unknown {
                standings[player][l] = .circled
            }
        }
        processAllCircles()
    }
    
    mutating func processNewCircledPlayer(level: Int) {
        for p in 0..<standings.count {
            if standings[p][level] == .unknown {
                standings[p][level] = .circled
            }
        }
        processAllCircles()
    }
   
    mutating func processAllCircles() {
        for p in 0..<standings.count {
            for l in 0..<standings[0].count {
                if standings[p][l] == .circled {
                    markOtherIndicators(player: p, level: l)
                }
            }
        }
    }
    
    mutating func markOtherIndicators(player: Int, level: Int) {
        for p in 0..<standings.count {
            if p != player {
                if standings[p][level] == .unknown {
                    standings[p][level] = .checkedByCircle
                }
            }
        }
        for l in 0..<standings[0].count {
            if l != level {
                if standings[player][l] == .unknown {
                    standings[player][l] = .checkedByCircle
                }
            }
        }
    }

    
    func setCompletedInPlayer(_ player: Int) -> Bool {
        var markCount = 0
        for i in 0..<standings[0].count {
            if standings[player][i] == .checkedByClick
                || standings[player][i] == .checkedByCircle {
                markCount += 1
            }
        }
        if markCount == standings[0].count - 1 {
            print("completed in player")
            return true
        }
        return false
    }

    func setCompletedinLevel(_ indicator: Int) -> Bool {
        var markCount = 0
        for p in 0..<standings.count {
            if standings[p][indicator] == .checkedByClick
                || standings[p][indicator] == .checkedByCircle {
                markCount += 1
            }
        }
        if markCount == standings.count - 1 {
            print("completed in level")
            return true
        }
        return false
    }

    
    var numPlayers:Int {
        standings.count
    }
    
    mutating func clearStatus() {
        debugStanding()
        for p in 0..<standings.count {
            for i in 0..<standings[0].count {
                standings[p][i] = .unknown
            }
        }
        debugStanding()
    }
    
    //MARK: - debug functions
    func debugStanding() {
//        var test1: String
        var toPrint = ""
        for p in 0..<standings.count {
            toPrint += "Player \(p+1): "
            for i in 0..<standings[0].count {
                toPrint += "\(standings[p][i].rawValue) "
            }
            toPrint += "\r\n"
        }
        print(toPrint)
    }
    
}
