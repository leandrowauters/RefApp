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
    var playerSelected = Int()
    var selectedButton = Int()
    static var incidents = [Incident]()

    
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
    }
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    // TO DO: CREATE INCIDENT PRESSING BUTTON
    @IBAction func incidentButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let yellowCard = Incident.init(type: TypeOfIncident.yellowCard.rawValue, playerNum: playerSelected, subIn: nil, timeStamp: MainGameVC.timeStamp)
                PopActionsVC.incidents.append(yellowCard)
        case 1:
            let redCard = Incident.init(type: TypeOfIncident.redCard.rawValue, playerNum: playerSelected, subIn: nil, timeStamp: MainGameVC.timeStamp)
            PopActionsVC.incidents.append(redCard)
        case 3:
            let goal = Incident.init(type: TypeOfIncident.goal.rawValue, playerNum: playerSelected, subIn: nil, timeStamp: MainGameVC.timeStamp)
            PopActionsVC.incidents.append(goal)
        default:
            return
            
        }

        print(PopActionsVC.incidents.count)
        dismiss(animated: true, completion: nil)
        timer.resume()
        
    }
    
}
