//
//  GameSettings.swift
//  RefApp
//
//  Created by Leandro Wauters on 11/30/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class GameSettings: UITableViewController {

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
        numberOfSubsLabel.text = "None"
        myTableView.backgroundColor = #colorLiteral(red: 0.5987986922, green: 0.7483736873, blue: 0.8878619075, alpha: 1)
        numberOfPlayersLabel.adjustsFontSizeToFitWidth = true
        printValues()
    }
    func printValues (){
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
    override func viewDidAppear(_ animated: Bool) {
        printValues()
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
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
    
    func gameLengthChange(to lenght: Int) {
        gameLenghtLabel.text = "\(lenght) minutes"
    }
    
    func leagueDidChange(to league: String) {
        leagueNameLabel.text = league
    }
    
    func locationDidChange(to location: String) {
        locationLabel.text = location
    }
    
    func numberOfPlayersDidChange(to numberOfPlayers: Int) {
        numberOfPlayersLabel.text = "\(numberOfPlayers) vs. \(numberOfPlayers)"
    }
}


