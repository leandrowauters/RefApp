//
//  DatePickerVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/2/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController {
weak var gameDegelate: GameDelegate?
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        doneButton.layer.borderColor = UIColor.white.cgColor
//        doneButton.layer.borderWidth = 3
//        doneButton.layer.cornerRadius = 10
        picker.setValue(UIColor.white, forKeyPath: "textColor")
//        picker.backgroundColor = #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 0.8780233305)
//        picker.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).cgColor
//        picker.layer.masksToBounds = true
//        picker.layer.borderWidth = 3
//        picker.layer.cornerRadius = 10
    }
    @IBAction func doneWasClicked(_ sender: UIButton) {
        let date = GameClient.convertLocalDateToString(str: picker.date.description, dateFormat: "MMM d, h:mm a")
        Game.dateAndTime = date
        gameDegelate?.dateLabelChange(to: date)
        navigationController?.popViewController(animated: true)
    }
    
}
