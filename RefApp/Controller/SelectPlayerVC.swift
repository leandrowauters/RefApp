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
    let timer = MainTimer(timeInterval: 1)
    weak var timerDelegate: TimerDelegate?
    weak var eventDelegate: EventDelegate?
    @IBOutlet weak var subTextField: UITextField!
    @IBOutlet weak var animatedViewRight: UIView!
    @IBOutlet weak var animatedLabelRight: UILabel!
    @IBOutlet weak var animatedViewLeft: UIView!
    
    @IBOutlet weak var animatedLabelLeft: UILabel!
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
            view.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        } else {
            view.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
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
    
    func perfomSub ( team: inout [Int], playerIn: Int, playerOut: Int, index: inout Int){
        if team.contains(playerIn) {
            print("Player Already Playing")
            showAlert(title: "Player Already Playing", message: "Please select another player")
            subTextField.text = ""
            return
        }
        for player in team {
            if Int(playerOut) == player{
                print(index)
                team.remove(at: index)
                team.insert(playerIn, at: index)
                animatedViewRight.isHidden = false
                animatedViewLeft.isHidden = false
                animatedLabelRight.isHidden = false
                animatedLabelLeft.isHidden = false
                UIView.transition(with: animatedViewLeft, duration: 1, options: [.transitionFlipFromRight], animations: {
                    self.playerOutLabel.text = ""
                    self.animatedLabelLeft.text = playerIn.description
                }) { (Bool) in
//                    self.subHalftimeView.animatedLabelLeft.text = playerOut.description
//                    self.subHalftimeView.playerInTextField.text = ""
                }
                
                UIView.transition(with: animatedViewRight, duration: 1, options: [.transitionFlipFromRight], animations: {
                    self.animatedLabelRight.text = playerOut.description
                    self.subTextField.text = ""
                }) { (Bool) in
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//                    UIView.animate(withDuration: 1, delay: 0.5, options: [], animations: {
//
//                        self.animatedLabelRight.text = playerOut.description
//                    }, completion: { (Bool) in
////                        self.subHalftimeView.animatedLabelRight.alpha = 1
////                        self.subHalftimeView.textAnimationViewRight.isHidden = true
////                        self.subHalftimeView.playerOutTextField.isHidden = false
//                    })
                }
                break
            } else {
                index += 1
            }
            if index == team.count - 1{
//                showAlert(title: "Player Not Playing", message: "Please select another player")
//                subHalftimeView.playerOutTextField.text = ""
//                subHalftimeView.playerInTextField.text = ""
//                print("No Player Found")
            }
            
        }
    }
    
    @objc func doneButtonAction() {
//        timerDelegate?.turnOnTimer(turnOn: true)
        var index = 0
        timer.resume()
        if let text = subTextField.text {
        if teamSide == .home {
            perfomSub(team: &Game.homePlayers, playerIn: Int(text)!, playerOut: selectedPlayer, index: &index)
            eventDelegate?.yellowCall(bool: false, home: true, away: false)
            eventDelegate?.redCard(bool: false, home: true, away: false)
 
//            if Game.homePlayers.contains(Int(subTextField.text!)!){
//                subTextField.text = ""
//                showAlert(title: "Player Already Entered", message: nil)
//                return
//            }
//            if let text = subTextField.text{
//                Game.homePlayers.remove(at: selectedButton)
//                Game.homePlayers.insert(Int(text)!, at: Int(selectedButton))
////                eventDelegate?.substitution(playerIn: text, playerOut: selectedPlayer.description, home: true, index: selectedButton)
//                eventDelegate?.subWasMade(bool: true, scrollToAway: false)
////            Game.homePlayersSorted.remove(at: selectedButton)
////            Game.homePlayersSorted.insert(Int(subTextField.text!)!, at: selectedButton)
////            Game.homePlayersSorted = Game.homePlayersSorted.sorted{$0 < $1}
////            Game.homePlayers = Game.homePlayersSorted
//            }
        } else if teamSide == .away {
//            if Game.awayPlayers.contains(Int(subTextField.text!)!){
//                subTextField.text = ""
//                showAlert(title: "Player Already Entered", message: nil)
//                return
//            }
            perfomSub(team: &Game.awayPlayers, playerIn: Int(text)!, playerOut: selectedPlayer, index: &index)
            eventDelegate?.yellowCall(bool: false, home: false, away: true)
            eventDelegate?.redCard(bool: false, home: false, away: true)

//            if let text = subTextField.text{
//                Game.awayPlayers.remove(at: selectedButton)
//                Game.awayPlayers.insert(Int(text)!, at: Int(selectedButton))
////                eventDelegate?.substitution(playerIn: text, playerOut: selectedPlayer.description, home: false, index: selectedButton)
//                eventDelegate?.subWasMade(bool: true, scrollToAway: true)
//            }
//            Game.awayPlayersSorted.remove(at: selectedButton)
//            Game.awayPlayersSorted.insert(Int(subTextField.text!)!, at: selectedButton)
//            Game.awayPlayersSorted = Game.awayPlayersSorted.sorted{$0 < $1}
//            Game.awayPlayers = Game.awayPlayersSorted
        }
//        Game.subs.append((In: subTextField.text!, Out: String(selectedPlayer) ))
        let sub = Events.init(type: TypeOfIncident.sub.rawValue, playerNum: selectedPlayer, team: teamSelected, half: Game.gameHalf, subIn: Int(text)!, timeStamp: MainGameVC.timeStamp, color: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
        Game.events.append(sub)
        print(Game.homePlayers)

        timerDelegate?.keepStartButtonHidden(hide: true)
        timerDelegate?.keepStartButtonDisable(disable: true)
        timerDelegate?.addTapAfterSub(add: true)
        eventDelegate?.activateViewDidAppear(bool: true)
        eventDelegate?.playerSelected(player: String(selectedPlayer))
//        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
        }
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
