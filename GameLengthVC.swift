//
//  GameLengthVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/3/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class GameLengthVC: UIViewController {
    private var gameLength = Game.length
    private var usersession: UserSession?
    weak var gameDelegate: GameDelegate?
    
    var selecteGameLenght = "Not Selected" {
        didSet{
            myTableView.reloadData()
        }
    }

    var userID = String()
    var loginStatus: AccountLoginState?
    @IBOutlet weak var myTableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = usersession?.getCurrentUser(){
            userID = user.uid
            loginStatus = .existingAccount
        } else {
            userID = UserDefaultManager.noUser
        }
//        if let selectedIndex = UserDefaults.standard.object(forKey: UserDefaultManager.index)
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        myTableView.dataSource = self
        myTableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save as default", style: .plain, target: self, action: #selector(userDefaultsPressed))
    
    }
    @objc func userDefaultsPressed(){
        UserDefaults.standard.set(Game.lengthSelected, forKey: userID + UserDefaultManager.duration)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? TextVC else {return}
        destination.myString = "Enter Game Length:"
        destination.selectedIndexPath = 7
        destination.gameDegelate =  gameDelegate
        destination.gameLenghtDelegate = self
    }
}
extension GameLengthVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chosenGamelength = gameLength[indexPath.row]
        var cellToReturn = UITableViewCell()
        if chosenGamelength != 0{
            let cell = myTableView.dequeueReusableCell(withIdentifier: "gameLength", for: indexPath)
            

            cell.textLabel?.text = ("\(chosenGamelength) minutes")
            cellToReturn = cell
        } else if chosenGamelength == 0 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: "other", for: indexPath)
            cell.textLabel?.text = "Enter Other: "
            cell.detailTextLabel?.textColor = .lightGray
            cell.detailTextLabel?.text = "\(selecteGameLenght)"
            cellToReturn = cell
        }
            return cellToReturn
        }
    
    }
    


extension GameLengthVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let chosenGamelength = gameLength[indexPath.row]
        if indexPath.row != 3 {
            
            Game.lengthSelected = chosenGamelength
            gameDelegate?.gameLengthChange(to: chosenGamelength)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark//DO A DID SET TO RELOAD TABLE
            
        } else if indexPath.row == 3 {
//            Game.lengthSelected = Game.lengthSelected
//            gameDelegate?.gameLengthChange(to: Game.lengthSelected)//prints 0
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension GameLengthVC: GameLengthDelegate{
    func gameLengthChange(to lenght: Int) {
        selecteGameLenght = "\(lenght) minutes"
    }
    
    
}

