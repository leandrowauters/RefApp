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
        default:
            print("Error4")
        }
    }
}
extension GameSettings: GameDelegate {
    func customGameLenghtChage(to lenght: Int) {
        gameLenghtLabel.text = "\(lenght) minutes"
    }
    
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


