//
//  Alert+Extension.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okay)
        present(alert, animated: true, completion: nil)
        
    }
    func showAlert(title: String, message: String?, handler: @escaping (UIAlertController) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        handler(alertController)
    }
    func showAlertYesNo(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (updateAction) in
            
            print("Game ended")
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: false)
    }
}
