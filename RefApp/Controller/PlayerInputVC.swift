//
//  PlayerInputVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/19/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class PlayerInputVC: UIViewController {

    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var playersTextField: UITextField!
    @IBOutlet weak var playerTitleLabel: UILabel!
    @IBOutlet weak var SwipeLeftLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playersTableView.tableFooterView = UIView(frame: CGRect.zero)
        Game.printValues()
        playerTitleLabel.text = "Enter \(Game.homeTeam) players numbers"
        playersTableView.delegate = self
        playersTableView.dataSource = self
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        insertNewPlayer()
        SwipeLeftLabel.isHidden = false
        print(Game.homePlayers)
    }
    
    func insertNewPlayer(){
    Game.homePlayers.append(Int(playersTextField.text!)!)
        let indexPath = IndexPath(row: Game.homePlayers.count - 1, section: 0)
        playersTableView.beginUpdates()
        playersTableView.insertRows(at: [indexPath], with: .automatic)
        playersTableView.endUpdates()
        playersTextField.text = ""
        view.endEditing(true)
        
    }
}

extension PlayerInputVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Game.homePlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = Game.homePlayers[indexPath.row]
        guard let cell = playersTableView.dequeueReusableCell(withIdentifier: "playerCell") else {return UITableViewCell()}
        cell.textLabel?.text = player.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Game.homePlayers.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
