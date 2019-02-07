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
    let graphics = GraphicClient()
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
        subHalftimeView.doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
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
    
    @objc func doneButtonPressed(){
        print("Home Before sub: \(Game.homePlayers)")
        print("Away Before sub: \(Game.awayPlayers)")
        var playerIn = Int()
        var playerOut = Int()
        if let text = subHalftimeView.playerInTextField.text {
            playerIn = Int(text)!
        }
        if let text = subHalftimeView.playerOutTextField.text {
            playerOut = Int(text)!
        }
        var index = 0
        if subHalftimeView.teamSegmentedBar.selectedSegmentIndex == 0 {
        perfomSub(team: &Game.homePlayers, playerIn: playerIn, playerOut: playerOut, index: &index)
            print("Home After sub: \(Game.homePlayers)")
       
        } else {
            perfomSub(team: &Game.awayPlayers, playerIn: playerIn, playerOut: playerOut, index: &index)
            print("Away After sub: \(Game.awayPlayers)")
        }
        

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

extension HalfTimeViewController {
    func perfomSub ( team: inout [Int], playerIn: Int, playerOut: Int, index: inout Int){
        if team.contains(playerIn) {
            print("Player Already Playing")
            showAlert(title: "Player Already Playing", message: "Please select another player")
            subHalftimeView.playerOutTextField.text = ""
            subHalftimeView.playerInTextField.text = ""
            return
        }
        for player in team {
            if Int(playerOut) == player{
                print(index)
                team.remove(at: index)
                team.insert(playerIn, at: index)
                subHalftimeView.textAnimationViewRight.isHidden = false
                subHalftimeView.textAnimationViewLeft.isHidden = false
                UIView.transition(with: subHalftimeView.textAnimationViewLeft, duration: 1, options: [.transitionFlipFromRight], animations: {
                    self.subHalftimeView.animatedLabelLeft.text = playerOut.description
                    self.subHalftimeView.playerInTextField.text = ""
                }) { (Bool) in
                    UIView.animate(withDuration: 1, delay: 0.5, options: [], animations: {
                        self.subHalftimeView.animatedLabelLeft.alpha = 0
                    }, completion: { (Bool) in
                        self.subHalftimeView.animatedLabelLeft.alpha = 1
                        self.subHalftimeView.textAnimationViewLeft.isHidden = true
                        self.subHalftimeView.playerInTextField.isHidden = false
                    })
                }
                
                UIView.transition(with: subHalftimeView.textAnimationViewRight, duration: 1, options: [.transitionFlipFromRight], animations: {
                    self.subHalftimeView.animatedLabelRight.text = playerIn.description
                    self.subHalftimeView.playerOutTextField.text = ""
                }) { (Bool) in
                    UIView.animate(withDuration: 1, delay: 0.5, options: [], animations: {
                        self.subHalftimeView.animatedLabelRight.alpha = 0
                    }, completion: { (Bool) in
                        self.subHalftimeView.animatedLabelRight.alpha = 1
                        self.subHalftimeView.textAnimationViewRight.isHidden = true
                        self.subHalftimeView.playerOutTextField.isHidden = false
                    })
                }
                break
            } else {
                index += 1
            }
            if index == team.count - 1{
                showAlert(title: "Player Not Playing", message: "Please select another player")
                subHalftimeView.playerOutTextField.text = ""
                subHalftimeView.playerInTextField.text = ""
                print("No Player Found")
            }
            
        }
    }
}
