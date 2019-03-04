//
//  MainScreenViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit
import Kingfisher

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var loadGameButton: UIButton!
    
    weak var userdDidLoginDelegate: UserDidLogInDelegate?
    private var usersession: UserSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        userdDidLoginDelegate = self
        checkForLoginStatus()
        setupButtons(buttons: [newGameButton, loadGameButton])
    }
    
    
    func checkForLoginStatus() {
        if let _ = usersession?.getCurrentUser(){
            barButton.image = UIImage(named: "user")
        } else {
            barButton.image = nil
            navigationItem.rightBarButtonItem?.title = "Sign In"
        }
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
        guard let signInVC = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController else {return}
        guard let myAccountVC = storyBoard.instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountViewController else {return}
        if let user = usersession?.getCurrentUser(){
            DatabaseManager.fetchReferee(vc: self, user: user) { (error, referee) in
                if let error = error {
                    print(error)
                }
                if let referee = referee {
                    myAccountVC.modalPresentationStyle = .overFullScreen
                    myAccountVC.userDidLoginDelegate = self
                    myAccountVC.referee = referee
                    self.present(myAccountVC, animated: true, completion: nil)
                }
            }
            
        } else {
            signInVC.modalPresentationStyle = .overFullScreen
            signInVC.userDidLoginDelegate = self
            present(signInVC, animated: true, completion: nil)
        }
    }

}
extension MainScreenViewController: UserDidLogInDelegate {
    func userDidLogin() {
        viewDidLoad()
    }   
}
