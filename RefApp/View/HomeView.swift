//
//  HomeView.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
    
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
            vc.modalPresentationStyle = .overCurrentContext
            currentController?.present(vc, animated: true, completion: nil)
    }
    
    
}