//
//  EventsViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/13/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    
    weak var timerDelegate: TimerDelegate!
    weak var eventDelegate: EventDelegate!
    var events = Game.events
    let detailView = EventVCDetails()
    let textDetailView = EventVCTextView()
    var views = [UIView]()
    lazy var customSegmentedBar: UISegmentedControl = {
        var segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Events", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Details", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Text", at: 2, animated: true)
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
    
    @IBOutlet weak var eventTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        views = [eventTableView,detailView,textDetailView]
        views.first?.isHidden = false
        setupAnimatedViewRail()
        setupCustomSegmentedBar()
        setupAnimatedView()
        setupViews(views: views)
        setupDetailView()
        eventTableView.dataSource = self
        eventTableView.delegate = self
        textDetailView.notesTextView.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        setTextView()
    }

    func setupCustomSegmentedBar() {
        view.addSubview(customSegmentedBar)
        customSegmentedBar.translatesAutoresizingMaskIntoConstraints = false
        customSegmentedBar.centerXAnchor.constraint(equalTo: eventTableView.centerXAnchor).isActive = true
        
        customSegmentedBar.bottomAnchor.constraint(equalTo: animatedViewRail.topAnchor).isActive = true
        customSegmentedBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        customSegmentedBar.widthAnchor.constraint(equalTo: eventTableView.widthAnchor).isActive = true

        customSegmentedBar.addTarget(self, action: #selector(customSegmentedBarPressed(sender:)), for: UIControl.Event.valueChanged)
    }
    func setupAnimatedView(){
        view.addSubview(animatedView)
//        animatedView.centerXAnchor.constraint(equalTo: eventTableView.centerXAnchor).isActive = true
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        animatedView.topAnchor.constraint(equalTo: customSegmentedBar.bottomAnchor).isActive = true
        animatedView.leadingAnchor.constraint(equalTo: animatedViewRail.leadingAnchor).isActive = true
        animatedView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedView.widthAnchor.constraint(equalTo: animatedViewRail.widthAnchor, multiplier: 0.33).isActive = true   
    }
    func setupAnimatedViewRail(){
        
        view.addSubview(animatedViewRail)
        animatedViewRail.translatesAutoresizingMaskIntoConstraints = false
        animatedViewRail.centerXAnchor.constraint(equalTo: eventTableView.centerXAnchor).isActive = true
        animatedViewRail.bottomAnchor.constraint(equalTo: eventTableView.topAnchor).isActive = true
        animatedViewRail.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedViewRail.widthAnchor.constraint(equalTo: eventTableView.widthAnchor).isActive = true
    }
    func setupDetailView(){
        detailView.yellowCardLabelHome.text = "Home: \(Game.homeYellowCardPlayers.description)"
        detailView.yellowCardLabelAway.text = "Away: \(Game.awayYellowCardPlayers.description)"
        detailView.redCardLabelHome.text = "Home: \(Game.homeRedCardPlayers.description)"
        detailView.redCardLabelAway.text = "Away: \(Game.awayRedCardPlayers.description)"
        detailView.goalLabelHome.text = "Home: \(Game.homeGoalsPlayers.description)"
        detailView.goalLabelAway.text = "Home: \(Game.awayGoalsPlayers.description)"
    }
    func setupViews(views: [UIView]){
        for view in views{
            self.view.addSubview(view)
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.centerXAnchor.constraint(equalTo: eventTableView.centerXAnchor).isActive = true
                    view.centerYAnchor.constraint(equalTo: eventTableView.centerYAnchor).isActive = true
                    view.heightAnchor.constraint(equalTo: eventTableView.heightAnchor).isActive = true
                    view.widthAnchor.constraint(equalTo: eventTableView.widthAnchor).isActive = true
                    view.isHidden = true
        }
        views.first?.isHidden = false
    }
    

    @IBAction func dismiss(_ sender: UIButton) {
       
        dismiss()
        
    }
    func dismiss() {
        eventDelegate.halfTime(bool: false)
        timerDelegate?.keepStartButtonDisable(disable: true)
        timerDelegate?.keepStartButtonHidden(hide: true)
        eventDelegate.redCard(bool: false, home: nil, away: nil)
        eventDelegate.yellowCall(bool: false, home: nil, away: nil)
        dismiss(animated: true, completion: nil)
    }
    @objc func enterButtonPressed(){
        if textDetailView.notesTextView.text != "" {
            Game.gameNotes.append(textDetailView.notesTextView.text! + "\n")
            showAlert(title: "Text Saved", message: "") { (UIAlertController) in
                self.dismiss()
            }
            print(Game.gameNotes)
        } else {
            showAlert(title: "Please Enter Text", message: nil)
        }
        
    }
    func setTextView(){
        textDetailView.enterTextButton.addTarget(self, action: #selector(enterButtonPressed), for: .touchUpInside)
        if Game.gameNotes.count == 0 {
            textDetailView.notesTextView.text = "Tap to enter notes..."
        } else {
            textDetailView.notesTextView.textColor = .black
            textDetailView.notesTextView.text = Game.gameNotes.last
        }
    }
    @objc func customSegmentedBarPressed(sender: UISegmentedControl){
        for i in 0...views.count - 1 {
            if i == sender.selectedSegmentIndex{
                views[i].isHidden = false
            } else {
                views[i].isHidden = true
            }
        }
        let selectorStartPosition = self.eventTableView.frame.width / CGFloat(3) * CGFloat(sender.selectedSegmentIndex)
        UIView.animate(withDuration: 0.3) {
            self.animatedView.frame.origin.x = selectorStartPosition + (self.view.frame.width - self.eventTableView.frame.width) / 2
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let eventToSet = events[indexPath.row]
        cell.textLabel?.text = "\(eventToSet.team) - Player: \(eventToSet.playerNum)"
        cell.backgroundColor = eventToSet.color
        cell.detailTextLabel?.text = eventToSet.timeStamp
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textDetailView.notesTextView.text == "Tap to enter notes..." {
            textDetailView.notesTextView.text = ""
            textDetailView.notesTextView.textColor = .black
        }
    }
}
