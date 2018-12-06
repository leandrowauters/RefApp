//
//  GameLengthVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/3/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class GameLengthVC: UIViewController {
    var gameLength = Game.length
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self

    }
    


}
extension GameLengthVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameLength.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let chosenGamelength = gameLength[indexPath.row]
            guard let cell = myTableView.dequeueReusableCell(withIdentifier: "gameLength", for: indexPath) as? GameLengthCell else {return UITableViewCell()}
            cell.gameLength.text = ("\(chosenGamelength) minutes")
        if chosenGamelength == 0 {
            cell.gameLength.text = "Other"
            cell.accessoryType = .disclosureIndicator
            
        }
            return cell
    }
    

}
extension GameLengthVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenGamelength = gameLength[indexPath.row]
        if indexPath.row != 3 {
            Game.lengthSelected = chosenGamelength
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .disclosureIndicator
        }
        
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
