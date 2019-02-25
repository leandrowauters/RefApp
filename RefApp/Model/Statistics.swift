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
enum Winner: String {
    case home = "Home"
    case away =  "Away"
    case draw = "Draw"
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
    static func getTotalGame(gameStatistics: [GameStatistics]) -> Int{
        return gameStatistics.count
    }
    static func getHomeWins(gameStatistics:[GameStatistics]) -> Int {
        return gameStatistics.filter{$0.winnerSide == "Home"}.count
    }
    static func getAwayWins(gameStatistics:[GameStatistics]) -> Int {
        return gameStatistics.filter{$0.winnerSide == "Away"}.count
    }
    static func getTotalHomeYellowsCards(gameStatistics:[GameStatistics]) -> Int{
        return gameStatistics.reduce(0) {$0 + $1.homeYellowCards}
    }
    static func getTotalAwayYellowCards(gameStatistics: [GameStatistics]) -> Int {
        return gameStatistics.reduce(0) {$0 + $1.awayYellowCards}
    }
    static func getTotalHomeRedCards(gameStatistics:[GameStatistics]) -> Int{
        return gameStatistics.reduce(0) {$0 + $1.homeRedCards}
    }
    static func getTotalAwayRedCards(gameStatistics:[GameStatistics]) -> Int{
        return gameStatistics.reduce(0) {$0 + $1.awayRedCards}
    }
    static func getTotalHomeGoals(gameStatistics:[GameStatistics]) -> Int{
        return gameStatistics.reduce(0) {$0 + $1.homeGoals}
    }
    static func getTotalAwayGoals(gameStatistics:[GameStatistics]) -> Int{
        return gameStatistics.reduce(0) {$0 + $1.awayGoals}
    }
    static func getAvgHomeYellowPerGame(gameStatistics: [GameStatistics]) -> Int{
        let totalGames = TotalStatistics.getTotalGame(gameStatistics: gameStatistics)
        let totalHomeYellow = TotalStatistics.getTotalHomeYellowsCards(gameStatistics: gameStatistics)
        return totalHomeYellow / totalGames
    }
    static func getAvgAwayYellowPerGame(gameStatistics: [GameStatistics]) -> Int{
        let totalGames = TotalStatistics.getTotalGame(gameStatistics: gameStatistics)
        let totalAwayYellow = TotalStatistics.getTotalAwayYellowCards(gameStatistics: gameStatistics)
        return totalAwayYellow / totalGames
    }
    static func getAvgHomeRedPerGame(gameStatistics: [GameStatistics]) -> Int{
        let totalGames = TotalStatistics.getTotalGame(gameStatistics: gameStatistics)
        let totalHomeRed = TotalStatistics.getTotalHomeRedCards(gameStatistics: gameStatistics)
        return totalHomeRed / totalGames
    }
    static func getAvgAwayRedPerGame(gameStatistics: [GameStatistics]) -> Int{
        let totalGames = TotalStatistics.getTotalGame(gameStatistics: gameStatistics)
        let totalAwayRed = TotalStatistics.getTotalAwayRedCards(gameStatistics: gameStatistics)
        return totalAwayRed / totalGames
    }
    //TO DO: CREAT AN INIT FOR THE END OF THE MATCH
}

class GameStatistics {
    static var homeYellowCards = 0
    static var awayYellowCards = 0
    static var homeRedCard = 0
    static var awayRedCard = 0
    
    var userID: String
    var winnerSide: String
    var winnerTeam: String
    var totalRunningTime: Int
    var homeYellowCards: Int
    var awayYellowCards: Int
    var homeRedCards: Int
    var awayRedCards: Int
    var homeGoals: Int
    var awayGoals: Int
    
    init(userID: String, winnerSide: String, winnerTeam: String, totalRunningTime: Int, homeYellowCards: Int, awayYellowCards: Int, homeRedCards: Int, awayRedCards: Int, homeGoals: Int, awayGoals: Int) {
        self.userID = userID
        self.winnerSide = winnerSide
        self.winnerTeam = winnerTeam
        self.totalRunningTime = totalRunningTime
        self.homeYellowCards = homeYellowCards
        self.awayYellowCards = awayYellowCards
        self.homeRedCards = homeRedCards
        self.awayRedCards = awayRedCards
        self.homeGoals = homeGoals
        self.awayGoals = awayGoals
    }
    init(dict: [String: Any]) {
        self.userID = dict["userID"] as? String ?? "no user id"
        self.winnerSide = dict["winnerSide"] as? String ?? "no winner side"
        self.winnerTeam = dict["winnerTeam"] as? String ?? "no winner team"
        self.totalRunningTime = dict["totalRunningTime"] as? Int ?? 0
        self.homeYellowCards = dict["homeYellowCards"] as? Int ?? 0
        self.awayYellowCards = dict["awayYellowCards"] as? Int ?? 0
        self.homeRedCards = dict["homeRedCards"] as? Int ?? 0
        self.awayRedCards = dict["awayRedCards"] as? Int ?? 0
        self.homeGoals = dict["homeGoals"] as? Int ?? 0
        self.awayGoals = dict["awayGoals"] as? Int ?? 0
    }
    static func getWinnerHomeAway() -> String{
        let winner: Winner
        if Game.homeScore > Game.awayScore {
            winner = .home
        } else if Game.homeScore < Game.awayScore{
            winner = .away
        } else {
            winner = .draw
        }
        return winner.rawValue
    }
    static func getWinnerTeam() -> String{
        var winner = String()
        if Game.homeScore > Game.awayScore {
            winner = Game.homeTeam
        } else if Game.homeScore < Game.awayScore {
            winner = Game.awayTeam
        } else {
            winner = "Draw"
        }
        return winner
    }
}

