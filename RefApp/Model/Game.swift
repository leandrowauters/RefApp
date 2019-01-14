//
//  Game.swift
//  RefApp
//
//  Created by Leandro Wauters on 11/30/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit
class Game: Codable {
    // unique vc
    static var length = [90, 60, 30, 0] // STATIC VC
    static var lengthSelected = Int()
    // TYPE INTO CELL
    static var numberOfPlayers = Int()
    static var location = String() //TYPE INTO CELL
    static var dateAndTime = String()//OR DATE? // DATE PICKER VIEW UNIQUE VC
    static var league = [String]() //INPUT MUST BE SAVED - [String]? // TYPE INTO CELL
    static var refereeNames = [String]() // TYPE INTO CELL
    static var caps = [String]()
    static var extraTime = Bool() // STATIC VC YES OR NOW
    static var homeTeam = "Home"
    static var awayTeam = "Away"
    static var numberOfSubs = Int()
    static var homePlayers = [Int]()
    static var homePlayersSorted = Game.homePlayers.sorted{$0 < $1}
    static var awayPlayers = [Int]()
    static var awayPlayersSorted = Game.awayPlayers.sorted{$0 < $1}
    static var homeYellowCardPlayers = [Int]()
    static var homeRedCardPlayers = [Int]()
    static var homeGoalsPlayers = [Int]()
    static var awayYellowCardPlayers = [Int]()
    static var awayRedCardPlayers = [Int]()
    static var awayGoalsPlayers = [Int]()
    static var homeScore = Int()
    static var awayScore = Int()
    static var events = [Events]()
    static var gameHalf = 1
    
    var gameName = String()
    var lengthSelected = Game.lengthSelected
    var numberOfPlayers = Game.numberOfPlayers
    var location = Game.location
    var dateAndTime = Game.dateAndTime
    var league = Game.league
    var refereeNames = Game.refereeNames
    var caps = Game.caps
    var extraTime = Game.extraTime
    var homeTeam = Game.homeTeam
    var awayTeam = Game.awayTeam
    var subs = Game.numberOfSubs
    var homePlayers = Game.homePlayers
    var awayPlayers = Game.awayPlayers
    
    init(gameName: String, lengthSelected:Int, numberOfPlayers: Int, location: String, dateAndTime: String, league: [String], refereeNames: [String], caps: [String], extraTime: Bool, homeTeam: String, awayTeam: String, subs: Int, homePlayers: [Int], awayPlayers: [Int]) {
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
        
    }
    
    
    //FUNCTION
}
