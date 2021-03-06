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
//        trackLayer.shouldRasterize = true
//        shapeLayer.shouldRasterize = true
        view.layer.addSublayer(shapeLayer)
        }
    }
    func setWheelToZero(view: UIView, radius: CGFloat){
        timerCircle(strokeValue: CGFloat(MainTimer.time) / CGFloat(((Game.lengthSelected / 2) * 60) + (((Game.lengthSelected / 2) * 60 ) / 3)), view: view, radius: radius)
    }
    func setTimerGraphics () {
       shapeLayer.strokeEnd = CGFloat(MainTimer.time) / CGFloat(((Game.lengthSelected / 2) * 60) + ((Game.lengthSelected / 2 * 60 ) / 3))
        if Int(MainTimer.time) == (((Game.lengthSelected / 2) * 60) - (((Game.lengthSelected / 2) * 60) / 10)) {
            shapeLayer.strokeColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            trackLayer.strokeColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
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
    static func doneButton(view: UIView, doneBtn: UIBarButtonItem, textFields: [UITextField]) {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Enter Player", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        for textField in textFields{
            textField.inputAccessoryView = toolbar
        }
    }
    func changeImageToRound(image: UIImageView) {
        image.layer.masksToBounds = true
        image.layer.cornerRadius = image.frame.width / 2
        image.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        image.layer.borderWidth = 2.0
    }
    func changeButtonLayout(buttons: [UIButton]) {
            for button in buttons{
                button.layer.masksToBounds = true
                button.layer.cornerRadius = button.frame.width / 2
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.layer.borderWidth = 2.0
                button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                button.titleLabel?.font = getHiraginoSansFont(W3: false, size: 30)
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
    func animateChangeColor (button: UIButton, color: UIColor) {
        fadeOut(button: button, 1, delay: 0.25) { (Bool) in
            button.alpha = 0
            button.backgroundColor = color
            self.fadeIn(button: button, 1, delay: 0, completion: { (Bool) in
                button.alpha = 1
            })
        }
    }
    func changeButtonColor (button: UIButton, color: UIColor){
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.borderWidth = 2.0
        button.backgroundColor = color
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = getHiraginoSansFont(W3: false, size: 30)
    }
    
    func addShadowToView(viewForShadow: UIView) {
        viewForShadow.layer.shadowColor = UIColor.black.cgColor
        viewForShadow.layer.shadowOpacity = 1
        viewForShadow.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewForShadow.layer.shadowRadius = 10
        viewForShadow.layer.shadowPath = UIBezierPath(rect: viewForShadow.bounds).cgPath
//        viewForShadow.layer.shouldRasterize = true
    }
    lazy var animatedView: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        return view
    }()
    
    lazy var animatedViewRail: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        return view
    }()
    func segmentedControlBar(titles: [String],numberOfSegments: Int) -> UISegmentedControl{
        let segmentedControl = UISegmentedControl()
        var segments = numberOfSegments - 1
        while segments >= 0{
            segmentedControl.insertSegment(withTitle: titles[segments], at: segments, animated: true)
            segments -= 1
        }
//        segmentedControl.insertSegment(withTitle: titles[0], at: 0, animated: true)
//        segmentedControl.insertSegment(withTitle: titles[1], at: 1, animated: true)
//        segmentedControl.insertSegment(withTitle: titles[2], at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        segmentedControl.tintColor = .clear
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : getHiraginoSansFont(W3: true, size: 18),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : getHiraginoSansFont(W3: false, size: 20),
            NSAttributedString.Key.foregroundColor: UIColor.orange
            ], for: .selected)
        
    
        return segmentedControl
    }
    func setupCustomSegmentedBar(view: UIView, customSegmentedBar: UISegmentedControl,height: Double) {
        view.addSubview(customSegmentedBar)
        customSegmentedBar.translatesAutoresizingMaskIntoConstraints = false
        customSegmentedBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: ( ( -view.frame.height / 2) * CGFloat(height))).isActive = true
        customSegmentedBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customSegmentedBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customSegmentedBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customSegmentedBar.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    func setupAnimatedView(view: UIView,animatedView: UIView, customSegmentedBar: UISegmentedControl,numberOfSegments: Int){
        view.addSubview(animatedView)
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        animatedView.topAnchor.constraint(equalTo: customSegmentedBar.bottomAnchor).isActive = true
        animatedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        animatedView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedView.widthAnchor.constraint(equalToConstant: view.frame.width / CGFloat(numberOfSegments)).isActive = true
        
    }
    func setupAnimatedViewRail(view: UIView, animatedViewRail: UIView, customSegmentedBar: UISegmentedControl){
        view.addSubview(animatedViewRail)
        animatedViewRail.translatesAutoresizingMaskIntoConstraints = false
        animatedViewRail.topAnchor.constraint(equalTo: customSegmentedBar.bottomAnchor).isActive = true
        animatedViewRail.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        animatedViewRail.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedViewRail.widthAnchor.constraint(equalTo: customSegmentedBar.widthAnchor).isActive = true
    }
    func getHiraginoSansFont(W3: Bool, size: Int) -> UIFont{
        if W3{
            if let hiraginoSansW3 = UIFont(name: "HiraginoSans-W3", size: CGFloat(size)) {
                return hiraginoSansW3
            }
        } else {
            if let hiraginoSansW6 = UIFont(name: "HiraginoSans-W6", size: CGFloat(size)) {
                return hiraginoSansW6
            }
        }
        return UIFont()
    }
    func attributedText(wordsToBold: String, string: String, fontSize: CGFloat) -> NSAttributedString {
        
        let string = string as NSString

        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 15 // Whatever line spacing you want in points
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font: getHiraginoSansFont(W3: true, size: Int(fontSize))])
        
        let boldFontAttribute = [NSAttributedString.Key.font: getHiraginoSansFont(W3: false, size: Int(fontSize))]
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: wordsToBold))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // 4
        return attributedString
    }

}
