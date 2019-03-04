//
//  CountryFlag.swift
//  RefApp
//
//  Created by Leandro Wauters on 3/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

struct Country: Codable {
    let alpha2Code: String
}
struct CountryFlag: Codable {
    let Response: [ResponseWrapper]
    struct ResponseWrapper: Codable {
        let FlagPng: String
    }
    
}

