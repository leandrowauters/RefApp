//
//  GameSummaryViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/23/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class GameSummaryViewController: UIViewController {
    
    
    lazy var customSegmentedBar: UISegmentedControl = graphics.segmentedControlBar(titles: ["Summary", "Notes", "Events"],numberOfSegments: 3)
    lazy var animatedView: UIView = graphics.animatedView
    lazy var animatedViewRail: UIView = graphics.animatedViewRail
    
    @IBOutlet weak var gameTeamsLabel: UILabel!
    @IBOutlet weak var gameScoreLabel: UILabel!
    @IBOutlet weak var gameTimeLabel: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var topView: UIView!
    
    let events = Game.events
    let notesView = NotesView()
    let eventsView = EventsView()
    let infoView: MyAccountInfoView = Bundle.main.loadNibNamed("MyAccountInfoView", owner: self, options: nil)?.first as! MyAccountInfoView
    var views = [UIView]()
    var graphics = GraphicClient()
    var gameData: GameData!
    var gameStatistics: GameStatistics?
    var gameRunningTime = 0.0
    var rootViewController: RootViewController?
    var gameStatisticInfo = [String](){
        didSet{
            infoView.infoTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        notesView.notesTextView.delegate = self
        if rootViewController == .myAccount{
            customSegmentedBar = graphics.segmentedControlBar(titles: ["Summary", "Notes"],numberOfSegments: 2)
            views = [infoView,notesView]
            gameTimeLabel.text = "\(gameData.dateAndTime)"
        } else {
            views = [infoView,eventsView,notesView]
            gameTimeLabel.text = "\(MainTimer.timeString(time: gameRunningTime))"
        }
        navigationBar.barTintColor = UIColor.black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        customSegmentedBar.addTarget(self, action: #selector(customSegmentedBarPressed(sender:)), for: UIControl.Event.valueChanged)
        gameTeamsLabel.text = "\(gameData.homeTeam) Vs. \(gameData.awayTeam)"
        gameScoreLabel.text = "\(gameData.homeScore) - \(gameData.awayScore)"
        
        // Do any additional setup after loading the view.
        eventsView.eventsTableView.delegate = self
        eventsView.eventsTableView.dataSource = self
        infoView.infoTableView.delegate = self
        infoView.infoTableView.dataSource = self
        graphics.setupCustomSegmentedBar(view: view, customSegmentedBar: customSegmentedBar, height: 0.3)
        graphics.setupAnimatedViewRail(view: view, animatedViewRail: animatedViewRail, customSegmentedBar: customSegmentedBar)
        if rootViewController == .myAccount{
            graphics.setupAnimatedView(view: view, animatedView: animatedView, customSegmentedBar: customSegmentedBar, numberOfSegments: 2)
        } else {
            graphics.setupAnimatedView(view: view, animatedView: animatedView, customSegmentedBar: customSegmentedBar, numberOfSegments: 3)
        }

        setupViews(views: views)
        if rootViewController == .myAccount{
        gameStatisticInfo = GameData.getGameData(gameData: gameData)
        } else {
        gameStatisticInfo = GameData.getEndOFGameData(gameData: gameData)
         
        }
        
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
        notesView.enterTextButton.addTarget(self, action: #selector(enterButtonPressed), for: .touchUpInside)
        if Game.gameNotes.count == 0 {
            notesView.notesTextView.text = "Tap to enter notes..."
        } else {
            notesView.notesTextView.textColor = .black
            notesView.notesTextView.text = Game.gameNotes.last
        }
    }
    @objc func enterButtonPressed(){
        if notesView.notesTextView.text != "" {
            Game.gameNotes.append(notesView.notesTextView.text! + "\n")
            showAlert(title: "Text Saved", message: nil)
            print(Game.gameNotes)
        } else {
            showAlert(title: "Please Enter Text", message: nil)
        }
    }
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
            if rootViewController == .myAccount{
                dismiss(animated: true, completion: nil)
            } else {
                if let gameStatistics = gameStatistics{
                DatabaseManager.postGameStatisticsToDatabase(gameStatistics: gameStatistics)
                DatabaseManager.postGameDataToDatabase(gameData: gameData)
                Game.setVariableToDefaultValues()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainScreen = storyboard.instantiateViewController(withIdentifier: "navigationController")
                self.present(mainScreen, animated: true, completion: nil)
                }
            }
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let mainScreen = storyboard.instantiateViewController(withIdentifier: "navigationController")
//            self.navigationController?.pushViewController(mainScreen, animated: true)
        
    }
    @IBAction func deleteWasPressed(_ sender: UIBarButtonItem) {
        showAlert(title: "Delete?", message: "Are you sure?", style: .alert, customActionTitle: "Delete", cancelActionTitle: "No") { (action) in
            Game.setVariableToDefaultValues()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainScreen = storyboard.instantiateViewController(withIdentifier: "navigationController")
            self.present(mainScreen, animated: true, completion: nil)
        }
    }
    
    @objc private func willShowKeyboard(notification: Notification){
        guard let info = notification.userInfo,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
                
                print("UserInfo is nil")
                return
        }
        let view = views[customSegmentedBar.selectedSegmentIndex]
        view.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.height - self.customSegmentedBar.frame.height - animatedView.frame.height - view.frame.height))
        if view == notesView {
            view.bringSubviewToFront(notesView.enterTextButton)
            notesView.enterTextButton.transform = CGAffineTransform(translationX: 0, y: -(keyboardFrame.height-(self.view.frame.height - self.customSegmentedBar.frame.height - animatedView.frame.height - view.frame.height)))
        }
    }
    @objc private func willHideKeyboard(){
        let view = views[customSegmentedBar.selectedSegmentIndex]
        view.transform = CGAffineTransform.identity
        if view == notesView {
            notesView.enterTextButton.transform = CGAffineTransform.identity
        }
        
    }
    private func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
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
    
}
extension GameSummaryViewController: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == infoView.infoTableView{
            return gameStatisticInfo.count
        } else {
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == infoView.infoTableView{
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "myAccountCell")
            cell.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = graphics.getHiraginoSansFont(W3: false, size: 20)
            cell.detailTextLabel?.textColor = .white
            cell.detailTextLabel?.font = graphics.getHiraginoSansFont(W3: false, size: 17)
            let statToSet = gameStatisticInfo[indexPath.row]
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.text = statToSet
        } else {
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
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == infoView.infoTableView{
            return 100
        }
        return 150
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        notesView.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            notesView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesView.notesTextView.text == "Tap to enter notes..." {
            notesView.notesTextView.text = ""
            notesView.notesTextView.textColor = .black
        }
    }
}
