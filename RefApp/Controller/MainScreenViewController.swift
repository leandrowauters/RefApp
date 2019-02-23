//
//  MainScreenViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {
    var settings = Settings()
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var loadGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.printSettings()
        if UserSession.loginStatus == .existingAccount {
//            barButton.title = "My Account"
            barButton.image = UIImage(named: "icons8-guest_male")
        }
        setupButtons(buttons: [newGameButton, loadGameButton])
    }
    func setupButtons(buttons: [UIButton]) {
        for button in buttons {
            button.layer.borderWidth = 2
            button.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            button.layer.cornerRadius = 20
        }
    }
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let signInVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController")
        let myAccountVC = storyBoard.instantiateViewController(withIdentifier: "MyAccountVC")
        if UserSession.loginStatus == .existingAccount{
        navigationController?.pushViewController(myAccountVC, animated: true)
        } else {
            navigationController?.pushViewController(signInVC, animated: true)
        }
    }

}
