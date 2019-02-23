//
//  UserDefaultManager.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/22/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

struct UserDefaultManager {
    private static var usersession: UserSession = (UIApplication.shared.delegate as! AppDelegate).usersession

    static var duration = "duration"
    static var numberOfPlayers = "numberOfPlayers"
    static var subPerTeam = "subsPerTeam"
    static var league = "league"
    static var index = "index"
    static var noUser = "noUser"
    static var defaultDuration = Bool()
    static var defaultNumberOfPlayers = Bool()
    static var defaultSubPerTeam = Bool()
    static var defaultLeague = Bool()
    static func loadUserDefault() {
        if let user = usersession.getCurrentUser() {
            if let duration = UserDefaults.standard.object(forKey: user.uid + duration) as? Int {
                Game.lengthSelected = duration
                defaultDuration = true
            }
            if let numberOfPlayer = UserDefaults.standard.object(forKey: user.uid + numberOfPlayers) as? Int {
                Game.numberOfPlayers = numberOfPlayer
                defaultNumberOfPlayers = true
            }
            if let subPerTeam = UserDefaults.standard.object(forKey: user.uid + subPerTeam) as? Int {
                Game.numberOfSubs = subPerTeam
                defaultSubPerTeam = true
            }
            if let league = UserDefaults.standard.object(forKey: user.uid + league) as? String {
                Game.league = league
                defaultLeague = true
            }
        }
    }
}
