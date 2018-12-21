//
//  Game.swift
//  RefApp
//
//  Created by Leandro Wauters on 11/30/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit
struct Game {
    // unique vc
    static var length = [45, 30, 15, 0] // STATIC VC
    static var lengthSelected = Int()
    static var numberOfPlayers = Int()
    // TYPE INTO CELL
    static var location = String() //TYPE INTO CELL
    static var dateAndTime = Date()//OR DATE? // DATE PICKER VIEW UNIQUE VC
    static var league = [String]() //INPUT MUST BE SAVED - [String]? // TYPE INTO CELL
    static var refereeNames = [String]() // TYPE INTO CELL
    static var homeCaptain = String() //TYPE INTO CELL
    static var awayCaptain = String()
    static var extraTime = Bool() // STATIC VC YES OR NOW
    static var homeTeam = "Home"
    static var awayTeam = "Away"
    static var subs = Int()
    static var homePlayers = [Int]()
    
    
    
    //FUNCTION
    static func printValues (){
        print("Location: \(Game.location)")
        print("Number Of Players: \(Game.numberOfPlayers)")
        print("Legue: \(Game.league)")
        print("Referee \(Game.refereeNames)")
        print("Home Cap: \(Game.homeCaptain)")
        print("Away Cap: \(Game.awayCaptain)")
        print("Length: \(Game.lengthSelected)")
        print("Home Team: \(Game.homeTeam)")
        print("Away Team: \(Game.awayTeam)")
        print("Date: \(Game.dateAndTime)")
        print("Extra Time? \(Game.extraTime)")
    }
}
