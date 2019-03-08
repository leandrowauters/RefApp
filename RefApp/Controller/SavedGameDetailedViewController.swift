//
//  SavedGameDetailedViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/8/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit


class SavedGameDetailedViewController: UIViewController {
    
    var savedGame: Game!
    var index = Int()
    var gameClient = GameClient()
    var graphics = GraphicClient()
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameSubtitleLabel: UILabel!
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet weak var gameLengthLabel: UILabel!
    @IBOutlet weak var subsPerTeamLabel: UILabel!
    @IBOutlet weak var extraTimeLabel: UILabel!
    @IBOutlet weak var refereeNamesLabels: UILabel!
    @IBOutlet weak var captainNamesLabel: UILabel!
    @IBOutlet weak var homePlayersLabel: UILabel!
    @IBOutlet weak var awayPlayerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(savedGame.lengthSelected)
        title = "Game Details"
        setupLabels()
    }
    
    
    func setupLabels(){
        gameTitleLabel.text = "\(savedGame.homeTeam) vs. \(savedGame.awayTeam)"
        gameSubtitleLabel.text = "\(savedGame.location) - \(savedGame.dateAndTime)"
        numberOfPlayersLabel.attributedText = graphics.attributedText(wordsToBold: "Number of players per team:", string: "Number of players per team: \(savedGame.numberOfPlayers) players", fontSize: 17)
        numberOfPlayersLabel.text = "Number of players per team: \(savedGame.numberOfPlayers) players"
        
        gameLengthLabel.attributedText = graphics.attributedText(wordsToBold: "Duration", string: "Duration: \(savedGame.lengthSelected) minutes", fontSize: 17)
        
        subsPerTeamLabel.attributedText = graphics.attributedText(wordsToBold: "Subs allowed:", string: "Subs allowed: \(savedGame.subs)", fontSize: 17)
        homePlayersLabel.attributedText = graphics.attributedText(wordsToBold: "\(savedGame.homeTeam) players:", string: "\(savedGame.homeTeam) players: \(gameClient.convertIntArrayToString(array: savedGame.homePlayers) ?? "N/A")", fontSize: 17)
        awayPlayerLabel.attributedText = graphics.attributedText(wordsToBold: "\(savedGame.awayTeam) players:", string: "\(savedGame.awayTeam) players: \(gameClient.convertIntArrayToString(array: savedGame.awayPlayers) ?? "N/A")", fontSize: 17)
        refereeNamesLabels.attributedText = graphics.attributedText(wordsToBold: "Referees:", string: "Referees: \(gameClient.convertStringArrayToString(array: savedGame.refereeNames) ?? "N/A")", fontSize: 17)
        captainNamesLabel.attributedText = graphics.attributedText(wordsToBold: "Captains:", string: "Captains: \(gameClient.convertStringArrayToString(array: savedGame.caps) ?? "N/A")", fontSize: 17)
        extraTimeLabel.attributedText = graphics.attributedText(wordsToBold: "Extra time:", string: "Extra time: \(gameClient.checkForExtraTime(bool: savedGame.extraTime))", fontSize: 17)
    }
    @IBAction func deleteWasPressed(_ sender: UIBarButtonItem) {
        showSheetAlert(title: "Select option", message: nil) { (UIAlertController) in
            let edit = UIAlertAction(title: "Edit", style: .default
                , handler: { (action) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let gameSettings = storyboard.instantiateViewController(withIdentifier: "gameSettings") as? GameSettings else {return}
                    gameSettings.intention = .edit
                    self.assingSaveGameValues()
                    gameSettings.game = self.savedGame
                    self.navigationController?.pushViewController(gameSettings, animated: true)
            })
            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                if UserSession.loginStatus == .existingAccount {
                    DatabaseManager.deleteSavedGameFromDatabase(vc: self, gameToDelete: self.savedGame)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    let game = DataPeristanceModel.getGames()[self.index]
                    DataPeristanceModel.deleteGame(game: game, atIndex: self.index)
                    self.navigationController?.popViewController(animated: true)
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            UIAlertController.addAction(edit)
            UIAlertController.addAction(delete)
            UIAlertController.addAction(cancel)
            self.present(UIAlertController, animated: true, completion: nil)
            
            }
    }
    @IBAction func selectWasPress(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:"Are You Sure?" , message: "Once The Game Begins Settings Cannot Be Change" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
            self.assingSaveGameValues()
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
            self.present(vc, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: false)

    }
    func assingSaveGameValues(){
        Game.gameName = self.savedGame.gameName
        Game.lengthSelected = self.savedGame.lengthSelected
        Game.numberOfPlayers = self.savedGame.numberOfPlayers
        Game.location = self.savedGame.location
        Game.dateAndTime = self.savedGame.dateAndTime
        Game.league = self.savedGame.league
        Game.refereeNames = self.savedGame.refereeNames
        Game.caps = self.savedGame.caps
        Game.extraTime = self.savedGame.extraTime
        Game.homeTeam = self.savedGame.homeTeam
        Game.awayTeam = self.savedGame.awayTeam
        Game.numberOfSubs = self.savedGame.subs
        Game.homePlayers = self.savedGame.homePlayers
        Game.awayPlayers = self.savedGame.awayPlayers
    }
}
