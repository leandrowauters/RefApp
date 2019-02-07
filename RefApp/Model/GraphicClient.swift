//
//  Graphic Client.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class GraphicClient {
    
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    
    func timerCircle (strokeValue: CGFloat, view: UIView, radius: CGFloat?){
        let y = view.center.y * 0.4
        let x = view.center.x
        let position = CGPoint(x: x, y: y)
        if let radius = radius {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle:  0, endAngle: 2 * CGFloat.pi, clockwise: true)
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
    }
    func setWheelToZero(view: UIView, radius: CGFloat){
        timerCircle(strokeValue: CGFloat(MainTimer.time) / CGFloat(((Game.lengthSelected / 2) * 60) + (((Game.lengthSelected / 2) * 60 ) / 3)), view: view, radius: radius)
    }
    func setTimerGraphics () {
       shapeLayer.strokeEnd = CGFloat(MainTimer.time) / CGFloat(((Game.lengthSelected / 2) * 60) + ((Game.lengthSelected / 2 * 60 ) / 3))
        if Int(MainTimer.time) == (((Game.lengthSelected / 2) * 60) - (((Game.lengthSelected / 2) * 60) / 10)) {
            shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0.765635848, blue: 0, alpha: 1)
            trackLayer.strokeColor = #colorLiteral(red: 1, green: 0.868950069, blue: 0.4578225017, alpha: 1)
        }
        if Int(MainTimer.time) == (Game.lengthSelected / 2) * 60 {
            shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0, blue: 0.1359238923, alpha: 1)
            trackLayer.strokeColor = #colorLiteral(red: 1, green: 0.4121969342, blue: 0.4527801871, alpha: 1)
        }
    }
    func hideTimerWheel(isHidden: Bool) {
        trackLayer.isHidden = isHidden
        shapeLayer.isHidden = isHidden
    }
    func changeButtonLayout(buttons: [UIButton]) {
            for button in buttons{
                button.layer.masksToBounds = true
                button.layer.cornerRadius = button.frame.width / 2
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.layer.borderWidth = 2.0
                button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                button.titleLabel?.font = UIFont.init(name: "Verdana", size: 37)// THIS SETS FONT
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 37)
                //CREAT BUTTONS FOR EACH INSTANCE (YELLOW, RED, ....)
                //            button.layer.cornerRadius = 0.5 * button.bounds.size.width
                button.layer.masksToBounds = true
            }
        }

        func fadeIn(button: UIButton, _ duration: TimeInterval = 1.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
            UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
                button.alpha = 1.0
            }, completion: completion)  }
        func fadeOut(button: UIButton,_ duration: TimeInterval = 1.5, delay: TimeInterval = 2.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
            UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
                button.alpha = 0.1
            }, completion: completion)
        }
    
}
