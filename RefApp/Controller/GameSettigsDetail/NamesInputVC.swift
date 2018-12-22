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
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var nameLabels: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        switch selectedIndex {
        case 0:
            titleLabel.text = "Enter Referee's Name"
        case 1:
            titleLabel.text = "Enter \(Game.homeTeam) Captain"
        default:
            print("Error")
        }
        
    }
    
//    @objc func goBack(){
//        navigationController?.popViewController(animated: true)
//    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
}

extension NamesInputVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        buttonTapsRef += 1
        let nameLabel = nameLabels[buttonTapsRef]
        guard let text = textField.text else {return false}
        func helper(title: String, refName: String){
            Game.refereeNames.append(textField.text!)
            nameLabel.isHidden = false
            titleLabel.text = title
            nameLabel.text = refName
        }

        switch selectedIndex {
        case 0:
            switch buttonTapsRef {
            case 1:
                helper(title: "Enter Assistant 1 (Optional)", refName: "First Ref: \(text.capitalized)")
            case 2:
                helper(title: "Enter Assistant 2 (Optional)", refName: "Assistant Ref #1: \(text.capitalized)")
            case 3:
                helper(title: "Enter Fourth Official (Optional)", refName: "Assistant Ref #2: \(text.capitalized)")
            case 4:
                helper(title: "Enter Assistant 3 (Optional)", refName: "Fourth Official: \(text.capitalized)")
            case 5:
                helper(title: "Enter Assistant 4 (Optional)", refName: "Fourth Official: \(text.capitalized)")
                view.endEditing(true)
                nameTextField.isEnabled = false
                
//                let _: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(goBack), userInfo: nil, repeats: true)
                
            default:
                print("Error")
            }
        case 1:
            switch buttonTapsCap {
            case 0:
                Game.homeCaptain = textField.text!
                nameLabel.text = "Enter \(Game.awayTeam) Captain"
                nameLabel.text = "\(Game.homeTeam) Captain: \(textField.text!)"
                nameLabel.isHidden = false
                buttonTapsCap += 1
                textField.text = ""
            case 1:
                Game.awayCaptain = textField.text!
                nameLabel.text = "Away \(Game.awayCaptain): \(textField.text!)"
                nameLabel.isHidden = false
//                let _: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(goBack), userInfo: nil, repeats: true)
                
            default:
                print("Error")
            }
        default:
            print("Error")
        }
    textField.text = ""
    return true
    }
}
