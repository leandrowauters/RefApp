//
//  GameDelegate.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/5/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import Foundation

protocol GameDelegate: class {
    func numberOfPlayersDidChange(to numberOfPlayers: Int)
    func locationDidChange(to location: String)
    func leagueDidChange(to league: String)
    func gameLengthChange(to lenght: Int)
    func teamsLabelChange(to selected: String)
    func dateLabelChange(to date: String)
}

protocol GameLengthDelegate: class {
    func gameLengthChange(to lenght: Int)
}

