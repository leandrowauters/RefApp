//
//  GameData.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/22/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

class GameData {
    var userID: String
    var winner: String
    var gameName: String?
    var lengthSelected: Int
    var numberOfPlayers: Int
    var location: String
    var dateAndTime: String
    var league: String
    var refereeNames: [String]
    var caps: [String]
    var extraTime: Bool
    var homeTeam: String
    var awayTeam: String
    var homeScore: Int
    var awayScore: Int
    var totalRunningTime: Double
    var totalInjuryTimeGiven: Double
    var subs: Int
    var homePlayers: [Int]
    var awayPlayers: [Int]
    var homeYellowCardPlayers: [Int]
    var homeRedCardPlayers: [Int]
    var awayYellowCardPlayers: [Int]
    var awayRedCardPlayers:[Int]
    var homeGoalsPlayers: [Int]
    var awayGoalsPlayers: [Int]
    var gameNotes: [String]

    static func getGameData(gameData: GameData) -> [String] {
        let spaces = String(repeating: " ", count: 4)
        let winner = "Winner:\(spaces)\(gameData.winner)"
        let totalRunningTime = "Running time:\(spaces)\(gameData.totalRunningTime)"
        let totalInjuryTime = "Total injury time:\(spaces)\(gameData.totalInjuryTimeGiven)"
        let homeYellowCards = "Home yellow cards:\(spaces)\(gameData.homeYellowCardPlayers.count)"
        let awayYellowCards = "Away yellow cards:\(spaces)\(gameData.awayYellowCardPlayers.count)"
        let homeRedCards = "Home red cards:\(spaces)\(gameData.homeRedCardPlayers.count)"
        let awayRedCards = "Away red cards:\(spaces)\(gameData.awayRedCardPlayers.count)"
        return [winner,totalRunningTime,totalInjuryTime,homeYellowCards,awayYellowCards,homeRedCards,awayRedCards]
    }
    init(userID: String,winner: String,gameName: String?, lengthSelected:Int, numberOfPlayers: Int, location: String, dateAndTime: String, league: String, refereeNames: [String], caps: [String], extraTime: Bool, homeTeam: String, awayTeam: String,homeScore: Int, awayScore: Int, totalRunningTime: Double, totalInjuryTimeGiven: Double, subs: Int, homePlayers: [Int], awayPlayers: [Int],homeYellowCardPlayers: [Int],homeRedCardPlayers: [Int],awayYellowCardPlayers: [Int], awayRedCardPlayers:[Int], homeGoalsPlayers: [Int], awayGoalsPlayers: [Int], gameNotes: [String]) {
        self.userID = userID
        self.winner = winner
        self.gameName = gameName
        self.lengthSelected = lengthSelected
        self.numberOfPlayers = numberOfPlayers
        self.location = location
        self.dateAndTime = dateAndTime
        self.league = league
        self.refereeNames = refereeNames
        self.caps = caps
        self.extraTime = extraTime
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.totalRunningTime = totalRunningTime
        self.totalInjuryTimeGiven = totalInjuryTimeGiven
        self.subs = subs
        self.homePlayers = homePlayers
        self.awayPlayers = awayPlayers
        self.homeYellowCardPlayers = homeYellowCardPlayers
        self.homeRedCardPlayers = homeRedCardPlayers
        self.awayYellowCardPlayers = awayYellowCardPlayers
        self.awayRedCardPlayers = awayRedCardPlayers
        self.homeGoalsPlayers = homeGoalsPlayers
        self.awayGoalsPlayers = awayGoalsPlayers
        self.gameNotes = gameNotes
    }
    
    init(dict: [String: Any]) {
        self.userID = dict["userID"] as? String ?? "no user id"
        self.winner = dict["winner"] as? String ?? "n/a"
        self.gameName = dict["gameName"] as? String ?? "n/a"
        self.lengthSelected = dict["lengthSelected"] as? Int ?? 0
        self.numberOfPlayers = dict["numberOfPlayers"] as? Int ?? 0
        self.location = dict["location"] as? String ?? "n/a"
        self.dateAndTime = dict["dateAndTime"] as? String ?? "n/a"
        self.league = dict["league"] as? String ?? "n/a"
        self.refereeNames = dict["refereeNames"] as? [String] ?? ["n/a"]
        self.caps = dict["capsNames"] as? [String] ?? ["n/a"]
        self.extraTime = dict["extraTime"] as? Bool ?? false
        self.homeTeam = dict["homeTeam"] as? String ?? "n/a"
        self.awayTeam = dict["awayTeam"] as? String ?? "n/a"
        self.homeScore = dict["homeScore"] as? Int ?? 0
        self.awayScore = dict["awayScore"] as? Int ?? 0
        self.totalRunningTime = dict["totalRunningTime"] as? Double ?? 0.0
        self.totalInjuryTimeGiven = dict["totalInjuryTimeGiven"] as? Double ?? 0.0
        self.subs = dict["subs"] as? Int ?? 0
        self.homePlayers = dict["homePlayers"] as? [Int] ?? [0]
        self.awayPlayers = dict["awayPlayers"] as? [Int] ?? [0]
        self.homeYellowCardPlayers = dict["homeYellowCardPlayers"] as? [Int] ?? [0]
        self.homeRedCardPlayers = dict["homeRedCardPlayers"] as? [Int] ?? [0]
        self.awayYellowCardPlayers = dict["awayYellowCardPlayers"] as? [Int] ?? [0]
        self.awayRedCardPlayers = dict["awayRedCardPlayers"] as? [Int] ?? [0]
        self.homeGoalsPlayers = dict["homeGoalsPlayers"] as? [Int] ?? [0]
        self.awayGoalsPlayers = dict["awayGoalsPlayers"] as? [Int] ?? [0]
        self.gameNotes = dict["gameNotes"] as? [String] ?? ["n/a"]
    }
}
