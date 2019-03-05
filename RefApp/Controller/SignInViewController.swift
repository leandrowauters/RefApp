//
//  SignInViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createAccountLabel: UILabel!
    private var usersession: UserSession?
    weak var userDidLoginDelegate: UserDidLogInDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(createAccountTapped))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(tap)
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        usersession?.usersessionSignInDelegate = self
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @IBAction func cancelWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createAccountTapped() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CreateAccountViewController") as? CreateAccountViewController else {return}
        vc.userDidLoginDelegate = userDidLoginDelegate
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func signInPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty else {
                showAlert(title: "Missing fields", message: "Try again")
                return
        }
        usersession?.signInExistingUser(email: email, password: password)
    }
    
}
extension SignInViewController: UserSessionSignInDelegate{

        func didRecieveSignInError(_ usersession: UserSession, error: Error) {
            showAlert(title: "Sing In Error", message: error.localizedDescription)
        }
        
        func didSignInExistingUser(_ usersession: UserSession, user: User) {
            self.presentMyAccountController(user: user)
        }
    func presentMyAccountController(user: User){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let myAccountController = storyboard.instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountViewController else {print("No VC")
            return
        }
        DatabaseManager.fetchReferee(vc: self, user: user) { (error, referee) in
            if let error = error {
                print(error)
            }
            if let referee = referee {
                myAccountController.userLoggedIn = true
                myAccountController.userDidLoginDelegate = self.userDidLoginDelegate
                myAccountController.referee = referee
                self.present(myAccountController, animated: true, completion: nil)
                
            }
        }
    }
}
