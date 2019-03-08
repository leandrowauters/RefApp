//
//  HalfTimeViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/4/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class HalfTimeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate {

    let events = Game.events
    let eventHalfTimeView = EventsView()
    let subHalftimeView = SubHalfTimeView()
    let noteHalfTimeView = NotesView()
    let graphics = GraphicClient()
    var gameRunningTime = 0.0
    weak var timerDelegate: TimerDelegate!
    weak var eventDelegate: EventDelegate!
    var views = [UIView]()
    
    @IBOutlet weak var halfTimeTeamsLabel: UILabel!
    
    @IBOutlet weak var halfTimeScoreLabel: UILabel!
    
    @IBOutlet weak var halfTimeTimeLabel: UILabel!
    
    lazy var customSegmentedBar: UISegmentedControl = graphics.segmentedControlBar(titles: ["Events", "Notes", "Sub"],numberOfSegments: 3)
    lazy var animatedView: UIView = graphics.animatedView
    lazy var animatedViewRail: UIView = graphics.animatedViewRail

    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHalfTimeView.eventsTableView.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        halfTimeTeamsLabel.text = "\(Game.homeTeam) Vs. \(Game.awayTeam)"
        halfTimeScoreLabel.text = "\(Game.homeScore) - \(Game.awayScore)"
        halfTimeTimeLabel.text = "\(MainTimer.timeString(time: gameRunningTime))"
        subHalftimeView.doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)

        views = [eventHalfTimeView,subHalftimeView,noteHalfTimeView]
        graphics.setupCustomSegmentedBar(view: view, customSegmentedBar: customSegmentedBar, height: 0.5)
        customSegmentedBar.addTarget(self, action: #selector(customSegmentedBarPressed(sender:)), for: UIControl.Event.valueChanged)
        graphics.setupAnimatedViewRail(view: view, animatedViewRail: animatedViewRail, customSegmentedBar: customSegmentedBar)
        graphics.setupAnimatedView(view: view, animatedView: animatedView, customSegmentedBar: customSegmentedBar, numberOfSegments: 3)
        setupViews(views: views)
        eventHalfTimeView.eventsTableView.dataSource = self
        eventHalfTimeView.eventsTableView.delegate = self
        subHalftimeView.playerInTextField.delegate = self
        subHalftimeView.playerOutTextField.delegate = self
        noteHalfTimeView.notesTextView.delegate = self
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Enter", style: .done, target: self, action: #selector(dismissKeyboard))
        GraphicClient.doneButton(view: self.view, doneBtn: doneBtn, textFields: [subHalftimeView.playerInTextField,subHalftimeView.playerOutTextField])
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    @objc func dismissKeyboard() {
         self.view.endEditing(true)
    }
    @IBAction func continuePressed(_ sender: UIButton) {
        self.eventDelegate.halfTime(bool: true)
        self.eventDelegate.redCard(bool: false, home: nil, away: nil)
        self.eventDelegate.yellowCall(bool: false, home: nil, away: nil)
        self.timerDelegate?.keepStartButtonDisable(disable: false)
        self.timerDelegate?.keepStartButtonHidden(hide: false)
        self.timerDelegate?.addTapAfterSub(add: false)
        timerDelegate.turnOnTimer(turnOn: false)
        
       dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        eventDelegate.halfTime(bool: true)
        eventDelegate.redCard(bool: false, home: nil, away: nil)
        eventDelegate.yellowCall(bool: false, home: nil, away: nil)
        timerDelegate?.keepStartButtonDisable(disable: false)
        timerDelegate?.keepStartButtonHidden(hide: false)
        timerDelegate?.addTapAfterSub(add: false)
        timerDelegate.turnOnTimer(turnOn: false)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTextView()
        registerKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregisterKeyboardNotifications()
    }

    func setTextView(){
        noteHalfTimeView.enterTextButton.addTarget(self, action: #selector(enterButtonPressed), for: .touchUpInside)
        if Game.gameNotes.count == 0 {
            noteHalfTimeView.notesTextView.text = "Tap to enter notes..."
        } else {
            noteHalfTimeView.notesTextView.textColor = .black
            
            noteHalfTimeView.notesTextView.text = Game.gameNotes.last
        }
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
        let view = views[customSegmentedBar.selectedSegmentIndex]
        view.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.height - self.customSegmentedBar.frame.height - animatedView.frame.height - view.frame.height))
        if view == noteHalfTimeView {
            view.bringSubviewToFront(noteHalfTimeView.enterTextButton)
            noteHalfTimeView.enterTextButton.transform = CGAffineTransform(translationX: 0, y: -(keyboardFrame.height-(self.view.frame.height - self.customSegmentedBar.frame.height - animatedView.frame.height - view.frame.height)))
        }
    }
    @objc private func willHideKeyboard(){
        let view = views[customSegmentedBar.selectedSegmentIndex]
        view.transform = CGAffineTransform.identity
        if view == noteHalfTimeView {
            noteHalfTimeView.enterTextButton.transform = CGAffineTransform.identity
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


    @objc func enterButtonPressed(){
        if noteHalfTimeView.notesTextView.text != "" {
            Game.gameNotes.append(noteHalfTimeView.notesTextView.text! + "\n")
            showAlert(title: "Text Saved", message: nil)
            print(Game.gameNotes)
        } else {
            showAlert(title: "Please Enter Text", message: nil)
        }
    }
    @objc func doneButtonPressed(){
        print("Home Before sub: \(Game.homePlayers)")
        print("Away Before sub: \(Game.awayPlayers)")
        var playerIn = Int()
        var playerOut = Int()
        if subHalftimeView.playerInTextField.text != "" && subHalftimeView.playerOutTextField.text != ""{
        if let text = subHalftimeView.playerInTextField.text {
            if let playerInNumber = Int(text){
                playerIn = playerInNumber
            }
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
        
        } else {
        showAlert(title: "Invalid Input", message: "Please have two players for substitution")
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
        if eventToSet.type == "Sub"{
            cell.cellText.text = "\(eventToSet.team) - Player in: \(eventToSet.subIn!) - Player out: \(eventToSet.playerNum)"
        } else {
            cell.cellText.text = "\(eventToSet.team) - Player: \(eventToSet.playerNum)"
        }
        cell.cellDetail.text = "Player: \(eventToSet.playerNum), Team: \(eventToSet.team)"
        cell.cellImage.backgroundColor = eventToSet.color
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteHalfTimeView.notesTextView.text == "Tap to enter notes..." {
            noteHalfTimeView.notesTextView.text = ""
            noteHalfTimeView.notesTextView.textColor = .black
        }
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
