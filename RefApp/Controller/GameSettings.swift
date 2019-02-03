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
    
    @IBOutlet weak var refereeNamesLabel: UILabel!
    @IBOutlet weak var capsNamesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        GameSaveClient.savedGames = GameSaveClient.retriveGame()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        numberOfSubsLabel.text = "None"
        title = "Game Settings"
        myTableView.backgroundColor = #colorLiteral(red: 0.2737779021, green: 0.4506875277, blue: 0.6578510404, alpha: 1)
        numberOfPlayersLabel.adjustsFontSizeToFitWidth = true
        GameClient.printValues()
//        GameSaveClient.printAllDefaults()
//        GameSaveClient.printAllDefaults()
    }

    override func viewDidAppear(_ animated: Bool) {
        GameClient.printValues()
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
    
    @IBAction func nextButtonWasPressed(_ sender: UIButton) {
        if Game.lengthSelected == 0 && Game.numberOfPlayers == 0 {
            let alert = UIAlertController(title: "Please select a duration and number of players", message: nil, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func subsStepperPressed(_ sender: UIStepper) {
        numberOfSubsLabel.isHidden = false
        let stepperValue = Int(sender.value)
        func updateValue(){
            Game.numberOfSubs = stepperValue
            numberOfSubsLabel.text = stepperValue.description
        }
        switch sender.value {
        case 0:
            Game.numberOfSubs = stepperValue
            numberOfSubsLabel.text = "None"
        case 1...6:
            updateValue()
        case sender.maximumValue:
            Game.numberOfSubs = 7
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
            guard let destination = segue.destination as? TeamSelectionViewController else {return}
            destination.delegate = self
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
            destination.gameDelegate = self
        case "cap":
            guard let destination = segue.destination as? NamesInputVC else {return}
            destination.selectedIndex = 1
            destination.gameDelegate = self
        default:
            print("Error4")
        }
    }
}
extension GameSettings: GameDelegate {
    func capsNameChanged(to selected: String) {
        capsNamesLabel.text = "Selected"
    }
    
    func refereeNameChange(to selected: String) {
        refereeNamesLabel.text = "Selected"
    }
    
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


