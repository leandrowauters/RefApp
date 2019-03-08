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
    
var gameClient = GameClient()

    //FOR MYPROFILE STATISTICS
//    init(totalGames: String, homeWins: String, awayWins: String,totalHomeYellows: String, totalAwayYellows: String, totalHomeReds: String, totalAwayReds: String, totalHomeGoals: String, totalAwayGoals: String, avgHomeYellowPerGame: String, avgAwayYellowPerGame: String, avgHomeRedPerGame: String, avgAwayRedPerGame: String, avgRunningTimePerGame: String, avgInjuryTimeGiven: String) {
//        self.totalGames = totalGames
//        self.homeWins = homeWins
//        self.awayWins = awayWins
//        self.totalHomeYellows = totalHomeYellows
//        self.totalAwayYellows = totalAwayYellows
//        self.totalHomeReds = totalHomeReds
//        self.totalAwayReds = totalAwayReds
//        self.totalHomeGoals = totalHomeGoals
//        self.totalAwayGoals = totalAwayGoals
//        self.avgHomeYellowPerGame = avgHomeYellowPerGame
//        self.avgAwayYellowPerGame = avgAwayYellowPerGame
//        self.avgHomeRedPerGame = avgHomeRedPerGame
//        self.avgAwayRedPerGame = avgAwayRedPerGame
//        self.avgRunningTimePerGame = avgRunningTimePerGame
//        self.avgInjuryTimeGiven = avgInjuryTimeGiven
//    }
    static func getTotalStatistics(gameStatistics: [GameStatistics]) -> [String] {
        let spaces = String(repeating: " ", count: 4)

        let totalGames = "Number of games refereed:\(spaces)\(TotalStatistics.getTotalGame(gameStatistics: gameStatistics))"
        let homeWins = "Home team wins:\(spaces)\(TotalStatistics.getHomeWins(gameStatistics: gameStatistics))"
        let awayWins = "Away team wins:\(spaces)\(TotalStatistics.getAwayWins(gameStatistics: gameStatistics))"
        let draws = "Draws:\(spaces)\(TotalStatistics.getDraws(gameStatistics: gameStatistics))"
        let totalHomeYellows = "Total home team yellow cards:\(spaces)\(TotalStatistics.getTotalHomeYellowsCards(gameStatistics: gameStatistics))"
        let totalAwayYellows = "Total away team yellow cards:\(spaces)\(TotalStatistics.getTotalAwayYellowCards(gameStatistics: gameStatistics))"
        let totalHomeReds = "Total home team red cards:\(spaces)\(TotalStatistics.getTotalHomeRedCards(gameStatistics: gameStatistics))"
        let totalAwayReds = "Total away team red cards:\(spaces)\(TotalStatistics.getTotalAwayRedCards(gameStatistics: gameStatistics))"
        let totalHomeGoals = "Total home team goals:\(spaces)\(TotalStatistics.getTotalHomeGoals(gameStatistics: gameStatistics))"
        let totalAwayGoals = "Total away team goals:\(spaces)\(TotalStatistics.getTotalAwayGoals(gameStatistics: gameStatistics))"
        let avgHomeYellowPerGame = "Avg. of home team yellow cards per game:\(spaces)\(String(format: "%.2f", TotalStatistics.getAvgHomeYellowPerGame(gameStatistics: gameStatistics)))"
        let avgAwayYellowPerGame = "Avg. of away team yellow cards per game:\(spaces)\(String(format: "%.2f", TotalStatistics.getAvgAwayYellowPerGame(gameStatistics: gameStatistics)))"
        let avgHomeRedPerGame = "Avg. of home team red cards per game:\(spaces)\(String(format: "%.2f", TotalStatistics.getAvgHomeRedPerGame(gameStatistics: gameStatistics)))"
        let avgAwayRedPerGame = "Avg. of away team red cards per game:\(spaces)\(String(format: "%.2f", TotalStatistics.getAvgAwayRedPerGame(gameStatistics: gameStatistics)))"
        let avgRunningTimePerGame = "Avg. of running time per game:\(spaces)\(MainTimer.getTimeInString(time: TotalStatistics.getAvgTotalRunningTime(gameStatistics: gameStatistics)))"
        let avgOfInjuryTimeGiven = "Avg. of injury time per game:\(spaces)\(MainTimer.getTimeInString(time: TotalStatistics.getAvgTotalInjuryTimeGiven(gameStatistics: gameStatistics)))"
        return [totalGames,homeWins,awayWins,draws,totalHomeYellows,totalAwayYellows,totalHomeReds,totalAwayReds, totalHomeGoals,totalAwayGoals,avgHomeYellowPerGame,avgAwayYellowPerGame,avgHomeRedPerGame,avgAwayRedPerGame,avgRunningTimePerGame,avgOfInjuryTimeGiven]
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
    static func getDraws(gameStatistics:[GameStatistics]) -> Int {
        return gameStatistics.filter{$0.winnerSide == "Draw"}.count
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
    static func getAvgHomeYellowPerGame(gameStatistics: [GameStatistics]) -> Double{
        let totalGames = Double(TotalStatistics.getTotalGame(gameStatistics: gameStatistics))
        let totalHomeYellow = Double(TotalStatistics.getTotalHomeYellowsCards(gameStatistics: gameStatistics))
        return totalHomeYellow / totalGames
    }
    static func getAvgAwayYellowPerGame(gameStatistics: [GameStatistics]) -> Double{
        let totalGames = Double(TotalStatistics.getTotalGame(gameStatistics: gameStatistics))
        let totalAwayYellow = Double(TotalStatistics.getTotalAwayYellowCards(gameStatistics: gameStatistics))
        return totalAwayYellow / totalGames
    }
    static func getAvgHomeRedPerGame(gameStatistics: [GameStatistics]) -> Double{
        let totalGames = Double(TotalStatistics.getTotalGame(gameStatistics: gameStatistics))
        let totalHomeRed = Double(TotalStatistics.getTotalHomeRedCards(gameStatistics: gameStatistics))
        return totalHomeRed / totalGames
    }
    static func getAvgAwayRedPerGame(gameStatistics: [GameStatistics]) -> Double{
        let totalGames = Double(TotalStatistics.getTotalGame(gameStatistics: gameStatistics))
        let totalAwayRed = Double(TotalStatistics.getTotalAwayRedCards(gameStatistics: gameStatistics))
        return totalAwayRed / totalGames
    }
    static func getAvgTotalRunningTime(gameStatistics: [GameStatistics]) -> Double {
        let totalGames = TotalStatistics.getTotalGame(gameStatistics: gameStatistics)
        let totalRunningTime = gameStatistics.reduce(0) {$0 + $1.totalRunningTime}
        return totalRunningTime / Double(totalGames)
    }
    static func getAvgTotalInjuryTimeGiven(gameStatistics: [GameStatistics]) -> Double {
        let totalGames = TotalStatistics.getTotalGame(gameStatistics: gameStatistics)
        let totalInjuryTimeGive = gameStatistics.reduce(0) {$0 + $1.totalInjuryTimeGiven}
        return totalInjuryTimeGive / Double(totalGames)
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
    var totalRunningTime: Double
    var totalInjuryTimeGiven: Double
    var homeYellowCards: Int
    var awayYellowCards: Int
    var homeRedCards: Int
    var awayRedCards: Int
    var homeGoals: Int
    var awayGoals: Int
    
    init(userID: String, winnerSide: String, totalRunningTime: Double, totalInjuryTimeGiven: Double, homeYellowCards: Int, awayYellowCards: Int, homeRedCards: Int, awayRedCards: Int, homeGoals: Int, awayGoals: Int) {
        self.userID = userID
        self.winnerSide = winnerSide
        self.totalRunningTime = totalRunningTime
        self.totalInjuryTimeGiven = totalInjuryTimeGiven
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
        self.totalRunningTime = dict["totalRunningTime"] as? Double ?? 0.0
        self.totalInjuryTimeGiven = dict["totalInjuryTimeGiven"] as? Double ?? 0.0
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

