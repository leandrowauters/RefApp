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
    var timer = MainTimer(timeInterval: 1)
    var delegate: TimerDelegate!
    var eventDelegte: EventDelegate!
    static var hide = false
    static var disable = false
    static var yellowCard = false
    static var redCard = false
    static var halfTime = false
    
    let homeView: HomeView = Bundle.main.loadNibNamed("HomeView", owner: self, options: nil)?.first as! HomeView
    let awayView: AwayView = Bundle.main.loadNibNamed("AwayView", owner: self, options: nil)?.first as! AwayView
    static var turnOnTimer = Bool()
    static var timeStamp = String()

    @IBOutlet weak var startButton: UIButton!
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    @IBOutlet weak var teamsScrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var halfLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var changeTimerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTimerButton.isHidden = true
        setWheelToZero()
        delegate = self
        teamsScrollView.delegate = self
        let views:[UIView] = createViews()
        setupSlideScrollViews(views: views)
        pageControll.numberOfPages = views.count
        pageControll.currentPage = 0
        view.bringSubviewToFront(pageControll)
        timerLabel.text = timeString(time: TimeInterval(MainTimer.time))


    }

//    override func viewWillDisappear(_ animated: Bool) {
//        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "selectPlayer") as? SelectPlayerVC else {return}
//        vc.timerDelegete = self
//    }
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
        minutesLabel.text = "\(Game.lengthSelected / 2) Mins"
        if Game.gameHalf == 1 {
            halfLabel.text =  "1st Half"
        } else if Game.gameHalf == 2 {
            halfLabel.text = "2nd Half"
        }
        if MainGameVC.halfTime {
            setWheelToZero()
//            self.startButton.isHidden = false
//            self.startButton.isEnabled = true
            MainGameVC.halfTime = false
        }
        print("Timer label status: \(timerLabel.isHidden)")
        print("Start button hidden = \(startButton.isHidden)")
        print("Start button enable = \(startButton.isEnabled)")
        startButton.isHidden = MainGameVC.hide
        startButton.isEnabled = !MainGameVC.disable
        timerLabel.isHidden = !MainGameVC.hide
        halfLabel.isHidden = !MainGameVC.hide
        minutesLabel.isHidden = !MainGameVC.hide
//        MainTimer.time = -1
        DispatchQueue.main.async {
            if MainGameVC.turnOnTimer{
                print("Timer is running")
//                self.runTimer()
                self.timerCircle(strokeValue: CGFloat(MainTimer.time) / CGFloat(((Game.lengthSelected / 2) * 60) + (((Game.lengthSelected / 2) * 60 ) / 3)))
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
            MainTimer.time += 1
            self.action()
        }
        timer.resume()
    }
    func restartTimer(){
        timer.suspend()
        timer.state = .restated
        MainTimer.time = -1
//        self.timer.eventHandler = {
//            self.action()
//            MainTimer.time += 1
//        }
        //        self.timer.resume()
    }
    func animateChangeColor (button: UIButton, color: UIColor) {
        button.alpha = 0.0
        button.backgroundColor = .clear
        UIView.animate(withDuration: 1, animations: {
            button.alpha = 0.5
            button.backgroundColor = color
            
        }) { (Bool) in
            button.backgroundColor = color
            button.alpha = 1.0
        }
    }
    func reloadView(){
        
        for button in homeView.HomePlayersButtons{
            if let text = button.titleLabel?.text {
                if MainGameVC.yellowCard{
                if Game.homeYellowCardPlayers.contains(Int(text)!){
                    animateChangeColor(button: button, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                }
                } else if Game.homeYellowCardPlayers.contains(Int(text)!) {
                    button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }
                if MainGameVC.redCard{
                    if Game.homeRedCardPlayers.contains(Int(text)!){
                        animateChangeColor(button: button, color: #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1))
                        button.isEnabled = false
                    }

                    }
                else if Game.homeRedCardPlayers.contains(Int(text)!) {
                    button.backgroundColor = #colorLiteral(red: 0.995932281, green: 0.2765177786, blue: 0.3620784283, alpha: 1)
                    button.isEnabled = false
                }
            }
        }
        for button in awayView.awayPlayersButtons{
            if let text = button.titleLabel?.text {
                if Game.awayYellowCardPlayers.contains(Int(text)!){
                    button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }
            }
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        print("start was pressed")
        changeTimerButton.isHidden = false
        if timer.state == .suspended {
        runTimer()
        }
        if timer.state == .restated {
            runTimer()
        }
      
        UIView.animate(withDuration: 0.5, animations: {
            
            self.startButton.isHidden = false
            self.startButton.alpha = 0.0
            self.timerLabel.isHidden = true
            self.halfLabel.isHidden = true
            self.minutesLabel.isHidden = true
        }) { (Bool) in
            self.startButton.alpha = 1.0
            self.startButton.isHidden = true
            self.startButton.isEnabled = true
            self.timerLabel.isHidden = false
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
    
    @IBAction func pauseButton(_ sender: UIButton) {
        //TO DO : it should be: suspend, send alert, display incident, and restart timer(if half == 2 timer == 0.

        let alert = UIAlertController(title: "You're about to end the half", message: "Press OK to continue", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (updateAction) in

                        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "EventsVC") as? EventsViewController else {return}
            vc.timerDelegate = self
            vc.eventDelegate = self
            self.present(vc, animated: false, completion: nil)

            MainGameVC.halfTime = true
            Game.gameHalf = 2
            self.restartTimer()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: false)
        


    }
    
    @IBAction func changeTimerWasPressed(_ sender: UIButton) {
        print("change timer was pressed")
    }
    
    
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    @objc func action() {
        DispatchQueue.main.async {
            MainGameVC.timeStamp = self.timeString(time: TimeInterval(MainTimer.time))
            self.timerLabel.text = self.timeString(time: TimeInterval(MainTimer.time))
            
            self.shapeLayer.strokeEnd = CGFloat(MainTimer.time) / CGFloat(((Game.lengthSelected / 2) * 60) + ((Game.lengthSelected / 2 * 60 ) / 3))
            if MainTimer.time == (((Game.lengthSelected / 2) * 60) - (((Game.lengthSelected / 2) * 60) / 10)) {
                self.shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0.765635848, blue: 0, alpha: 1)
                self.trackLayer.strokeColor = #colorLiteral(red: 1, green: 0.868950069, blue: 0.4578225017, alpha: 1)
            }
            if MainTimer.time == (Game.lengthSelected / 2) * 60 {
                self.shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0, blue: 0.1359238923, alpha: 1)
                self.trackLayer.strokeColor = #colorLiteral(red: 1, green: 0.4121969342, blue: 0.4527801871, alpha: 1)
            }
        }
    }
    func setWheelToZero(){
        timerCircle(strokeValue: CGFloat(MainTimer.time) / CGFloat(((Game.lengthSelected / 2) * 60) + (((Game.lengthSelected / 2) * 60 ) / 3)))
    }
    func timerCircle (strokeValue: CGFloat){
        
        let y = view.center.y * 0.4
        let x = view.center.x
        let position = CGPoint(x: x, y: y)
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 115, startAngle:  0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 20
        trackLayer.position = position
        view.layer.addSublayer(trackLayer)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0.6274659038, blue: 0, alpha: 1)
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.strokeEnd = strokeValue
        shapeLayer.position = position
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
        
    }
    func createViews () -> [UIView] {

        homeView.homeLabel.text = "\(Game.homeTeam)"
        awayView.awayLabel.text = "\(Game.awayTeam)"
//        view1.testLabel.text = "View 1"
        for index in 0...Game.numberOfPlayers - 1 {
            homeView.HomePlayersButtons[index].isHidden = false
            awayView.awayPlayersButtons[index].isHidden = false
            homeView.HomePlayersButtons[index].setTitle(Game.homePlayersSorted[index].description, for: .normal)
            awayView.awayPlayersButtons[index].setTitle(Game.awayPlayersSorted[index].description, for: .normal)
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

