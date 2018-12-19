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
    var gameDelegate: GameDelegate?
    @IBOutlet weak var myTableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? TextVC else {return}
        destination.myString = "Enter Game Length:"
        destination.selectedIndexPath = 7
        destination.gameDegelate =  gameDelegate
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
            guard let cell = myTableView.dequeueReusableCell(withIdentifier: "gameLength", for: indexPath) as? GameLengthCell else {return UITableViewCell()}
            cell.gameLength.text = ("\(chosenGamelength) minutes")
            cellToReturn = cell
        } else if chosenGamelength == 0 {
            guard let cell = myTableView.dequeueReusableCell(withIdentifier: "other", for: indexPath) as? GameLengthCell else {return UITableViewCell()}
            cell.otherLabel.text = "Enter Other: "
            
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
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
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



