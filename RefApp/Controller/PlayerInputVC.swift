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
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var playersTextField: UITextField!
    @IBOutlet weak var playerTitleLabel: UILabel!
    @IBOutlet weak var SwipeLeftLabel: UILabel!
    @IBOutlet weak var playerLeftLabel: UILabel!
    
    
    

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        playersTableView.tableFooterView = UIView(frame: CGRect.zero)
        GameClient.printValues()
        playerTitleLabel.text = "Enter \(Game.homeTeam.capitalized) players numbers"
        playersTableView.delegate = self
        playersTableView.dataSource = self
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Enter Player", style: .done, target: self, action: #selector(doneButtonAction))
        GameClient.doneButton(view: self.view, doneBtn: doneBtn, textField: playersTextField)
        playersLeft()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        notifications()

    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {return}
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
                bottomConstaint.constant = keyboardSize - view.safeAreaInsets.bottom
        } else {
            bottomConstaint.constant = 0
        }
    }
        
    fileprivate func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func playersLeft(){
        playerLeftLabel.text = "Players Left: \(Game.numberOfPlayers - Game.homePlayers.count)"
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    @objc func doneButtonAction() {
        insertNewPlayer()
        SwipeLeftLabel.isHidden = false
    }
    
    
    func insertNewPlayer(){
        guard let text = playersTextField.text else {return}
        guard let num = Int(text) else {return}
        if Game.homePlayers.contains(num){
            playerLeftLabel.text = "Player already entered"
            playersTextField.text = ""
        } else {
        Game.homePlayers.append(Int(num))
        playersLeft()
        let indexPath = IndexPath(row: Game.homePlayers.count - 1, section: 0)
        playersTableView.beginUpdates()
        playersTableView.insertRows(at: [indexPath], with: .automatic)
        playersTableView.endUpdates()
        playersTextField.text = ""
        playersTableView.layoutIfNeeded()
        playersTableView.scrollToRow(at: indexPath,
                                     at: UITableView.ScrollPosition.bottom,
                                   animated: true)
            
            if Game.numberOfPlayers - Game.homePlayers.count == 0{
                playerLeftLabel.text = "All Players Selected"
            }
            if Game.numberOfPlayers - Game.homePlayers.count < 0{
                playerLeftLabel.textColor = .red
                playerLeftLabel.text = "\(abs(Game.numberOfPlayers - Game.homePlayers.count).description) Extra Player!"
            }
        }
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
