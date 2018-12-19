//
//  NamesInputVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/17/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class NamesInputVC: UIViewController {
    
    var buttonTapsRef = 0
    var buttonTapsCap = 0
    var selectedIndex = Int()
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var name1Label: UILabel!
    @IBOutlet weak var name2Label: UILabel!
    @IBOutlet weak var name3Label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        switch selectedIndex {
        case 0:
            nameLabel.text = "Enter Referee's Name"
        case 1:
            nameLabel.text = "Enter \(Game.homeTeam) Captain"
        default:
            print("Error")
        }
        
    }
    
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
}

extension NamesInputVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch selectedIndex {
        case 0:
            switch buttonTapsRef {
            case 0:
                Game.refereeNames.append(textField.text!)
                nameLabel.text = "Optional: Enter Assistant 1"
                name1Label.isHidden = false
                name1Label.text = "First Ref: \(textField.text!)"
                buttonTapsRef += 1
                textField.text = ""
            case 1:
                Game.refereeNames.append(textField.text!)
                name2Label.text = textField.text!
                nameLabel.text = "Optional: Enter Assistant 2"
                name2Label.isHidden = false
                name2Label.text = "Assistant Ref #1: \(textField.text!)"
                buttonTapsRef += 1
                textField.text = ""
            case 2:
                Game.refereeNames.append(textField.text!)
                name3Label.text = "Assistant Ref #2: \(textField.text!)"
                name3Label.isHidden = false
                let _: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(goBack), userInfo: nil, repeats: true)
                
            default:
                print("Error")
            }
        case 1:
            switch buttonTapsCap {
            case 0:
                Game.homeCaptain = textField.text!
                nameLabel.text = "Enter \(Game.awayTeam) Captain"
                name1Label.text = "\(Game.homeTeam) Captain: \(textField.text!)"
                name1Label.isHidden = false
                buttonTapsCap += 1
                textField.text = ""
            case 1:
                Game.awayCaptain = textField.text!
                name2Label.text = "Away \(Game.awayCaptain): \(textField.text!)"
                name2Label.isHidden = false
                let _: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(goBack), userInfo: nil, repeats: true)
                
            default:
                print("Error")
            }
        default:
            print("Error")
        }
    return true
    }
}
