//
//  AwayView.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class AwayView: UIView {

    @IBOutlet weak var awayLabel: UILabel!
    @IBOutlet var awayPlayersButtons: [UIButton]!
    
     let graphics = GraphicClient()
   
    func changeButton () {
        graphics.changeButtonLayout(buttons: awayPlayersButtons)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        changeButton()
    }
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    @IBAction func playerButtonPressed(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "popAction") as? PopActionsVC else {return}
        let currentController = self.getCurrentViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.playerSelected = Game.awayPlayers[sender.tag]
        vc.teamSelected = Game.awayTeam
        vc.teamSide = .away
        vc.selectedButton = sender.tag
        vc.timerDelegate = (currentController as! TimerDelegate)
        vc.eventDelegate = (currentController as! EventDelegate)
        currentController?.present(vc, animated: false, completion: nil)
    }
    

}
