//
//  TeamSelectionViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/2/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class TeamSelectionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var homeTeamTextField: UITextField!
    
    @IBOutlet weak var awayTeamTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: GameDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTeamTextField.delegate = self
        awayTeamTextField.delegate = self
        setupUI()
        
    }
    
    func setupUI() {
        homeTeamTextField.layer.borderWidth = 2
        homeTeamTextField.layer.borderColor = UIColor.white.cgColor
        homeTeamTextField.layer.cornerRadius = 10
        homeTeamTextField.text = Game.homeTeam
        awayTeamTextField.layer.borderWidth = 2
        awayTeamTextField.layer.borderColor = UIColor.white.cgColor
        awayTeamTextField.layer.cornerRadius = 10
        awayTeamTextField.text = Game.awayTeam
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = UIColor.white.cgColor
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
        doneButton.layer.masksToBounds = true
    }
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == homeTeamTextField || textField == awayTeamTextField {
            textField.text = ""
        }
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if (homeTeamTextField.text != "" && homeTeamTextField.text != "Home") && (awayTeamTextField.text != "" && awayTeamTextField.text != "Away") {
            if let team = homeTeamTextField.text {
                Game.homeTeam = team
            }
            if let team = awayTeamTextField.text {
                Game.awayTeam = team
            }
            delegate.teamsLabelChange(to: "Selected")
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Please Select Two Team", message: nil, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == homeTeamTextField {
            awayTeamTextField.becomeFirstResponder()
        }
        if textField == awayTeamTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
