//
//  HalfTimeViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/4/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class HalfTimeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    let events = Game.events
    let eventHalfTimeView = EventHalfTimeView()
    let subHalftimeView = SubHalfTimeView()
    let noteHalfTimeView = NoteHalfTimeView()
    var views = [UIView]()
    lazy var customSegmentedBar: UISegmentedControl = {
        var segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Events", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Subtitution", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Notes", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = #colorLiteral(red: 0.2567201853, green: 0.4751234055, blue: 0.4362891316, alpha: 1)
        segmentedControl.tintColor = .clear
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22.0),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .selected)
        return segmentedControl
    }()
    
    lazy var animatedView: UIView = {
       var view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var animatedViewRail: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2567201853, green: 0.4751234055, blue: 0.4362891316, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subHalftimeView.doneButton.addTarget(self, action: #selector(performSub), for: .touchUpInside)
        views = [eventHalfTimeView,subHalftimeView,noteHalfTimeView]
        setupCustomSegmentedBar()
        setupAnimatedViewRail()
        setupAnimatedView()
        setupViews(views: views)
        eventHalfTimeView.eventsTableView.dataSource = self
        eventHalfTimeView.eventsTableView.delegate = self
        subHalftimeView.playerInTextField.delegate = self
        subHalftimeView.playerOutTextField.delegate = self
        
    }
    
    func setupCustomSegmentedBar() {
        view.addSubview(customSegmentedBar)
        customSegmentedBar.translatesAutoresizingMaskIntoConstraints = false
        customSegmentedBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: ( ( -view.frame.height / 2) * 0.5)).isActive = true
        customSegmentedBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customSegmentedBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customSegmentedBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customSegmentedBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        customSegmentedBar.addTarget(self, action: #selector(customSegmentedBarPressed(sender:)), for: UIControl.Event.valueChanged)
    }
    @objc func customSegmentedBarPressed(sender: UISegmentedControl){
        for i in 0...views.count - 1 {
            if i == sender.selectedSegmentIndex{
                views[i].isHidden = false
            } else {
                views[i].isHidden = true
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.animatedView.frame.origin.x = (self.customSegmentedBar.frame.width / CGFloat(self.customSegmentedBar.numberOfSegments)) * CGFloat(self.customSegmentedBar.selectedSegmentIndex)
        }
    }
    func setupViews(views: [UIView]){
        for view in views{
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: animatedView.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            view.isHidden = true
        }
        views.first?.isHidden = false
    }
    func setupAnimatedView(){
        view.addSubview(animatedView)
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        animatedView.topAnchor.constraint(equalTo: customSegmentedBar.bottomAnchor).isActive = true
        animatedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        animatedView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedView.widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
        
    }
    func setupAnimatedViewRail(){
        view.addSubview(animatedViewRail)
        animatedViewRail.translatesAutoresizingMaskIntoConstraints = false
        animatedViewRail.topAnchor.constraint(equalTo: customSegmentedBar.bottomAnchor).isActive = true
        animatedViewRail.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        animatedViewRail.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedViewRail.widthAnchor.constraint(equalTo: customSegmentedBar.widthAnchor).isActive = true
    }
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okay)
        present(alert, animated: true, completion: nil)
        
    }
    @objc func performSub(){
        print("Before sub: \(Game.homePlayers)")
        var playerIn = String()
        var playerOut = String()
        if let text = subHalftimeView.playerInTextField.text {
            playerIn = text
        }
        if let text = subHalftimeView.playerOutTextField.text {
            playerOut = text
        }
        var index = 0
        if Game.homePlayers.contains(Int(playerIn)!) {
            print("Player Already Playing")
            showAlert(title: "Player Already Playing", message: "Please select another player")
            return
        }
        for player in Game.homePlayers {
            if Int(playerOut) == player{
                print(index)
                Game.homePlayers.remove(at: index)
                Game.homePlayers.insert(Int(playerIn)!, at: index)
                break
            } else {
                index += 1
            }
            if index == Game.homePlayers.count - 1{
                showAlert(title: "Player Not Playing", message: "Please select another player")
                print("No Player Found")
            }
            
        }
        print("After Sub: \(Game.homePlayers)")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HalfTimeEventCell", for: indexPath) as? EventsTableViewCell else {print("Cell Not Working")
            return UITableViewCell()
        }
        let eventToSet = events[indexPath.row]
        cell.typeLabel.text = eventToSet.type
        cell.playerLabel.text = "Player: \(eventToSet.playerNum), Team: \(eventToSet.team)"
        cell.timeStampLabel.text = "Timestamp: \(eventToSet.timeStamp)"
        cell.backgroundColor = eventToSet.color
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == subHalftimeView.playerInTextField{
            subHalftimeView.playerInTextField.placeholder = ""
        } else {
            subHalftimeView.playerOutTextField.placeholder = ""
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
