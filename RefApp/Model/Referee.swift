//
//  Referee.swift
//  RefApp
//
//  Created by Leandro Wauters on 3/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

struct Referee {
    let displayName: String?
    let country: String?
    let imageURL: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    
    init(dict: [String: Any]) {
        self.displayName = dict["displayName"] as? String ?? "no name"
        self.country = dict["country"] as? String ?? ""
        self.imageURL = dict["imageURL"] as? String ?? "no imageURL"
        self.email = dict["email"] as? String ?? "no email"
        self.firstName = dict["firstName"] as? String ?? "no first name"
        self.lastName = dict["lastName"] as? String ?? "no last name"

    }
}
