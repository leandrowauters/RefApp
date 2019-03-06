//
//  SavedGamesViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/7/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class SavedGamesViewController: UIViewController {
    var loadedGames = [Game]() {
        didSet{
            self.savedGamesTableView.reloadData()
            self.activityIndicatior.stopAnimating()
        }
    }
    private var usersession: UserSession?
    @IBOutlet weak var savedGamesTableView: UITableView!
    @IBOutlet weak var activityIndicatior: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatior.startAnimating()
        savedGamesTableView.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        savedGamesTableView.dataSource = self
        savedGamesTableView.delegate = self
        getGames()
    }
    func getGames() {
        if let user = usersession?.getCurrentUser(){
            DatabaseManager.fetchSaveGames(vc: self, userID: user.uid) { (error, games) in
                if let error = error {
                    print(error)
                }
                if let games = games {
                    self.loadedGames = games
                }
            }
        }
//        if UserSession.loginStatus == .existingAccount{
//            DatabaseManager.fetchSaveGames(vc: self, user: ) { (error, games) in
//                if let error = error{
//                    print(error)
//                }
//                if let games = games {
//                    self.loadedGames = games
//                }
//            }
//        } else {
//            loadedGames = DataPeristanceModel.getGames()
//        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = savedGamesTableView.indexPathForSelectedRow,
            let savedGameDetail = segue.destination as? SavedGameDetailedViewController else {return}
        let game = loadedGames[indexPath.row]
        savedGameDetail.savedGame = game
        savedGameDetail.index = indexPath.row
    }


}
extension SavedGamesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let loadedGame = loadedGames[indexPath.row]
        let cell = savedGamesTableView.dequeueReusableCell(withIdentifier: "loadedGameCell", for: indexPath)
        tableView.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        cell.textLabel?.text = loadedGame.gameName
        cell.detailTextLabel?.text = loadedGame.dateAndTime.description
        print(loadedGame.homeTeam)
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //TO DO: SET ALL GAME VARIABLE TO LOADEDGAMES AND SEGUE TO AWAY SCREEN
////        let alert = UIAlertController(title:"Are You Sure?" , message: "Once The Game Begins Settings Cannot Be Change" , preferredStyle: .alert)
////        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
////            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
////            guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
////            self.present(vc, animated: true, completion: nil)
////            
////        }))
////        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
////        self.present(alert, animated: false)
//    }
    
}
