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
    var teamSide: PopActionsVC.Teams!
    var teamSelected = String()
    
    weak var timerDelegate: TimerDelegate?
    weak var eventDelegate: EventDelegate?
    @IBOutlet weak var subTextField: UITextField!
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedPlayer)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Enter Player", style: .done, target: self, action: #selector(doneButtonAction))
            
        GameClient.doneButton(view: self.view, doneBtn: doneBtn, textFields: [subTextField])
//        subTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func doneButtonAction() {
        timerDelegate?.turnOnTimer(turnOn: true)
        timerDelegate?.keepStartButtonHidden(hide: true)
        timerDelegate?.keepStartButtonDisable(disable: true)
        timerDelegate?.addTapAfterSub(add: true)
        eventDelegate?.yellowCall(bool: false, home: true)
        eventDelegate?.redCard(bool: false, home: true)
        eventDelegate?.playerSelected(player: String(selectedPlayer))
        if Game.homePlayers.contains(Int(subTextField.text!)!){
            textLabel.text = "Player Already Entered"
            subTextField.text = ""
            textLabel.textColor = .red

            let _: Timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(changeLabel), userInfo: nil, repeats: true)

            return
        }else if teamSide == .home {
            eventDelegate?.yellowCall(bool: false, home: true)
            eventDelegate?.redCard(bool: false, home: true)
            if let text = subTextField.text{
                eventDelegate?.substitution(bool: true, playerIn: text, playerOut: selectedPlayer.description, home: true, index: selectedButton)
//            Game.homePlayersSorted.remove(at: selectedButton)
//            Game.homePlayersSorted.insert(Int(subTextField.text!)!, at: selectedButton)
//            Game.homePlayersSorted = Game.homePlayersSorted.sorted{$0 < $1}
//            Game.homePlayers = Game.homePlayersSorted
            }
        } else if teamSide == .away {
            eventDelegate?.yellowCall(bool: false, home: false)
            eventDelegate?.redCard(bool: false, home: false)
            if let text = subTextField.text{
                eventDelegate?.substitution(bool: true, playerIn: text, playerOut: selectedPlayer.description, home: false, index: selectedButton)
            }
//            Game.awayPlayersSorted.remove(at: selectedButton)
//            Game.awayPlayersSorted.insert(Int(subTextField.text!)!, at: selectedButton)
//            Game.awayPlayersSorted = Game.awayPlayersSorted.sorted{$0 < $1}
//            Game.awayPlayers = Game.awayPlayersSorted
        }
        let sub = Events.init(type: TypeOfIncident.sub.rawValue, playerNum: selectedPlayer, team: teamSelected, half: Game.gameHalf, subIn: Int(subTextField.text!)!, timeStamp: MainGameVC.timeStamp, color: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
        Game.events.append(sub)
        print(Game.homePlayers)
        
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    @objc func changeLabel (){
        textLabel.text = "Enter Sub Number"
        textLabel.textColor = .black
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
