//
//  Statistics.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/20/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

enum Card {
    case yellow
    case red
}
enum Winner {
    case home
    case away
}
class TotalStatistics {
    
    var totalGames: Int
    var homeWins: Int
    var awayWins: Int
    var totalHomeYellows: Int
    var totalAwayYellows: Int
    var totalHomeReds: Int
    var totalAwayReds: Int
    var totalHomeGoals: Int
    var totalAwayGoals: Int
    var avgHomeYellowPerGame: Int
    var avgAwayYellowPerGame: Int
    var avgHomeRedPerGame: Int
    var avgAwayRedPerGame: Int
    

    //FOR MYPROFILE STATISTICS
    init(totalGames: Int, homeWins: Int, awayWins: Int,totalHomeYellows: Int, totalAwayYellows: Int, totalHomeReds: Int, totalAwayReds: Int, totalHomeGoals: Int, totalAwayGoals: Int, avgHomeYellowPerGame: Int, avgAwayYellowPerGame: Int, avgHomeRedPerGame: Int, avgAwayRedPerGame: Int) {
        self.totalGames = totalGames
        self.homeWins = homeWins
        self.awayWins = awayWins
        self.totalHomeYellows = totalHomeYellows
        self.totalAwayYellows = totalAwayYellows
        self.totalHomeReds = totalHomeReds
        self.totalAwayReds = totalAwayReds
        self.totalHomeGoals = totalHomeGoals
        self.totalAwayGoals = totalAwayGoals
        self.avgHomeYellowPerGame = avgHomeYellowPerGame
        self.avgAwayYellowPerGame = avgAwayYellowPerGame
        self.avgHomeRedPerGame = avgHomeRedPerGame
        self.avgAwayRedPerGame = avgAwayRedPerGame
    }

    //TO DO: CREAT AN INIT FOR THE END OF THE MATCH
}

class GameStatistics {
    static var homeYellowCards = 0
    static var awayYellowCards = 0
    static var homeRedCard = 0
    static var awayRedCard = 0
    
    
    var winner: Winner
    var homeYellowCards: Int
    var awayYellowCards: Int
    var homeRedCards: Int
    var awayRedCards: Int
    var homeGoals: Int
    var awayGoals: Int
    
    init(winner: Winner, homeYellowCards: Int, awayYellowCards: Int, homeRedCards: Int, awayRedCards: Int, homeGoals: Int, awayGoals: Int) {
        self.winner = winner
        self.homeYellowCards = homeYellowCards
        self.awayYellowCards = awayYellowCards
        self.homeRedCards = homeRedCards
        self.awayRedCards = awayRedCards
        self.homeGoals = homeGoals
        self.awayGoals = awayGoals
    }
    static func getWinner() -> Winner {
        let winner: Winner
        if Game.homeScore > Game.awayScore {
            winner = .home
        } else {
            winner = .away
        }
        return winner
    }
}

