//
//  SignInViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var createAccountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(createAccountTapped))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(tap)
        let screenTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(screenTap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @objc func createAccountTapped() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateAccountViewController")
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
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
