//
//  CreateAccountViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/15/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit
import Firebase
class CreateAccountViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    private var usersession: UserSession!
    override func viewDidLoad() {
        super.viewDidLoad()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        usersession.userSessionAccountDelegate = self
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @IBAction func createUserPressed(_ sender: UIButton) {
        guard let email = userNameTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            !email.isEmpty,
            !confirmPassword.isEmpty,
            !password.isEmpty else {
                showAlert(title: "Missing Required Fields", message: "Email and Password Required")
                return
        }
        if password != confirmPassword {
            showAlert(title: "Passwords do not match", message: "Please enter the correct passwords")
        }
        usersession.createNewAccount(email: email, password: password, confirmPassoword: confirmPassword)
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension CreateAccountViewController: UserSessionAccountCreationDelegate {
    func didCreateAccount(_ userSession: UserSession, user: User) {
        showAlert(title: "Account Created", message: "Account created using \(user.email ?? "no email entered") ") { alertController in
            let okAction = UIAlertAction(title: "Ok", style: .default) { alert in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
}
    

