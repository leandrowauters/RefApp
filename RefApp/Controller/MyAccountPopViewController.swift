//
//  MyAccountPopViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 3/10/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class MyAccountPopViewController: UIViewController {
    private var usersession: UserSession!
    weak var userDidLoginDelegate: UserDidLogInDelegate?
    var userLoggedIn = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        usersession.usersessionSignOutDelegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        view.addGestureRecognizer(tap)
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signOutPressed(_ sender: Any) {
        showAlert(title: "Sign out", message: "Are you sure?", style: .alert, customActionTitle: "Yes", cancelActionTitle: "No") { (action) in
            self.usersession.signOut()
            UserSession.loginStatus = .newAccount
            self.userDidLoginDelegate?.userDidLogin()
        }
    }
    
    @IBAction func editAccountPressed(_ sender: Any) {
        
    }
    @IBAction func deletePressed(_ sender: Any) {
        
    }
    

}

extension MyAccountPopViewController: UserSessionSignOutDelegate{
    
    func didRecieveSignOutError(_ usersession: UserSession, error: Error) {
        showAlert(title: "Error signing out", message: error.localizedDescription)
    }
    
    func didSignOutUser(_ usersession: UserSession) {
        showAlert(title: "Succesfully signed out", message: nil) { (alert) in
            alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
                if self.userLoggedIn{
                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
