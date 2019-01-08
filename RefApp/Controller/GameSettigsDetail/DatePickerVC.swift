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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func doneWasClicked(_ sender: UIButton) {
       
        let date = GameClient.convertLocalDateToString(str: picker.date.description, dateFormat: "MMM d, h:mm a")
        Game.dateAndTime = date
        gameDegelate?.dateLabelChange(to: date)
        navigationController?.popViewController(animated: true)
    }
    
}
