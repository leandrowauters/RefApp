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
    
    var numberOfClicks = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        team1Label.text = Game.homeTeam
        team2Label.text = Game.awayTeam
        teamTextField.delegate = self
        teamTextField.placeholder = "Please Enter Home Team Name"
    }
    override func viewWillAppear(_ animated: Bool) {
        team1Label.text = Game.homeTeam
        team2Label.text = Game.awayTeam
        teamTextField.delegate = self
        teamTextField.placeholder = "Please Enter Home Team Name"
    
    }
    override func viewDidAppear(_ animated: Bool) {
        team1Label.text = Game.homeTeam
        team2Label.text = Game.awayTeam
        teamTextField.delegate = self
        teamTextField.placeholder = "Please Enter Home Team Name"
    }
    @objc func goBack(){
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
            Game.homeTeam = textField.text!
            textField.text = ""
            textField.resignFirstResponder()
        case 2:
            team2Label.text = textField.text
            Game.awayTeam = textField.text!
            textField.text = ""
            let _: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(goBack), userInfo: nil, repeats: true)

        default:
            print("Error in Number Of Clicks")
            
        }
        return true
    }

}
