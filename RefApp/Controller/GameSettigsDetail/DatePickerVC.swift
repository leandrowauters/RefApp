//
//  DatePickerVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/2/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class DatePickerVC: UIViewController {

    @IBOutlet weak var picker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func doneWasClicked(_ sender: UIButton) {
        Game.dateAndTime = picker.date
        navigationController?.popViewController(animated: true)
    }
    
}
