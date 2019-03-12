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
    var gameClient = GameClient()
    let detailView = EventVCDetails()
    let textDetailView = NotesView()
    let graphics = GraphicClient()
    var views = [UIView]()
    lazy var customSegmentedBar: UISegmentedControl = graphics.segmentedControlBar(titles: ["Events", "Notes", "Details"], numberOfSegments: 3)
    lazy var animatedView: UIView = graphics.animatedView
    lazy var animatedViewRail: UIView = graphics.animatedViewRail

    
    @IBOutlet weak var eventTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        eventTableView.tableFooterView = UIView()
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
        registerKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }
    private func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc private func willShowKeyboard(notification: Notification){
        guard let info = notification.userInfo,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
                
                print("UserInfo is nil")
                return
        }
        let tableViewHeight = eventTableView.frame.height
        let view = views[customSegmentedBar.selectedSegmentIndex]
        if view == textDetailView {
            view.bringSubviewToFront(textDetailView.enterTextButton)
            textDetailView.enterTextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + ((self.view.frame.height - tableViewHeight) / 2))
        }
    }
    @objc private func willHideKeyboard(){
        let view = views[customSegmentedBar.selectedSegmentIndex]
        view.transform = CGAffineTransform.identity
        if view == textDetailView {
            textDetailView.enterTextButton.transform = CGAffineTransform.identity
        }
        
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
        detailView.yellowCardLabelHome.text = "Home: \(gameClient.convertIntArrayToString(array: Game.homeYellowCardPlayers) ?? "")"
        detailView.yellowCardLabelAway.text = "Away: \(gameClient.convertIntArrayToString(array: Game.awayYellowCardPlayers) ?? "")"
        detailView.redCardLabelHome.text = "Home: \(gameClient.convertIntArrayToString(array: Game.homeRedCardPlayers) ?? "")"
        detailView.redCardLabelAway.text = "Away: \(gameClient.convertIntArrayToString(array: Game.awayRedCardPlayers) ?? "")"
        detailView.goalLabelHome.text = "Home: \(gameClient.convertIntArrayToString(array: Game.homeGoalsPlayers) ?? "")"
        detailView.goalLabelAway.text = "Away: \(gameClient.convertIntArrayToString(array: Game.awayGoalsPlayers) ?? "")"
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
        tableView.register(EventsTableViewCell.self, forCellReuseIdentifier: "HalfTimeEventCell")
        guard let cell = eventTableView.dequeueReusableCell(withIdentifier: "HalfTimeEventCell", for: indexPath) as? EventsTableViewCell else {return UITableViewCell()}
        let eventToSet = events[indexPath.row]
        if eventToSet.type == "Sub"{
            cell.cellText.text = "\(eventToSet.team) - Player in: \(eventToSet.subIn!) - Player out: \(eventToSet.playerNum)"
        } else {
            cell.cellText.text = "\(eventToSet.team) - Player: \(eventToSet.playerNum)"
        }
        cell.cellImage.backgroundColor = eventToSet.color
        cell.cellDetail.text =  eventToSet.timeStamp
        cell.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
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
