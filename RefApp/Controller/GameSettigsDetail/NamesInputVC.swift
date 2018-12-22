//
//  NamesInputVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/17/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class NamesInputVC: UIViewController {
    
    var buttonTapsRef = 0
    var buttonTapsCap = 0
    var selectedIndex = Int()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var namesTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namesTableView.delegate = self
        namesTableView.dataSource = self
        switch selectedIndex{
        case 0:
            titleLabel.text = "Enter Ref Name"
        case 1:
            titleLabel.text = "Enter \(Game.homeTeam.capitalized) Captain"
        default:
            print("Error")
            
        }
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Enter Name", style: .done, target: self, action: #selector(doneButtonAction))
        GameClient.doneButton(view: self.view, doneBtn: doneBtn, textField: nameTextField)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        notifications()
        
    }
    fileprivate func notifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {return}
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            bottomConstraint.constant = keyboardSize - view.safeAreaInsets.bottom
        } else {
            bottomConstraint.constant = 0
        }
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    @objc func doneButtonAction() {
        insertName()
    }
    func insertName(){
        guard let name = nameTextField.text else {return}
        func helper (indexPath: IndexPath){
            namesTableView.beginUpdates()
            namesTableView.insertRows(at: [indexPath], with: .automatic)
            namesTableView.endUpdates()
            nameTextField.text = ""
            namesTableView.layoutIfNeeded()
            namesTableView.scrollToRow(at: indexPath,
                                       at: UITableView.ScrollPosition.bottom,
                                       animated: true)
        }
        switch selectedIndex {
        case 0:
            buttonTapsRef += 1
            Game.refereeNames.append(name)
            let indexPath = IndexPath(row: Game.refereeNames.count - 1, section: 0)
            helper(indexPath: indexPath)
            switch buttonTapsRef {
            case 1 ,2:
                titleLabel.text = "Enter Assistant 1 and 2 - Optional"
            case 3:
                titleLabel.text = "Enter Fourth Official - Optional"
            case 4:
                titleLabel.text = "Enter Assistant 5 and 6 - Optional"
            default:
                titleLabel.text = "All Names Selected"
            }
            
        case 1:
            buttonTapsCap += 1
            Game.caps.append(name)
            let indexPath = IndexPath(row: Game.caps.count - 1, section: 0)
            helper(indexPath: indexPath)
            switch buttonTapsCap {
            case 1:
                titleLabel.text = "Enter \(Game.homeTeam.capitalized) Captain"
            case 2:
                titleLabel.text = "Enter \(Game.awayTeam.capitalized) Captain"
            default:
                titleLabel.text = "All Names Entered"
            }
            
        default:
            return
        }
        
    }
}

extension NamesInputVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedIndex {
        case 0:
            return Game.refereeNames.count
        case 1:
            return Game.caps.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var name = ""
        let cellToReturn = UITableViewCell()
        guard namesTableView.dequeueReusableCell(withIdentifier: "nameCell") != nil else {return UITableViewCell()}
        switch selectedIndex{
        case 0:
            name = Game.refereeNames[indexPath.row]
            switch buttonTapsRef{
            case 1:
                cellToReturn.textLabel?.text = "Ref: \(name.capitalized)"
            case 2,3,5,6:
                cellToReturn.textLabel?.text = "Assistant \(buttonTapsRef): \(name.capitalized)"
            case 4:
                cellToReturn.textLabel?.text = "Fourth Official \(name.capitalized)"
            default:
                print("ERROR")
            }
        case 1:
            name = Game.caps[indexPath.row]
            switch buttonTapsCap{
            case 1:
                cellToReturn.textLabel?.text = "\(Game.homeTeam.capitalized) Captain: \(name.capitalized)"
            case 2:
                cellToReturn.textLabel?.text = "\(Game.awayTeam.capitalized) Captain: \(name.capitalized)"
            default:
                print("Error")
            }
        default:
            print("Error")
        }
        return cellToReturn
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch selectedIndex{
            case 0:
                Game.refereeNames.remove(at: indexPath.row)
            case 1:
                Game.caps.remove(at: indexPath.row)
            default:
                print("Error")
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
}

