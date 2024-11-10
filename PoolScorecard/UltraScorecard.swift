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
    
    mutating func processNewCircledLevel(player: Int) -> [[Int]] {
        for l in 0..<standings[0].count {
            if standings[player][l] == .unknown {
                standings[player][l] = .circled
            }
        }
        return processAllCircles()
    }
    
    mutating func processNewCircledPlayer(level: Int) -> [[Int]] {
        for p in 0..<standings.count {
            if standings[p][level] == .unknown {
                standings[p][level] = .circled
            }
        }
        return processAllCircles()
    }
   
    mutating func processAllCircles() -> [[Int]] {
        var newCircles: [[Int]] = []
        for p in 0..<standings.count {
            for l in 0..<standings[0].count {
                if standings[p][l] == .circled {
                    newCircles += markOtherIndicators(player: p, level: l)
                }
            }
        }
        return newCircles
    }
    
    mutating func markOtherIndicators(player: Int, level: Int) -> [[Int]] {
        var newCircles: [[Int]] = []
        for p in 0..<standings.count {
            if p != player {
                if standings[p][level] == .unknown {
                    standings[p][level] = .checkedByCircle
                    if setCompletedInPlayer(p) {
                        newCircles.append([p, level])
                    }
                }
            }
        }
        for l in 0..<standings[0].count {
            if l != level {
                if standings[player][l] == .unknown {
                    standings[player][l] = .checkedByCircle
                    if setCompletedinLevel(l) {
                        newCircles.append([player, l])
                    }
                }
            }
        }
        return newCircles
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
            return true
        }
        return false
    }
    
    //MARK: - Data Access functions
    var numPlayers:Int {
        standings.count
    }

    //MARK: - User Intent functions
    mutating func selectIndicator(player: Int, indicator: Int) {
        switch standings[player][indicator] {
        case .checkedByCircle:
            standings[player][indicator] = .checkedByClick
            if setCompletedInPlayer(player) {
                _ = processNewCircledLevel(player: player)
            }
            if setCompletedinLevel(indicator) {
                _ = processNewCircledPlayer(level: indicator)
            }
        case .checkedByClick:
            standings[player][indicator] = .unknown
            //FIXME: may need to uncircle indicators
        case .circled:
            return
        case .unknown:
            standings[player][indicator] = .checkedByClick
            if setCompletedInPlayer(player) {
                let newCircles = processNewCircledLevel(player: player)
                if newCircles.count == 1 {
                    _ = processNewCircledLevel(player: newCircles[0][0])
                }
            }
            if setCompletedinLevel(indicator) {
                let newCircles = processNewCircledPlayer(level: indicator)
                if newCircles.count == 1 {
                    _ = processNewCircledPlayer(level: newCircles[0][1])
                }
            }
        }
    }
    
    mutating func resetIndicator(player: Int, indicator: Int) {
        switch standings[player][indicator] {
        case .checkedByCircle, .checkedByClick, .circled:
            standings[player][indicator] = .unknown
        case .unknown:
            return
        }
    }


    mutating func clearStatus() {
        for p in 0..<standings.count {
            for i in 0..<standings[0].count {
                standings[p][i] = .unknown
            }
        }
    }
    
    //MARK: - Debug functions
    func debugStanding() {
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
