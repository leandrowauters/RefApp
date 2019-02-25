//
//  MainGameVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class MainGameVC: UIViewController, UIScrollViewDelegate {
    
//    var time = 0
    let graphics = GraphicClient()
    var timer = MainTimer(timeInterval: 0.0001)
    weak var delegate: TimerDelegate!
    weak var eventDelegte: EventDelegate!
    var currentBackgroundDate = NSDate()
    lazy var viewWidth = (timer2View.bounds.height / 2) - 30
    static var hide = false
    static var disable = false
    static var yellowCard = false
    static var sub = false
    static var redCard = false
    static var halfTime = false
    static var timerViewOne = true
    static var playerSelected = String()
    static var substitution = false
    static var playerIn = String()
    static var playerOut = String()
    static var home = true
    static var away = true
    static var index = Int()
    static var scrollToAway = false
    private var usersession: UserSession?
    let homeView2 = HomeView()
    let homeView: HomeView = Bundle.main.loadNibNamed("HomeView", owner: self, options: nil)?.first as! HomeView
    let awayView: AwayView = Bundle.main.loadNibNamed("AwayView", owner: self, options: nil)?.first as! AwayView
    static var turnOnTimer = Bool()
    static var timeStamp = String()

    @IBOutlet weak var startButton: UIButton!
    
//    let shapeLayer = CAShapeLayer()
//    let trackLayer = CAShapeLayer()
    @IBOutlet weak var teamsScrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet var timerLabels: [UILabel]!
    
    @IBOutlet weak var halfLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var changeTimerButton: UIButton!
    
    @IBOutlet weak var timer2View: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        homeView.HomePlayersButtons.forEach{$0.isEnabled = false}
        awayView.awayPlayersButtons.forEach{$0.isEnabled = false}
        print("The view height is: \(timer2View.bounds.height)")
        NotificationCenter.default.addObserver(self, selector: #selector(pauseTimer), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startApp) , name: UIApplication.didBecomeActiveNotification, object: nil)
        scoreLabel.text = "\(Game.homeTeam) \(Game.homeScore) - \(Game.awayTeam) \(Game.awayScore)"
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideTimerView))
        timer2View.addGestureRecognizer(tap)
        for index in 0...timerLabels.count - 1 {
            switch index {
            case 0:
                timerLabels[index].font = UIFont.monospacedDigitSystemFont(ofSize: 53, weight: .regular)
            case 1:
                timerLabels[index].font = UIFont.monospacedDigitSystemFont(ofSize: 25, weight: .bold)
            default:
                print("Timer Label Index Error")
                
            }
        }
        timer2View.isHidden = true
        changeTimerButton.isHidden = true
        if MainGameVC.sub{
            homeView.HomePlayersButtons.forEach{$0.isEnabled = true}
            awayView.awayPlayersButtons.forEach{$0.isEnabled = true}
            if MainGameVC.timerViewOne{
            timer2View.isHidden = true
            } else {
            timer2View.isHidden = false
            graphics.hideTimerWheel(isHidden: true)
            }
            changeTimerButton.isHidden = false
        }
//        setWheelToZero()
        
        delegate = self
        eventDelegte = self
        teamsScrollView.delegate = self
        let views:[UIView] = createViews()
        setupSlideScrollViews(views: views)
        pageControll.numberOfPages = views.count
        pageControll.currentPage =  0

        view.bringSubviewToFront(pageControll)
        for label in timerLabels{
            label.text = MainTimer.timeString(time: TimeInterval(MainTimer.time))
        }
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "selectPlayer") as? SelectPlayerVC else {return}
//        vc.timerDelegete = self
//    }
    override func viewWillAppear(_ animated: Bool) {
        setupButtons()
        reloadView()
        if MainGameVC.scrollToAway{
            teamsScrollView.scrollRectToVisible(CGRect(x: view.frame.width * CGFloat(1), y: 0, width: view.frame.width, height: view.frame.height / 2), animated: true)
        }
        minutesLabel.text = "\(Game.lengthSelected / 2) Mins"
        if Game.gameHalf == 1 {
            halfLabel.text =  "1st Half"
        } else if Game.gameHalf == 2 {
            halfLabel.text = "2nd Half"
        }
        if MainGameVC.halfTime {
            startButton.setTitle("Begin 2nd Half", for: .normal)
            startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            graphics.setWheelToZero(view: self.view, radius: viewWidth)
//            self.startButton.isHidden = false
//            self.startButton.isEnabled = true
            MainGameVC.halfTime = false
        }

        print("Start button hidden = \(startButton.isHidden)")
        print("Start button enable = \(startButton.isEnabled)")
        startButton.isHidden = MainGameVC.hide
        startButton.isEnabled = !MainGameVC.disable
        timerLabels.forEach {$0.isHidden = !MainGameVC.hide}
        halfLabel.isHidden = !MainGameVC.hide
        minutesLabel.isHidden = !MainGameVC.hide
//        MainTimer.time = -1
        DispatchQueue.main.async {
            if MainGameVC.turnOnTimer{
                MainGameVC.turnOnTimer = false
                print("Timer is running")
//                self.runTimer()
                self.graphics.timerCircle(strokeValue: CGFloat(MainTimer.time) / CGFloat(((Game.lengthSelected / 2) * 60) + (((Game.lengthSelected / 2) * 60 ) / 3)), view: self.view, radius: self.viewWidth)
                self.timer.eventHandler = {
                    self.action()
                }
                self.timer.resume()
            }
        }

        for incident in Game.events{
            print(incident)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EventsViewController else {return}
        destination.eventDelegate = self
        destination.timerDelegate = self
    }
    func runTimer (){
        timer.eventHandler = {
            MainTimer.time += 0.0001
            self.action()
        }
        timer.resume()
    }
    @objc func pauseTimer() {
        timer.suspend()
        currentBackgroundDate = NSDate()
    }
    @objc func startApp(){
        let difference = self.currentBackgroundDate.timeIntervalSince(NSDate() as Date)
        let timeSince = abs(difference)
        MainTimer.time += timeSince
        timer.eventHandler = {
            MainTimer.time += 0.0001
            self.action()
        }
        timer.resume()
    }

    
    func setupButtons () {
        for index in 0...Game.numberOfPlayers - 1 {
            homeView.HomePlayersButtons[index].isHidden = false
            awayView.awayPlayersButtons[index].isHidden = false
            homeView.HomePlayersButtons[index].setTitle(Game.homePlayers[index].description, for: .normal)
            awayView.awayPlayersButtons[index].setTitle(Game.awayPlayers[index].description, for: .normal)
        }
    }
    func reloadView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideTimerView))
        timer2View.addGestureRecognizer(tap)
        scoreLabel.text = "\(Game.homeTeam) \(Game.homeScore) - \(Game.awayTeam) \(Game.awayScore)"
        if MainGameVC.home{
        for button in homeView.HomePlayersButtons{
            if let text = button.titleLabel?.text {
                if MainGameVC.yellowCard{
                if text == MainGameVC.playerSelected{
                    graphics.animateChangeColor(button: button, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                }
                } else if Game.homeYellowCardPlayers.contains(Int(text)!) {
                    graphics.changeButtonColor(button: button, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                }
                if MainGameVC.redCard{
                    if text == MainGameVC.playerSelected{
                        graphics.animateChangeColor(button: button, color: #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1))
                        button.isEnabled = false
                    }

                    }
                else if Game.homeRedCardPlayers.contains(Int(text)!) {
                    graphics.changeButtonColor(button: button, color: #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1))
                    button.isEnabled = false
                }
            }
//                if MainGameVC.substitution{
//                    if MainGameVC.home{
//                    if button.tag == MainGameVC.index {
//                        graphics.fadeOut(button: button,0.5 , delay: 0.5) { (Done) in
//                            button.setTitle(MainGameVC.playerIn, for: .normal)
//                            self.graphics.fadeIn(button: button, 0.5, delay: 0) { (Done) in
//                                button.setTitle(MainGameVC.playerIn, for: .normal)
////                                Game.homePlayers.remove(at: MainGameVC.index)
////                                Game.homePlayers.insert(Int(MainGameVC.playerIn)!, at: Int(MainGameVC.index))
//                                print(MainGameVC.index)
//                                print(MainGameVC.playerIn)
//                                print("Home Players = \(Game.homePlayers)")
//                            }
//                        }
//
//                    }
//                }
//                }

            
        }
        }
        if MainGameVC.away{
        for button in awayView.awayPlayersButtons{
            if let text = button.titleLabel?.text {
                if MainGameVC.yellowCard{
                    if text == MainGameVC.playerSelected{
                        graphics.animateChangeColor(button: button, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                    }
                } else if Game.awayYellowCardPlayers.contains(Int(text)!) {
                    graphics.changeButtonColor(button: button, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                }
                if MainGameVC.redCard{
                    if text == MainGameVC.playerSelected{
                        graphics.animateChangeColor(button: button, color: #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1))
                        button.isEnabled = false
                    }
                }
                else if Game.awayRedCardPlayers.contains(Int(text)!) {
                    graphics.changeButtonColor(button: button, color: #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1))
                    button.isEnabled = false
                }
            }
//                if MainGameVC.substitution{
//                    if !MainGameVC.home{
//                    if text == MainGameVC.playerOut {
//                        graphics.fadeOut(button: button,0.5 , delay: 0.5) { (Done) in
//                            button.setTitle(MainGameVC.playerIn, for: .normal)
//                            self.graphics.fadeIn(button: button, 0.5, delay: 0) { (Done) in
//                                button.setTitle(MainGameVC.playerIn, for: .normal)
//                                Game.awayPlayers.remove(at: MainGameVC.index)
//                                Game.awayPlayers.insert(Int(MainGameVC.playerIn)!, at: Int(MainGameVC.index))
//                                print(MainGameVC.index)
//                                print(MainGameVC.playerIn)
//                                print("Away Players = \(Game.awayPlayers)")
//                            }
//                        }
//                        }
//                    }
//                }
            
            }
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        print("start was pressed")
        changeTimerButton.isHidden = false
        graphics.setWheelToZero(view: self.view, radius: viewWidth)
        homeView.HomePlayersButtons.forEach{$0.isEnabled = true}
        awayView.awayPlayersButtons.forEach{$0.isEnabled = true}
        if timer.state == .suspended {
        runTimer()
        }
        if timer.state == .restated {
            runTimer()
        }
      
        UIView.animate(withDuration: 0.5, animations: {
            self.startButton.isHidden = false
            self.startButton.alpha = 0.0
            self.timerLabels.forEach {$0.isHidden = true}
            self.halfLabel.isHidden = true
            self.minutesLabel.isHidden = true
        }) { (Bool) in
            self.startButton.alpha = 1.0
            self.startButton.isHidden = true
            self.startButton.isEnabled = true
            self.timerLabels.forEach {$0.isHidden = false}
            self.halfLabel.isHidden = false
            self.minutesLabel.isHidden = false
        }

//        startButton.isHidden = true
//        startButton.isEnabled = true
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 1
//        basicAnimation.duration = 2
//        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
//        shapeLayer.add(basicAnimation, forKey: "Any")
    }
    
    @IBAction func halfTimeButtonPressed(_ sender: UIButton) {
        //TO DO : it should be: suspend, send alert, display incident, and restart timer(if half == 2 timer == 0.
        if Game.gameHalf == 1 {
        let alert = UIAlertController(title: "You're about to end the half", message: "Press OK to continue", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (updateAction) in

            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "HalfTime") as? HalfTimeViewController else {return}
            vc.timerDelegate = self
            vc.eventDelegate = self
            vc.gameRunningTime = MainTimer.time
            self.present(vc, animated: false, completion: nil) //TO DO: PRESENT THE OTHER VIEW
            self.changeTimerButton.isHidden = true
//            MainGameVC.halfTime = true
            MainTimer.time = 0
            Game.gameHalf = 2
            
            self.timer.restartTimer()
        }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        } else if Game.gameHalf == 2 {
            let alert = UIAlertController(title: "You're about the end the game", message: "Press OK to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (updateAction) in
                
                print("Game ended")
                let gameData: GameData!
                if let user = self.usersession?.getCurrentUser(){
                    let gameStatistics = GameStatistics(userID: user.uid,winnerSide: GameStatistics.getWinnerHomeAway(), winnerTeam: GameStatistics.getWinnerTeam(),totalRunningTime: 4, homeYellowCards: GameStatistics.homeYellowCards, awayYellowCards: GameStatistics.awayYellowCards, homeRedCards: GameStatistics.homeRedCard, awayRedCards: GameStatistics.awayRedCard, homeGoals: Game.homeScore, awayGoals: Game.awayScore)
                    gameData = GameData(userID: user.uid, winner:GameStatistics.getWinnerHomeAway() , gameName: Game.gameName ?? "no name", lengthSelected: Game.lengthSelected, numberOfPlayers: Game.numberOfPlayers, location: Game.location, dateAndTime: Game.dateAndTime, league: Game.league, refereeNames: Game.refereeNames, caps: Game.caps, extraTime: Game.extraTime, homeTeam: Game.homeTeam, awayTeam: Game.awayTeam, homeScore: Game.homeScore, awayScore: Game.awayScore, totalRunningTime: 4, subs: Game.numberOfSubs, homePlayers: Game.homePlayers, awayPlayers: Game.awayPlayers, homeYellowCardPlayers: Game.homeYellowCardPlayers, homeRedCardPlayers: Game.homeRedCardPlayers, awayYellowCardPlayers: Game.awayYellowCardPlayers, awayRedCardPlayers: Game.awayRedCardPlayers, homeGoalsPlayers: Game.homeGoalsPlayers, awayGoalsPlayers: Game.awayGoalsPlayers, gameNotes: Game.gameNotes)
                    DatabaseManager.postGameStatisticsToDatabase(gameStatistics: gameStatistics)
                    DatabaseManager.postGameDataToDatabase(gameData: gameData)
                } else {
                    gameData = GameData(userID: "no id", winner:GameStatistics.getWinnerHomeAway() , gameName: Game.gameName ?? "no name", lengthSelected: Game.lengthSelected, numberOfPlayers: Game.numberOfPlayers, location: Game.location, dateAndTime: Game.dateAndTime, league: Game.league, refereeNames: Game.refereeNames, caps: Game.caps, extraTime: Game.extraTime, homeTeam: Game.homeTeam, awayTeam: Game.awayTeam, homeScore: Game.homeScore, awayScore: Game.awayScore, totalRunningTime: 4, subs: Game.numberOfSubs, homePlayers: Game.homePlayers, awayPlayers: Game.awayPlayers, homeYellowCardPlayers: Game.homeYellowCardPlayers, homeRedCardPlayers: Game.homeRedCardPlayers, awayYellowCardPlayers: Game.awayYellowCardPlayers, awayRedCardPlayers: Game.awayRedCardPlayers, homeGoalsPlayers: Game.homeGoalsPlayers, awayGoalsPlayers: Game.awayGoalsPlayers, gameNotes: Game.gameNotes)
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "gameSummary") as? GameSummaryViewController else {return}
                vc.gameData = gameData
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        }

        


    }
    
    @IBAction func changeTimerWasPressed(_ sender: UIButton) {
        print("change timer was pressed")
        graphics.hideTimerWheel(isHidden: true)
        timer2View.isHidden = false
        MainGameVC.timerViewOne = false
    }
    
    @objc func hideTimerView(){
        timer2View.isHidden = true
        MainGameVC.timerViewOne = true
        graphics.hideTimerWheel(isHidden: false)
        self.timer2View.isHidden = true
       
    }
    
    
    @objc func action() {
        DispatchQueue.main.async {
            MainGameVC.timeStamp = MainTimer.timeString(time: TimeInterval(MainTimer.time))
            for timeLabel in self.timerLabels {
                if MainGameVC.timerViewOne{
                    timeLabel.text = MainTimer.timeString(time: TimeInterval(MainTimer.time))
                } else {
                    timeLabel.text = MainTimer.timeStringWithMilSec(time: TimeInterval(MainTimer.time))
                }
                
            }
            self.graphics.setTimerGraphics()
        }
    }
    func createViews () -> [UIView] {
        homeView.homeLabel.text = "\(Game.homeTeam)"
        awayView.awayLabel.text = "\(Game.awayTeam)"
        
        homeView.buttons()
        awayView.changeButton()
//        view1.testLabel.text = "View 1"
        for index in 0...Game.numberOfPlayers - 1 {
            homeView.HomePlayersButtons[index].isHidden = false
            awayView.awayPlayersButtons[index].isHidden = false
            homeView.HomePlayersButtons[index].setTitle(Game.homePlayers[index].description, for: .normal)
            awayView.awayPlayersButtons[index].setTitle(Game.awayPlayers[index].description, for: .normal)
        }
    return [homeView, awayView]
    }
    
    func setupSlideScrollViews(views: [UIView]){
        teamsScrollView.frame = CGRect (x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        teamsScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height / 2)
        teamsScrollView.isPagingEnabled = true
        for i in 0...views.count - 1 {
            views[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height / 2)
        teamsScrollView.addSubview(views[i])
            
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControll.currentPage = Int(pageIndex)
    }
    
}

extension MainGameVC: TimerDelegate, EventDelegate{

    
    func hideChangeScreenButton(hide: Bool) {
        changeTimerButton.isHidden = hide
    }
    
//    func substitution(playerIn: String, playerOut: String, home: Bool, index: Int) {
//        MainGameVC.playerIn = playerIn
//        MainGameVC.playerOut = playerOut
//        MainGameVC.home = home
//        MainGameVC.index = index
//    }
    
    func subWasMade(bool: Bool, scrollToAway: Bool) {
        MainGameVC.home = bool
        MainGameVC.away = bool
        MainGameVC.scrollToAway = scrollToAway
    }
    
    func yellowCall(bool: Bool, home: Bool?, away: Bool?) {
        MainGameVC.yellowCard = bool
        if let home = home{
        MainGameVC.home = home
        }
        if let away = away{
        MainGameVC.away = away
        }
    }
    
    func redCard(bool: Bool, home: Bool?, away: Bool?) {
        MainGameVC.redCard = bool
        if let home = home{
            MainGameVC.home = home
        }
        if let away = away{
            MainGameVC.away = away
        }
    }
    

    
    func activateViewDidAppear(bool: Bool) {
        viewWillAppear(bool)
    }
    
    func playerSelected(player: String) {
        MainGameVC.playerSelected = player
    }
    
    func addTapAfterSub(add: Bool) {
        MainGameVC.sub = add
    }
    
    func halfTime(bool: Bool) {
        MainGameVC.halfTime = bool
    }
    
    func redCard(bool: Bool) {
        MainGameVC.redCard = bool
    }
    
    func yellowCall(bool: Bool) {
        MainGameVC.yellowCard = bool
    }
    
    func keepStartButtonDisable(disable: Bool) {
        MainGameVC.disable = disable
    }
    
    func keepStartButtonHidden(hide: Bool) {
        MainGameVC.hide = hide
    }
    
    func turnOnTimer(turnOn: Bool) {
         MainGameVC.turnOnTimer = turnOn
    }
}


