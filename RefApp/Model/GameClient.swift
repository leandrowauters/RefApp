//
//  GameClient.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/21/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

struct GameClient {
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
    static func doneButton(view: UIView, doneBtn: UIBarButtonItem, textField: UITextField) {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Enter Player", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
    }
}
