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
    
    func timerCircle (strokeValue: CGFloat, view: UIView){
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
    func setWheelToZero(view: UIView){
        timerCircle(strokeValue: CGFloat(MainTimer.time) / CGFloat(((Game.lengthSelected / 2) * 60) + (((Game.lengthSelected / 2) * 60 ) / 3)), view: view)
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
    
}
