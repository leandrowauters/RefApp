//
//  Settings.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/22/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

class Settings: Codable {

    var userID: String?
    var duration: Int?
    var numberOfPlayers: Int?
    var subsPerTeam: Int?
    var leagueName: String?
    
    init() {}
    
    init(userID: String?,duration: Int?,numberOfPlayers: Int?, subsPerTeam: Int?, leagueName: String?) {
        self.userID = userID
        self.duration = duration
        self.numberOfPlayers = numberOfPlayers
        self.subsPerTeam = subsPerTeam
        self.leagueName = leagueName
    }
    
    func printSettings(){
        print("""
            Duration: \(duration ?? 0)
            Number Of Players: \(numberOfPlayers ?? 0)
            SubsPerTeam: \(numberOfPlayers ?? 0)
            league Name: \(leagueName ?? "No League")
            """)
        
    }
    
}
