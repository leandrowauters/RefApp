//
//  SelectPlayerVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class SelectPlayerVC: UIViewController {
    var selectedPlayer = Int()
    var selectedButton = Int()
    weak var timerDelegete: TimerDelegate?
    @IBOutlet weak var subTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedPlayer)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Enter Player", style: .done, target: self, action: #selector(doneButtonAction))
            
        GameClient.doneButton(view: self.view, doneBtn: doneBtn, textField: subTextField)
//        subTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    @objc func doneButtonAction() {
        timerDelegete?.turnOnTimer(turnOn: true)
        Game.homePlayersSorted.remove(at: selectedButton)
        Game.homePlayersSorted.insert(Int(subTextField.text!)!, at: selectedButton)
        Game.homePlayersSorted = Game.homePlayersSorted.sorted{$0 < $1}
        Game.homePlayers = Game.homePlayersSorted
        let sub = Incident.init(type: TypeOfIncident.sub.rawValue, playerNum: selectedPlayer, subIn: Int(subTextField.text!)!, timeStamp: MainGameVC.timeStamp)
        PopActionsVC.incidents.append(sub)
        print(Game.homePlayers)
        
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        print(Game.homePlayers)
    }

    
}

//extension SelectPlayerVC: UITextFieldDelegate{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        Game.refereeNames.remove(at: indexPath.row)
//        Game.homePlayers.remove(at: selectedButton)
//        Game.homePlayers.insert(Int(textField.text!)!, at: selectedButton)
//        textField.resignFirstResponder()
//        return true
//    }
//}
