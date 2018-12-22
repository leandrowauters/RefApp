//
//  TeamsInputVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/2/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class TeamsInputVC: UIViewController {
    
    weak var gameDegelate: GameDelegate?
    
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
//    override func viewDidAppear(_ animated: Bool) {
//        team1Label.text = Game.homeTeam
//        team2Label.text = Game.awayTeam
//        teamTextField.delegate = self
//        teamTextField.placeholder = "Please Enter Home Team Name"
//    }
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }

}

extension TeamsInputVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        numberOfClicks += 1
        switch numberOfClicks{
        case 1:
            guard let text = textField.text else {return false}
            team1Label.text = text.capitalized
            Game.homeTeam = text
            textField.text = ""
            textField.placeholder = "Please Enter Away Team Name"
            textField.resignFirstResponder()
        case 2:
            guard let text = textField.text else {return false}
            team2Label.text = text.capitalized
            Game.awayTeam = text
            textField.text = ""
            gameDegelate?.teamsLabelChange(to: "Selected")
            textField.resignFirstResponder()
            let _: Timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(goBack), userInfo: nil, repeats: true)

        default:
            print("Error in Number Of Clicks")
            
        }
        return true
    }

}
