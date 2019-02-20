//
//  MainScreenViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var barButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserSession.loginStatus == .existingAccount {
//            barButton.title = "My Account"
            barButton.image = UIImage(named: "icons8-guest_male")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
