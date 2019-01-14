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
    
    
    
    func buttons() {
        for button in HomePlayersButtons{
            
            button.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.y, width: 75
                
                , height: 75)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = button.frame.width / 2
            button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            button.layer.borderWidth = 2.0
            button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
            button.titleLabel?.font = UIFont.init(name: "Verdana", size: 27)// THIS SETS FONT
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
            //CREAT BUTTONS FOR EACH INSTANCE (YELLOW, RED, ....)
//            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.layer.masksToBounds = true
        }
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
