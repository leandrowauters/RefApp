//
//  EventDelegate.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/13/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

protocol EventDelegate: class {
    func yellowCall(bool: Bool)
    func redCard(bool: Bool)
    func halfTime(bool: Bool)
    
}
