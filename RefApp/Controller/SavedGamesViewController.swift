//
//  SavedGamesViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/7/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class SavedGamesViewController: UIViewController {
    let loadedGames = GameSaveClient.getSavedGames()!
    
    @IBOutlet weak var savedGamesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        savedGamesTableView.dataSource = self
    }
    



}
extension SavedGamesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let loadedGame = loadedGames[indexPath.row]
        let cell = savedGamesTableView.dequeueReusableCell(withIdentifier: "loadedGameCell", for: indexPath)
        cell.textLabel?.text = loadedGame.gameName
        cell.detailTextLabel?.text = loadedGame.dateAndTime.description
        return cell
    }
    
    
}
