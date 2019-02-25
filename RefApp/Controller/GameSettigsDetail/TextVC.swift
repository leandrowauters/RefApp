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
    private var usersession: UserSession?
    private var userID = String()
    var selectedIndexPath = Int()
    var myString = String()
    let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
    
    
    @IBOutlet weak var gameSettingLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    

    override func viewDidLoad() {
        getUserId()
        super.viewDidLoad()
        print(selectedIndexPath)
        textField.delegate = self
        gameSettingLabel.text = myString
        useNumKeyboard()
        if selectedIndexPath != 4 {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save as default", style: .plain, target: self, action: #selector(userDefaultsPressed))
        }
        
    }
    func getUserId() {
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        if let user = usersession?.getCurrentUser() {
            userID = user.uid
        } else {
            userID = UserDefaultManager.noUser
        }
    }
    @objc func userDefaultsPressed (){
       
        if let text = textField.text {
        switch selectedIndexPath {
        case 2:
            Game.numberOfPlayers = Int(text)!
            UserDefaults.standard.set(Game.numberOfPlayers, forKey: userID + UserDefaultManager.numberOfPlayers)
            gameDegelate?.numberOfPlayersDidChange(to: Game.numberOfPlayers)
            showAlert(title: "Saved", message: nil) { (UIAlertController) in
                UIAlertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(UIAlertController, animated: true)
            }
            
        case 6:
            Game.league = text
            UserDefaults.standard.set(Game.league, forKey: userID + UserDefaultManager.league)
            gameDegelate?.leagueDidChange(to: Game.league)
            showAlert(title: "Saved", message: nil) { (UIAlertController) in
                UIAlertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(UIAlertController, animated: true)
            }
        case 7:
            Game.lengthSelected = Int(text)!
            UserDefaults.standard.set(Game.lengthSelected, forKey: userID + UserDefaultManager.duration)
            gameLenghtDelegate?.gameLengthChange(to: Game.lengthSelected)
            showAlert(title: "Saved", message: nil) { (UIAlertController) in
                UIAlertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(UIAlertController, animated: true)
            }
        default:
            return
        }
        }
        
    }
    func useNumKeyboard(){
        switch selectedIndexPath {
        case 2,7:
        textField.keyboardType = .numberPad
        
        GraphicClient.doneButton(view: self.view, doneBtn: doneBtn, textFields: [textField])
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


    

