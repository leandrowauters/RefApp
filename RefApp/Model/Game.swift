//
//  Game.swift
//  RefApp
//
//  Created by Leandro Wauters on 11/30/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit
class Game: Codable {
    
    enum Teams{
        case home
        case away
    }
    static var gameName: String?
    // unique vc
    static var length = [90, 60, 30, 0] // STATIC VC
    static var lengthSelected = Int()
    // TYPE INTO CELL
    static var numberOfPlayers = Int()
    static var location = String() //TYPE INTO CELL
    static var dateAndTime = String()//OR DATE? // DATE PICKER VIEW UNIQUE VC
    static var league = String() //INPUT MUST BE SAVED - [String]? // TYPE INTO CELL
    static var refereeNames = [String]() // TYPE INTO CELL
    static var caps = [String]()
    static var extraTime = Bool() // STATIC VC YES OR NOW
    static var homeTeam = "Home"
    static var awayTeam = "Away"
    static var numberOfSubs = Int()
    static var homePlayers = [Int]()
//    static var homePlayersSorted = Game.homePlayers.sorted{$0 < $1}
    static var awayPlayers = [Int]()
//    static var awayPlayersSorted = Game.awayPlayers.sorted{$0 < $1}
    static var homeYellowCardPlayers = [Int]()
    static var homeRedCardPlayers = [Int]()
    static var awayYellowCardPlayers = [Int]()
    static var awayRedCardPlayers = [Int]()
    static var homeGoalsPlayers = [Int]()
    static var awayGoalsPlayers = [Int]()
    static var homeScore = Int()
    static var awayScore = Int()
    static var events = [Events]()
    static var gameHalf = 1
    static var gameNotes = [String]()
    static var subtitutions = [(In: String, Out: String)]()
    static var totalRunningTime = 0
    
    
    
    var gameName: String?
    var userID: String
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
    var dbReferenceDocumentId: String
    init(userID: String,gameName: String?, lengthSelected:Int, numberOfPlayers: Int, location: String, dateAndTime: String, league: String, refereeNames: [String], caps: [String], extraTime: Bool, homeTeam: String, awayTeam: String, subs: Int, homePlayers: [Int], awayPlayers: [Int], dbReferenceDocumentId: String) {
        self.userID = userID
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
        self.dbReferenceDocumentId = dbReferenceDocumentId
    }
    init(dict: [String: Any]){
        self.userID = dict["userID"] as? String ?? "noUser"
        self.gameName = dict["gameName"] as? String ?? "n/a"
        self.lengthSelected = dict["gameLength"] as? Int ?? 0
        self.numberOfPlayers = dict["numberOfPlayers"] as? Int ?? 0
        self.location = dict["location"] as? String ?? "n/a"
        self.dateAndTime = dict["dateAndTime"] as? String ?? "n/a"
        self.league = dict["league"] as? String ?? "n/a"
        self.refereeNames = dict["refereeNames"] as? [String] ?? ["n/a"]
        self.caps = dict["caps"] as? [String] ?? ["n/a"]
        self.extraTime = dict["extraTime"] as? Bool ?? false
        self.homeTeam = dict["homeTeam"] as? String ?? "n/a"
        self.awayTeam = dict["awayTeam"] as? String ?? "n/a"
        self.subs = dict["subs"] as? Int ?? 0
        self.homePlayers = dict["homePlayers"] as? [Int] ?? [0]
        self.awayPlayers = dict["awayPlayers"] as? [Int] ?? [0]
        self.dbReferenceDocumentId = dict["dbReference"] as? String ?? "no dbReference"  
    }
    static func setVariableToDefaultValues() {
        Game.gameName = nil
        // unique vc
        Game.length = [90, 60, 30, 0] // STATIC VC
        Game.lengthSelected = Int()
        // TYPE INTO CELL
        Game.numberOfPlayers = Int()
        Game.location = String() //TYPE INTO CELL
        Game.dateAndTime = String()//OR DATE? // DATE PICKER VIEW UNIQUE VC
        Game.league = String() //INPUT MUST BE SAVED - [String]? // TYPE INTO CELL
        Game.refereeNames = [String]() // TYPE INTO CELL
        Game.caps = [String]()
        Game.extraTime = Bool() // STATIC VC YES OR NOW
        Game.homeTeam = "Home"
        Game.awayTeam = "Away"
        Game.numberOfSubs = Int()
        Game.homePlayers = [Int]()
        //    static var homePlayersSorted = Game.homePlayers.sorted{$0 < $1}
        Game.awayPlayers = [Int]()
        //    static var awayPlayersSorted = Game.awayPlayers.sorted{$0 < $1}
        Game.homeYellowCardPlayers = [Int]()
        Game.homeRedCardPlayers = [Int]()
        Game.awayYellowCardPlayers = [Int]()
        Game.awayRedCardPlayers = [Int]()
        Game.homeGoalsPlayers = [Int]()
        Game.awayGoalsPlayers = [Int]()
        Game.homeScore = Int()
        Game.awayScore = Int()
        Game.events = [Events]()
        Game.gameHalf = 1
        Game.gameNotes = [String]()
        Game.subtitutions = [(In: String, Out: String)]()
        Game.totalRunningTime = 0
    }
    
}

