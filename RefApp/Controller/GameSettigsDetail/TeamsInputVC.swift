//
//  TeamsInputVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/2/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class TeamsInputVC: UIViewController {
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var numberOfClicks = 0
    var homeTeam = ""
    var awayTeam = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        team1Label.text = "Home"
        team2Label.text = "Away"
        teamTextField.delegate = self
        teamTextField.placeholder = "Please Enter Home Team Name"
    }
 
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        Game.homeTeam = homeTeam
        Game.awayTeam = awayTeam
        navigationController?.popViewController(animated: true)
    }
    

}

extension TeamsInputVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        numberOfClicks += 1
        switch numberOfClicks{
        case 1:
            textField.placeholder = "Please Enter Away Team Name"
            team1Label.text = textField.text
            homeTeam = textField.text!
            textField.text = ""
            textField.resignFirstResponder()
        case 2:

            team2Label.text = textField.text
            awayTeam = textField.text!
            textField.text = ""
            textField.resignFirstResponder()
            doneButton.isHidden = !doneButton.isHidden
        default:
            print("Error in Number Of Clicks")
            
        }
        return true
    }

}
