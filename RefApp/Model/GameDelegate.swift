//
//  GameDelegate.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/5/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import Foundation

protocol GameDelegate: AnyObject {
    func numberOfPlayersDidChange(to numberOfPlayers: Int)
    func locationDidChange(to location: String)
    func leagueDidChange(to league: String)
    func gameLengthChange(to lenght: Int)
    func teamsLabelChange(to selected: String)
    func dateLabelChange(to date: String)
    func refereeNameChange(to selected: String)
    func capsNameChanged(to selected: String)
}

protocol GameLengthDelegate: AnyObject {
    func gameLengthChange(to lenght: Int)
}


