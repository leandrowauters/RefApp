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
    @IBOutlet weak var extraTimeSwitch: UISwitch!
    
    @IBOutlet var labelArrays: [UILabel]!
    
    @IBOutlet weak var refereeNamesLabel: UILabel!
    @IBOutlet weak var capsNamesLabel: UILabel!
    
    @IBOutlet var StaticCellLabels: [UILabel]!
    private var usersession: UserSession?
    var intention: Intention?
    var game: Game!
    var graphics = GraphicClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
//        GameSaveClient.savedGames = GameSaveClient.retriveGame()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        numberOfSubsLabel.text = "None"
        title = "Game Settings"
        myTableView.backgroundColor = #colorLiteral(red: 0.1726308763, green: 0.1726359427, blue: 0.1726332307, alpha: 1)
        myTableView.dataSource = self
//        numberOfPlayersLabel.adjustsFontSizeToFitWidth = true
        GameClient.printValues()
        setupLabels()
//        GameSaveClient.printAllDefaults()
//        GameSaveClient.printAllDefaults()
    }

    override func viewDidAppear(_ animated: Bool) {
        GameClient.printValues()
    }

    
    func setupLabels () {
        for label in StaticCellLabels {
            label.textColor = .white
        }
        
        if intention == .edit{
            teamSelectionLabel.text = "Selected"
            gameLenghtLabel.text = "\(game!.lengthSelected) minutes"
            numberOfPlayersLabel.text = "\(game!.numberOfPlayers) vs. \(game!.numberOfPlayers)"
            numberOfSubsLabel.text = game!.subs.description
            locationLabel.text = game?.location
            dateTimeLabel.text = game?.dateAndTime
            leagueNameLabel.text = game?.league
            if game!.extraTime{
                extraTimeSwitch.isOn = true
            } else {
                extraTimeSwitch.isOn = false
            }
            
        }
        if UserDefaultManager.defaultDuration {
            gameLenghtLabel.text = "\(Game.lengthSelected) minutes"
        }
        if UserDefaultManager.defaultNumberOfPlayers{
            numberOfPlayersLabel.text = "\(Game.numberOfPlayers) vs. \(Game.numberOfPlayers)"
        }
        if UserDefaultManager.defaultSubPerTeam {
            numberOfSubsLabel.text = Game.numberOfSubs.description
        }
        if UserDefaultManager.defaultLeague {
            leagueNameLabel.text = "Selected"
        }
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
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
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
        if let user = usersession?.getCurrentUser() {
            UserDefaults.standard.set(stepperValue, forKey: user.uid + UserDefaultManager.subPerTeam)
        }
        
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
        case "next":
            guard let destination = segue.destination as? HomePlayersSelectionViewController else {return}
            if intention == .edit{
                destination.intention = .edit
                destination.game = game
            }
        case "teamSelection":
            guard let destination = segue.destination as? TeamSelectionViewController else {return}
            destination.delegate = self
            if intention == .edit{
                destination.intention = .edit
                destination.homeTeam = game.homeTeam
                destination.awayTeam = game.awayTeam
            }
        case "numberOfPlayers":
            guard let destination = segue.destination as? TextVC else {return}
            destination.myString = "Number Of Players Per Team: "
            destination.selectedIndexPath = 2
            destination.gameDegelate = self
            if intention == .edit {
                destination.selectedOption = game.numberOfPlayers.description
                destination.intention = .edit
            }
        case "location":
            guard let destination = segue.destination as? TextVC else {return}
            destination.myString = "Enter Location:"
            destination.selectedIndexPath = 4
            destination.gameDegelate = self
            if intention == .edit {
                destination.selectedOption = game.location
                destination.intention = .edit
            }
        case "date":
            guard let destination = segue.destination as? DatePickerVC else {return}
            destination.gameDegelate = self

        case "leagueName":
            guard let destination = segue.destination as? TextVC else {return}
            destination.myString = "Enter League:"
            destination.selectedIndexPath = 6
            destination.gameDegelate = self
            if intention == .edit {
                destination.selectedOption = game.league
                destination.intention = .edit
            }
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
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 45))
        headerView.backgroundColor = #colorLiteral(red: 0.1374986172, green: 0.1366885006, blue: 0.1381260157, alpha: 1)
        let headerLabel = UILabel(frame: CGRect(x: 30, y: 5, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = graphics.getHiraginoSansFont(W3: false, size: 19)
        headerLabel.textColor = UIColor.white
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        return headerView
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



