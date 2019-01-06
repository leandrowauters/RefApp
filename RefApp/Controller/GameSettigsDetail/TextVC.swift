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
    weak var gameLenghtDelegate: GameLengthDelegate?
    var selectedIndexPath = Int()
    var myString = String()
    let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
    
    
    @IBOutlet weak var gameSettingLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        print(selectedIndexPath)
        textField.delegate = self
        gameSettingLabel.text = myString
        useNumKeyboard()

        
    }
    func useNumKeyboard(){
        switch selectedIndexPath {
        case 2,7:
        textField.keyboardType = .numberPad
        
        GameClient.doneButton(view: self.view, doneBtn: doneBtn, textField: textField)
        default:
            return
        }
    }
    @objc func doneButtonAction() {
        if !(textField.text?.isEmpty)!{
        switch selectedIndexPath {
        case 2:
            let numberOfPlayers = Int(textField.text!)!
            Game.numberOfPlayers = Int(textField.text!)!
            gameDegelate?.numberOfPlayersDidChange(to: numberOfPlayers)
            navigationController?.popViewController(animated: true)
        case 7:
            let lenght = Int(textField.text!)!
            Game.lengthSelected = Int(textField.text!)!
            gameDegelate?.gameLengthChange(to: lenght)
            gameLenghtDelegate?.gameLengthChange(to: lenght)
            navigationController?.popViewController(animated: true)
        default:
            return
        }
        } else {
            navigationController?.popViewController(animated: true)
        }
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
        case 7:
            let lenght = Int(textField.text!)!
            Game.lengthSelected = Int(textField.text!)!
            gameDegelate?.gameLengthChange(to: lenght)
            gameLenghtDelegate?.gameLengthChange(to: lenght)
            navigationController?.popViewController(animated: true)
            
//            gameDegelate?.customGameLenghtChage(to: lenght)
//            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "gameSettings")
//            vc.modalPresentationStyle = .overCurrentContext
//            present(vc, animated: true, completion: nil)
        default:
            print("Error1")
        }

    return true
    }
    
}


    

