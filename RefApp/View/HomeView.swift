//
//  HomeView.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
//    var homePlayer = Gam
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet var HomePlayersButtons: [UIButton]!
    
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
    
    @IBAction func playerButtonWasPress(_ sender: UIButton) {
            
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
           guard let vc = storyboard.instantiateViewController(withIdentifier: "popAction") as? PopActionsVC else {return}
            let currentController = self.getCurrentViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.playerSelected = Game.homePlayersSorted[sender.tag]
            vc.teamSelected = Game.homeTeam
            vc.teamSide = .home
            vc.selectedButton = sender.tag
            vc.timerDelegate = (currentController as! TimerDelegate)
            vc.eventDelegate = (currentController as! EventDelegate)
            currentController?.present(vc, animated: false, completion: nil)
    }
    
    
}
