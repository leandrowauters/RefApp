//
//  EventDelegate.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/13/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

protocol EventDelegate: AnyObject {
    func yellowCall(bool: Bool, home: Bool?)
    func redCard(bool: Bool, home: Bool?)
    func halfTime(bool: Bool)
    func playerSelected(player: String)
    func activateViewDidAppear(bool: Bool)
    func substitution(playerIn: String, playerOut: String, home: Bool,index: Int)
    func subWasMade(bool: Bool)
}
