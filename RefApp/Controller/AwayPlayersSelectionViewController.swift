//
//  AwayPlayersSelectionViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/22/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit
class AwayPlayersSelectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {


    let graphics = GraphicClient()
    var intention: Intention?
    var game: Game!
    @IBOutlet var numberPadButtons: [UIButton]!
    @IBOutlet weak var numbersCollectionView: UICollectionView!

    
    
    
    var number = ""{
        didSet{
            DispatchQueue.main.async {
                self.numbersCollectionView.reloadData()
            }
        }
    }
    
    var awayPlayers = Game.awayPlayers {
        didSet{
            DispatchQueue.main.async {
                self.numbersCollectionView.reloadData()
            }
        }
    }
    private var usersession: UserSession?
    private var userID = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(Game.awayTeam) Players"
        numbersCollectionView.delegate = self
        numbersCollectionView.dataSource = self
        scrollToLastIndex()
        getUserId()
        if intention == .edit{
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
            self.navigationItem.rightBarButtonItem = doneButton
        }

    }
    @objc func donePressed(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let savedGames = storyboard.instantiateViewController(withIdentifier: "SavedGames") as? SavedGamesViewController else {return}
        if UserSession.loginStatus == .existingAccount{
            DatabaseManager.updatedSaveGameToDatabase(userID: userID, dbReference: game.dbReferenceDocumentId)
            
            navigationController?.pushViewController(savedGames, animated: true)
        } else {
            DataPeristanceModel.addGame()
        }
        
        
    }
    func scrollToLastIndex(){
        let indextPath = IndexPath(item: awayPlayers.count, section: 0)
        numbersCollectionView.scrollToItem(at: indextPath, at: .right, animated: true)
    }
    func getUserId() {
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        if let user = usersession?.getCurrentUser() {
            userID = user.uid
            
        } else {
            userID = UserDefaultManager.noUser
        }
    }
    override func viewDidLayoutSubviews() {
        graphics.changeButtonLayout(buttons: numberPadButtons)
    }
    @IBAction func numberPadWasPressed(_ sender: UIButton) {
        number.append(Character(sender.tag.description))
        //        numbersTextView.text = number
        
    }

    @IBAction func okayWasPressed(_ sender: UIButton) {
        let alert = UIAlertController(title:"Are You Sure?" , message: "Once The Game Begins Settings Cannot Be Change" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
            self.present(vc, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save For Later", style: .default, handler: { (alertAction) in
            self.showAlert(title: "Enter Game Name", message: nil, handler: { (alert) in
                alert.addTextField(configurationHandler: { (UITextField) in
                    _ = ""
                })
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (updateAction) in
                    Game.gameName = alert.textFields?.first?.text

                    if UserSession.loginStatus == .existingAccount{
                        DatabaseManager.postSaveGameToDatabase(userID: self.userID)
                    } else {
                        DataPeristanceModel.addGame()
                    }     
                }))
                self.present(alert, animated: true, completion: nil)
            })
            
        }))
        self.present(alert, animated: false)
    }
    
    @IBAction func enterWasPressed(_ sender: UIButton) {
        if number != ""{
        if !awayPlayers.contains(Int(number)!){
            awayPlayers.append(Int(number)!)
            Game.awayPlayers.append(Int(number)!)
            number = ""
            let indexPath = IndexPath(row: awayPlayers.count, section: 0)
            numbersCollectionView.insertItems(at: [indexPath])
            numbersCollectionView.layoutIfNeeded()
            numbersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            showAlert(title: "Player Already Entered", message: nil)
            number = ""
            print("Number of players \(Game.awayPlayers.count)")
        }
        } else {
            showAlert(title: "Please enter player", message: "Try again")
        }
    }
    @IBAction func backspacePressed(_ sender: UIButton) {
        number.removeLast()
    }
    
    @IBAction func deleteWasPressed(_ sender: UIButton) {
        awayPlayers.remove(at: sender.tag)
        Game.awayPlayers.remove(at: sender.tag)
        
        let indexPath = IndexPath(row: awayPlayers.count, section: 0)
        numbersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return awayPlayers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AwayCell", for: indexPath) as? AwayPlayersCollectionViewCell else {return UICollectionViewCell()}
        if intention == .edit{
            cell.okayButton.isEnabled = false
        }
        return AwayPlayersCollectionViewCell.setUpCell(collectionView: collectionView, cell: cell, indexPath: indexPath.row, number: number)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 250, height:250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = 250.0
        let numberOfCells = floor(self.view.frame.size.width / cellWidth)
        //        var leftInsets = (view.frame.size.width / 2) + (cellWidth / 2)
        let rightInstets = (self.view.frame.size.width / 2) - (cellWidth / 2)
        //        if homePlayers.count + 1 == 1 || homePlayers.count == 0{
        
        let leftInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        //            return UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInstets)
        //        }
        return UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInstets)
    }

}
