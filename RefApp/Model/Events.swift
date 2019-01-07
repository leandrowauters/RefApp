//
//  Incidents.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/2/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

struct Events {
    var type: String
    var playerNum: Int
    var team: String
    var half: Int
    var subIn: Int?
    var timeStamp: String
    
}
enum TypeOfIncident: String {
    case goal = "Goal"
    case sub = "Sub"
    case yellowCard = "Yellow Card"
    case redCard = "Red Card"
}
