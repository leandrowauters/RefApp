//
//  SelectPlayerVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/1/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class SelectPlayerVC: UIViewController, UITextFieldDelegate {
    var selectedPlayer = Int()
    var selectedButton = Int()
    var teamSide: Game.Teams!
    var teamSelected = String()
    
    weak var timerDelegate: TimerDelegate?
    weak var eventDelegate: EventDelegate?
    @IBOutlet weak var subTextField: UITextField!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var playerOutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedPlayer)
        subTextField.delegate = self
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Enter Player", style: .done, target: self, action: #selector(doneButtonAction))
            
        GraphicClient.doneButton(view: self.view, doneBtn: doneBtn, textFields: [subTextField])
        setupUI()
//        subTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    func setupUI(){
        if teamSide == .home{
            view.backgroundColor = #colorLiteral(red: 0.2737779021, green: 0.4506875277, blue: 0.6578510404, alpha: 1)
        } else {
            view.backgroundColor = #colorLiteral(red: 0.2567201853, green: 0.4751234055, blue: 0.4362891316, alpha: 1)
        }
        playerOutLabel.text = selectedPlayer.description
        playerOutLabel.layer.borderColor = UIColor.white.cgColor
        playerOutLabel.layer.borderWidth = 2
        subTextField.attributedPlaceholder = NSAttributedString(string: "In",attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        subTextField.layer.borderWidth = 2
        subTextField.layer.borderColor = UIColor.white.cgColor
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
            subTextField.text = ""
            showAlert(title: "Player Already Entered", message: nil)
            return
        } else if Game.awayPlayers.contains(Int(subTextField.text!)!){
            subTextField.text = ""
            showAlert(title: "Player Already Entered", message: nil)
            return
            
            
        }else if teamSide == .home {
            eventDelegate?.yellowCall(bool: false, home: true)
            eventDelegate?.redCard(bool: false, home: true)
            if let text = subTextField.text{
                eventDelegate?.substitution(playerIn: text, playerOut: selectedPlayer.description, home: true, index: selectedButton)
                eventDelegate?.subWasMade(bool: true)
//            Game.homePlayersSorted.remove(at: selectedButton)
//            Game.homePlayersSorted.insert(Int(subTextField.text!)!, at: selectedButton)
//            Game.homePlayersSorted = Game.homePlayersSorted.sorted{$0 < $1}
//            Game.homePlayers = Game.homePlayersSorted
            }
        } else if teamSide == .away {
            eventDelegate?.yellowCall(bool: false, home: false)
            eventDelegate?.redCard(bool: false, home: false)
            if let text = subTextField.text{
                eventDelegate?.substitution(playerIn: text, playerOut: selectedPlayer.description, home: false, index: selectedButton)
                eventDelegate?.subWasMade(bool: true)
            }
//            Game.awayPlayersSorted.remove(at: selectedButton)
//            Game.awayPlayersSorted.insert(Int(subTextField.text!)!, at: selectedButton)
//            Game.awayPlayersSorted = Game.awayPlayersSorted.sorted{$0 < $1}
//            Game.awayPlayers = Game.awayPlayersSorted
        }
//        Game.subs.append((In: subTextField.text!, Out: String(selectedPlayer) ))
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
        textLabel.textColor = .white
    }
    override func viewDidDisappear(_ animated: Bool) {
        print(Game.homePlayers)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
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
