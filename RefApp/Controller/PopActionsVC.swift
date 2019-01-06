//
//  PopActionsVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class PopActionsVC: UIViewController {
    let timer = MainTimer(timeInterval: 1)
    var timerDelegate: TimerDelegate?
    var playerSelected = Int()
    var selectedButton = Int()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(playerSelected)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SelectPlayerVC else {return}
        destination.selectedPlayer = playerSelected
        destination.selectedButton = selectedButton
        destination.timerDelegete = timerDelegate
    }
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    // TO DO: CREATE INCIDENT PRESSING BUTTON
    @IBAction func incidentButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let yellowCard = Events.init(type: TypeOfIncident.yellowCard.rawValue, playerNum: playerSelected, subIn: nil, timeStamp: MainGameVC.timeStamp)
                Game.events.append(yellowCard)
                Game.yellowCardPlayers.append(playerSelected)
        case 1:
            let redCard = Events.init(type: TypeOfIncident.redCard.rawValue, playerNum: playerSelected, subIn: nil, timeStamp: MainGameVC.timeStamp)
                Game.events.append(redCard)
        case 3:
            let goal = Events.init(type: TypeOfIncident.goal.rawValue, playerNum: playerSelected, subIn: nil, timeStamp: MainGameVC.timeStamp)
                Game.events.append(goal)
        default:
            return
            
        }
        for incident in Game.events{
            print(incident)
        }
        print(Game.events.count)
        dismiss(animated: true, completion: nil)
        timer.resume()
        
    }
    
}
