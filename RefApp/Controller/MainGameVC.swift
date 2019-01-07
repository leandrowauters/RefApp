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
    let homeView: HomeView = Bundle.main.loadNibNamed("HomeView", owner: self, options: nil)?.first as! HomeView
    let awayView: AwayView = Bundle.main.loadNibNamed("AwayView", owner: self, options: nil)?.first as! AwayView
    static var turnOnTimer = Bool()
    static var timeStamp = String()
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    @IBOutlet weak var teamsScrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        delegate = self
        teamsScrollView.delegate = self
        let views:[UIView] = createViews()
        setupSlideScrollViews(views: views)
        pageControll.numberOfPages = views.count
        pageControll.currentPage = 0
        view.bringSubviewToFront(pageControll)
        timerLabel.text = timeString(time: TimeInterval(MainTimer.time))
        timerCircle(strokeValue: CGFloat(MainTimer.time) / CGFloat(((Game.lengthSelected / 2) * 60) + (((Game.lengthSelected / 2) * 60 ) / 3)))
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "selectPlayer") as? SelectPlayerVC else {return}
//        vc.timerDelegete = self
//    }
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
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
        self.timer.eventHandler = {
            self.action()
            MainTimer.time += 1
        }
        //        self.timer.resume()
    }
    func reloadView(){
        for button in homeView.HomePlayersButtons{
            if let text = button.titleLabel?.text {
                if Game.homeYellowCardPlayers.contains(Int(text)!){
                    button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                }
            }
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        if timer.state == .suspended {
        runTimer()
        }
        if timer.state == .restated {
            runTimer()
        }
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 1
//        basicAnimation.duration = 2
//        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
//        shapeLayer.add(basicAnimation, forKey: "Any")
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        //TO DO : it should be: suspend, send alert, display incident, and restart timer(if half == 2 timer == 0.
//        restartTimer()
        timer.suspend()

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

    func timerCircle (strokeValue: CGFloat){
        
        let y = view.center.y * 0.33
        let x = view.center.x
        let position = CGPoint(x: x, y: y)
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 80, startAngle:  0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.position = position
        view.layer.addSublayer(trackLayer)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0.6274659038, blue: 0, alpha: 1)
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
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

extension MainGameVC: TimerDelegate{
    func turnOnTimer(turnOn: Bool) {
         MainGameVC.turnOnTimer = turnOn
    }
}

