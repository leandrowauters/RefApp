//
//  GameData.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/22/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

class GameData {
    var gameName: String
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
    var substitutionsMade: [(In: String, Out: String)]
    var events: [Events]
    
    init(gameName: String, lengthSelected:Int, numberOfPlayers: Int, location: String, dateAndTime: String, league: String, refereeNames: [String], caps: [String], extraTime: Bool, homeTeam: String, awayTeam: String, subs: Int, homePlayers: [Int], awayPlayers: [Int],homeYellowCardPlayers: [Int],homeRedCardPlayers: [Int],awayYellowCardPlayers: [Int], awayRedCardPlayers:[Int], homeGoalsPlayers: [Int], awayGoalsPlayers: [Int], gameNotes: [String], substitutionsMade: [(In: String, Out: String)], events: [Events]) {
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
        self.substitutionsMade = substitutionsMade
        self.events = events
        
    }
}
