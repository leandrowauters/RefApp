//
//  SavedGamesViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/7/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class SavedGamesViewController: UIViewController {
    let loadedGames = GameSaveClient.getGames()
    
    @IBOutlet weak var savedGamesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        savedGamesTableView.dataSource = self
        savedGamesTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = savedGamesTableView.indexPathForSelectedRow,
            let savedGameDetail = segue.destination as? SavedGameDetailedViewController else {return}
        let game = loadedGames[indexPath.row]
        savedGameDetail.savedGame = game
    }


}
extension SavedGamesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let loadedGame = loadedGames[indexPath.row]
        let cell = savedGamesTableView.dequeueReusableCell(withIdentifier: "loadedGameCell", for: indexPath)
        cell.textLabel?.text = loadedGame.gameName
        cell.detailTextLabel?.text = loadedGame.dateAndTime.description
        print(loadedGame.homeTeam)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TO DO: SET ALL GAME VARIABLE TO LOADEDGAMES AND SEGUE TO AWAY SCREEN
        let selectedGame = loadedGames[indexPath.row]
        Game.lengthSelected = selectedGame.lengthSelected
        Game.numberOfPlayers = selectedGame.numberOfPlayers
        Game.location = selectedGame.location
        Game.dateAndTime = selectedGame.dateAndTime
        Game.league = selectedGame.league
        Game.refereeNames = selectedGame.refereeNames
        Game.caps = selectedGame.caps
        Game.extraTime = selectedGame.extraTime
        Game.homeTeam = selectedGame.homeTeam
        Game.awayTeam = selectedGame.awayTeam
        Game.numberOfSubs = selectedGame.subs
        Game.homePlayers = selectedGame.homePlayers
        Game.awayPlayers = selectedGame.awayPlayers
//        let alert = UIAlertController(title:"Are You Sure?" , message: "Once The Game Begins Settings Cannot Be Change" , preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
//            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
//            guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
//            self.present(vc, animated: true, completion: nil)
//            
//        }))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//        self.present(alert, animated: false)
    }
    
}
