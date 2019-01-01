//
//  MainGameVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class MainGameVC: UIViewController, UIScrollViewDelegate {
    
    var time = 0
    var timer = Timer()
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    @IBOutlet weak var teamsScrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        teamsScrollView.delegate = self
        let views:[UIView] = createViews()
        setupSlideScrollViews(views: views)
        pageControll.numberOfPages = views.count
        pageControll.currentPage = 0
        view.bringSubviewToFront(pageControll)
        timerLabel.text = timeString(time: TimeInterval(time))
        timerCircle()
        
    }
    @IBAction func startButton(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainGameVC.action), userInfo: nil, repeats: true)
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 1
//        basicAnimation.duration = 2
//        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
//        shapeLayer.add(basicAnimation, forKey: "Any")
    }
    @IBAction func pauseButton(_ sender: UIButton) {
        timer.invalidate()
    }
    
    @objc func action() {
        
        time += 1
        timerLabel.text = timeString(time: TimeInterval(time))
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = CGFloat(self.time) / CGFloat((Game.lengthSelected * 60) + ((Game.lengthSelected * 60 ) / 3))
            if self.time == ((Game.lengthSelected * 60) - ((Game.lengthSelected * 60) / 10)) {
                self.shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0.765635848, blue: 0, alpha: 1)
                self.trackLayer.strokeColor = #colorLiteral(red: 1, green: 0.868950069, blue: 0.4578225017, alpha: 1)
            }
            if self.time == Game.lengthSelected * 60 {
                self.shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0, blue: 0.1359238923, alpha: 1)
                self.trackLayer.strokeColor = #colorLiteral(red: 1, green: 0.4121969342, blue: 0.4527801871, alpha: 1)
            }
        }
    }
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    func timerCircle (){
        
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
        shapeLayer.strokeEnd = 0
        shapeLayer.position = position
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
        
    }
    func createViews () -> [UIView] {
        let view1: HomeView = Bundle.main.loadNibNamed("HomeView", owner: self, options: nil)?.first as! HomeView
        view1.homeLabel.text = "\(Game.homeTeam)"
//        view1.testLabel.text = "View 1"
        for index in 0...Game.numberOfPlayers - 1 {
            view1.HomePlayersButtons[index].isHidden = false
            view1.HomePlayersButtons[index].setTitle(Game.homePlayersSorted[index].description, for: .normal)
        }
        
        let view2: AwayView = Bundle.main.loadNibNamed("AwayView", owner: self, options: nil)?.first as! AwayView
//        view2.testLabel.text = "View 2"
        
    return [view1, view2]
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

