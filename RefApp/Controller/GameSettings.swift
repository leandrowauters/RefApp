//
//  GameSettings.swift
//  RefApp
//
//  Created by Leandro Wauters on 11/30/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class GameSettings: UITableViewController {

    
    @IBOutlet weak var teamSelectionLabel: UILabel!
    @IBOutlet weak var gameLenghtLabel: UILabel!
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet weak var numberOfSubsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var extraTimeLabel: UILabel!
    @IBOutlet var myTableView: UITableView!

    @IBOutlet var labelArrays: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        GameSaveClient.savedGames = GameSaveClient.retriveGame()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        numberOfSubsLabel.text = "None"
        myTableView.backgroundColor = #colorLiteral(red: 0.5987986922, green: 0.7483736873, blue: 0.8878619075, alpha: 1)
        numberOfPlayersLabel.adjustsFontSizeToFitWidth = true
        GameClient.printValues()
//        GameSaveClient.printAllDefaults()
    }

    override func viewDidAppear(_ animated: Bool) {
        GameClient.printValues()
    }
    
    @objc func saveTapped(){
        GameSaveClient.alert(vc: self)
    }
    @IBAction func extraTimeSwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            Game.extraTime = true
            extraTimeLabel.text = "Yes"
        } else {
            Game.extraTime = false
            extraTimeLabel.text = "No"
        }
    }
    
    @IBAction func subsStepperPressed(_ sender: UIStepper) {
        numberOfSubsLabel.isHidden = false
        let stepperValue = Int(sender.value)
        func updateValue(){
            Game.subs = stepperValue
            numberOfSubsLabel.text = stepperValue.description
        }
        switch sender.value {
        case 0:
            Game.subs = stepperValue
            numberOfSubsLabel.text = "None"
        case 1...6:
            updateValue()
        case sender.maximumValue:
            Game.subs = 7
            numberOfSubsLabel.text = "∞"
        default:
            print("Error subsStepperPresssed")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Game Options"
        case 1:
            return "Game Details"
        case 2:
            return "Extras"
        default:
            return "Error"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "teamSelection":
            guard let destination = segue.destination as? TeamsInputVC else {return}
            destination.gameDegelate = self
        case "numberOfPlayers":
            guard let destination = segue.destination as? TextVC else {return}
            destination.myString = "Number Of Players Per Team: "
            destination.selectedIndexPath = 2
            destination.gameDegelate = self
        case "location":
            guard let destination = segue.destination as? TextVC else {return}
            destination.myString = "Enter Location:"
            destination.selectedIndexPath = 4
            destination.gameDegelate = self
        case "date":
            guard let destination = segue.destination as? DatePickerVC else {return}
            destination.gameDegelate = self
        case "leagueName":
            guard let destination = segue.destination as? TextVC else {return}
            destination.myString = "Enter League:"
            destination.selectedIndexPath = 6
            destination.gameDegelate = self
        case "gameLength":
            guard let destination = segue.destination as? GameLengthVC else {return}
            destination.gameDelegate = self
        case "ref":
            guard let destination = segue.destination as? NamesInputVC else {return}
            destination.selectedIndex = 0
        case "cap":
            guard let destination = segue.destination as? NamesInputVC else {return}
            destination.selectedIndex = 1
        default:
            print("Error4")
        }
    }
}
extension GameSettings: GameDelegate {
    func dateLabelChange(to date: String) {
        dateTimeLabel.text = date
    }
    
    func teamsLabelChange(to selected: String) {
        teamSelectionLabel.text = "Selected"
    }
    
    
    func gameLengthChange(to lenght: Int) {
        gameLenghtLabel.text = "\(lenght) minutes"
    }
    
    func leagueDidChange(to league: String) {
        leagueNameLabel.text = league.capitalized
    }
    
    func locationDidChange(to location: String) {
        locationLabel.text = location.capitalized
    }
    
    func numberOfPlayersDidChange(to numberOfPlayers: Int) {
        numberOfPlayersLabel.text = "\(numberOfPlayers) vs. \(numberOfPlayers)"
    }
}


