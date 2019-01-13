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
        let game = GameSaveClient.getGames()[index]
        GameSaveClient.delete(game: game, atIndex: index)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func selectWasPress(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:"Are You Sure?" , message: "Once The Game Begins Settings Cannot Be Change" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
            self.present(vc, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: false)
        Game.lengthSelected = savedGame.lengthSelected
        Game.numberOfPlayers = savedGame.numberOfPlayers
        Game.location = savedGame.location
        Game.dateAndTime = savedGame.dateAndTime
        Game.league = savedGame.league
        Game.refereeNames = savedGame.refereeNames
        Game.caps = savedGame.caps
        Game.extraTime = savedGame.extraTime
        Game.homeTeam = savedGame.homeTeam
        Game.awayTeam = savedGame.awayTeam
        Game.numberOfSubs = savedGame.subs
        Game.homePlayers = savedGame.homePlayers
        Game.awayPlayers = savedGame.awayPlayers
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
