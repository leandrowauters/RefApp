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
    let homeTeam = Game.homeTeam
    weak var timerDelegate: TimerDelegate?
    weak var eventDelegate: EventDelegate?
    var playerSelected = Int()
    var selectedButton = Int()
    var teamSelected = String()
    var teamSide: Teams!
    enum Teams{
        case home
        case away
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(playerSelected)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SelectPlayerVC else {return}
        destination.selectedPlayer = playerSelected
        destination.teamSide = teamSide
        destination.teamSelected = teamSelected
        destination.selectedButton = selectedButton
        destination.timerDelegate = timerDelegate
        destination.eventDelegate = eventDelegate
    }
    @objc func goBack(){
        timerDelegate?.keepStartButtonDisable(disable: true)
        timerDelegate?.keepStartButtonHidden(hide: true)
        dismiss(animated: true, completion: nil)
        
    }
    // TO DO: CREATE INCIDENT PRESSING BUTTON
    @IBAction func incidentButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let yellowCard = Events.init(type: TypeOfIncident.yellowCard.rawValue, playerNum: playerSelected, team: teamSelected, half: Game.gameHalf, subIn: nil, timeStamp: MainGameVC.timeStamp, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                Game.events.append(yellowCard)
            if teamSide == .home{
                Game.homeYellowCardPlayers.append(playerSelected)
                timerDelegate?.keepStartButtonDisable(disable: true)
                timerDelegate?.keepStartButtonHidden(hide: true)
                eventDelegate?.yellowCall(bool: true, home: true)
                eventDelegate?.redCard(bool: false, home: true)
                eventDelegate?.playerSelected(player: String(playerSelected))
//                eventDelegate?.activateViewDidAppear(bool: true)
                GameStatistics.homeYellowCards += 1
                eventDelegate?.subWasMade(bool: false)
            } else if teamSide == .away{
                Game.awayYellowCardPlayers.append(playerSelected)
                timerDelegate?.keepStartButtonDisable(disable: true)
                timerDelegate?.keepStartButtonHidden(hide: true)
                eventDelegate?.yellowCall(bool: true, home: false)
                eventDelegate?.redCard(bool: false, home: false)
                eventDelegate?.playerSelected(player: String(playerSelected))
//                eventDelegate?.activateViewDidAppear(bool: true)
                GameStatistics.awayYellowCards += 1
//                Game.homeYellowCardPlayers.append(playerSelected)
                eventDelegate?.subWasMade(bool: false)
            }
            
        case 1:
            let redCard = Events.init(type: TypeOfIncident.redCard.rawValue, playerNum: playerSelected, team: teamSelected, half: Game.gameHalf, subIn: nil, timeStamp: MainGameVC.timeStamp, color: #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1))
                Game.events.append(redCard)
            if teamSide == .home{
                Game.homeRedCardPlayers.append(playerSelected)
                timerDelegate?.keepStartButtonDisable(disable: true)
                timerDelegate?.keepStartButtonHidden(hide: true)
                eventDelegate?.yellowCall(bool: false, home: true)
                eventDelegate?.redCard(bool: true, home: true)
                eventDelegate?.playerSelected(player: String(playerSelected))
                GameStatistics.homeRedCard += 1
//                eventDelegate?.activateViewDidAppear(bool: true)
                eventDelegate?.subWasMade(bool: false)
                
            } else if teamSide == .away{
                Game.awayRedCardPlayers.append(playerSelected)
                timerDelegate?.keepStartButtonDisable(disable: true)
                timerDelegate?.keepStartButtonHidden(hide: true)
                eventDelegate?.yellowCall(bool: false, home: false)
                eventDelegate?.redCard(bool: true, home: false)
                eventDelegate?.playerSelected(player: String(playerSelected))
                GameStatistics.awayRedCard += 1
//                eventDelegate?.activateViewDidAppear(bool: true)
                eventDelegate?.subWasMade(bool: false)
            }
        case 3:
            let goal = Events.init(type: TypeOfIncident.goal.rawValue, playerNum: playerSelected,team: teamSelected, half: Game.gameHalf, subIn: nil, timeStamp: MainGameVC.timeStamp, color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
                Game.events.append(goal)
            if teamSide == .home {
                timerDelegate?.keepStartButtonDisable(disable: true)
                timerDelegate?.keepStartButtonHidden(hide: true)
                eventDelegate?.yellowCall(bool: false, home: true)
                eventDelegate?.redCard(bool: false, home: true)
                eventDelegate?.subWasMade(bool: false)
                Game.homeGoalsPlayers.append(playerSelected)
                Game.homeScore += 1
            } else if teamSide == .away{
                timerDelegate?.keepStartButtonDisable(disable: true)
                timerDelegate?.keepStartButtonHidden(hide: true)
                eventDelegate?.yellowCall(bool: false, home: false)
                eventDelegate?.redCard(bool: false, home: false)
                eventDelegate?.subWasMade(bool: false)
                Game.awayGoalsPlayers.append(playerSelected)
                Game.awayScore += 1
            }
//             eventDelegate?.activateViewDidAppear(bool: true)
        default:
            return
            
        }
        for incident in Game.events{
            print(incident)
        }
        self.eventDelegate?.activateViewDidAppear(bool: true)
        dismiss(animated: true) 
        timer.resume()
        
    }
    
}
