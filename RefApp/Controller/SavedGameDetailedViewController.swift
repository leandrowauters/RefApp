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
    override func viewDidLoad() {
        super.viewDidLoad()
        print(savedGame.lengthSelected)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteWasPressed(_ sender: UIBarButtonItem) {
        if UserSession.loginStatus == .existingAccount {
            DatabaseManager.deleteSavedGameFromDatabase(vc: self, gameToDelete: savedGame)
            navigationController?.popViewController(animated: true)
        }else{
        let game = DataPeristanceModel.getGames()[index]
        DataPeristanceModel.deleteGame(game: game, atIndex: index)
        navigationController?.popViewController(animated: true)
    }
    }
    @IBAction func selectWasPress(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:"Are You Sure?" , message: "Once The Game Begins Settings Cannot Be Change" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
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
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
            self.present(vc, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: false)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
