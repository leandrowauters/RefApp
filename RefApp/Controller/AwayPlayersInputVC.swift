//
//  AwayPlayersInputVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class AwayPlayersInputVC: UIViewController {
    
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var playersTextField: UITextField!
    @IBOutlet weak var playerTitleLabel: UILabel!
    @IBOutlet weak var SwipeLeftLabel: UILabel!
    @IBOutlet weak var playerLeftLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameClient.printValues()
        playerTitleLabel.text = "Enter \(Game.awayTeam.capitalized) players numbers"
        playersTableView.delegate = self
        playersTableView.dataSource = self
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Enter Player", style: .done, target: self, action: #selector(doneButtonAction))
        GameClient.doneButton(view: self.view, doneBtn: doneBtn, textFields: [playersTextField])
        playersLeft()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save For Later", style: .plain, target: self, action: #selector(saveTapped))
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        notifications()
    
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    fileprivate func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {return}
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            bottomConstaint.constant = keyboardSize - view.safeAreaInsets.bottom
        } else {
            bottomConstaint.constant = 0
        }
    }
    @objc func saveTapped(){
        GameSaveClient.alert(vc: self)
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title:"Are You Sure?" , message: "Once The Game Begins Settings Cannot Be Change" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
            self.present(vc, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: false)
    }
    
    
    func playersLeft(){
        playerLeftLabel.text = "Players Left: \(Game.numberOfPlayers - Game.awayPlayers.count)"
        if Game.numberOfPlayers - Game.awayPlayers.count > 0{
          nextButton.isHidden = true
          playerLeftLabel.textColor = .black
        }
        if Game.numberOfPlayers - Game.awayPlayers.count == 0{
            playerLeftLabel.text = "All Players Selected"
            nextButton.isHidden = false
            dismissKeyboard()
        }
        if Game.numberOfPlayers - Game.awayPlayers.count < 0{
            playerLeftLabel.textColor = .red
            playerLeftLabel.text = "\(abs(Game.numberOfPlayers - Game.awayPlayers.count).description) Extra Player!"
            nextButton.isHidden = true
        }
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
        if Game.awayPlayers.contains(num){
            playerLeftLabel.text = "Player already entered"
            playersTextField.text = ""
        } else {
            Game.awayPlayers.append(Int(num))
            playersLeft()
            let indexPath = IndexPath(row: Game.awayPlayers.count - 1, section: 0)
            playersTableView.beginUpdates()
            playersTableView.insertRows(at: [indexPath], with: .automatic)
            playersTableView.endUpdates()
            playersTextField.text = ""
            playersTableView.layoutIfNeeded()
            playersTableView.scrollToRow(at: indexPath,
                                         at: UITableView.ScrollPosition.bottom,
                                         animated: true)
            

        }
    }
    }
    
    extension AwayPlayersInputVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Game.awayPlayers.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let player = Game.awayPlayers[indexPath.row]
            guard let cell = playersTableView.dequeueReusableCell(withIdentifier: "playerCell") else {return UITableViewCell()}
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = player.description
            return cell
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //        if editingStyle == .delete {
        //            Game.awayPlayers.remove(at: indexPath.row)
        //            tableView.beginUpdates()
        //            tableView.deleteRows(at: [indexPath], with: .automatic)
        //            tableView.endUpdates()
        //        }
        //    }
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
                let alert = UIAlertController(title: "", message: "Enter Number", preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (textField) in
                    self.playersTextField.text = Game.awayPlayers[indexPath.row].description
                })
                alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                    if !Game.awayPlayers.contains(Int(alert.textFields!.first!.text!)!){
                        Game.awayPlayers[indexPath.row] = Int(alert.textFields!.first!.text!)!
                        self.playersTableView.reloadRows(at: [indexPath], with: .fade)
                        self.playersTextField.text = ""
                    } else {
                        self.playerLeftLabel.text = "Number Already Entered"
                        self.playersTextField.text = ""
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: false)
            })
            editAction.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
                Game.awayPlayers.remove(at: indexPath.row)
                self.playersLeft()
                self.playersTableView.reloadData()
            })
            
            return [deleteAction, editAction]
        }
}

