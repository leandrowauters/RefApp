//
//  CustomCellGameSettingVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/2/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class TextVC: UIViewController {
    private var numberOfPlayers = Game.numberOfPlayers
    private var location = Game.location
    private var league = Game.league
    weak var gameDegelate: GameDelegate?
    var selectedIndexPath = Int()
    var myString = String()
    
    @IBOutlet weak var gameSettingLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedIndexPath)
        textField.delegate = self
        gameSettingLabel.text = myString
    }
}


extension TextVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch selectedIndexPath{
        case 2:
            let numberOfPlayers = Int(textField.text!)!
            Game.numberOfPlayers = Int(textField.text!)!
            gameDegelate?.numberOfPlayersDidChange(to: numberOfPlayers)
            navigationController?.popViewController(animated: true)
        case 4:
            let location = textField.text
            Game.location = textField.text!
            gameDegelate?.locationDidChange(to:location!)
            navigationController?.popViewController(animated: true)
        case 6:
            let league = textField.text
            Game.league.append(textField.text!)
            gameDegelate?.leagueDidChange(to: league!)
            navigationController?.popViewController(animated: true)
        default:
            print("Error1")
        }

    return true
    }
}


    

