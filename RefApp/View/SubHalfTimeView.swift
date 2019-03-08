//
//  SubHalfTimeView.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/5/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class SubHalfTimeView: UIView {
    var graphics = GraphicClient()
    lazy var teamSegmentedBar: UISegmentedControl = graphics.segmentedControlBar(titles: ["Home", "Away"], numberOfSegments: 2)
    lazy var animatedView: UIView = graphics.animatedView
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Enter Substitution"
        label.textColor = .white
        label.font = graphics.getHiraginoSansFont(W3: false, size: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var playerInTextField: UITextField = {
       var textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "In",attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textAlignment = .center
        textField.borderStyle = .line
        textField.font = graphics.getHiraginoSansFont(W3: true, size: 35)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
        
    }()
    lazy var playerOutTextField: UITextField = {
        var textField = UITextField()
        textField.keyboardType = .numberPad
           textField.textColor = .white
           textField.attributedPlaceholder = NSAttributedString(string: "Out",attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textAlignment = .center
        textField.borderStyle = .line
        textField.font = graphics.getHiraginoSansFont(W3: true, size: 35)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }()
    lazy var doneButton: UIButton = {
        var button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        return button
    }()

    
    lazy var image: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "substitution")
        return image
    }()
    
    lazy var textAnimationViewLeft: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.isHidden = true
        view.addSubview(animatedLabelLeft)
        return view
    }()
    
    lazy var textAnimationViewRight: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.isHidden = true
        view.addSubview(animatedLabelRight)
        return view
    }()
    lazy var animatedLabelLeft: UILabel = {
        var label = UILabel()
        label.text = "4"
        label.textColor = .white
        label.font = graphics.getHiraginoSansFont(W3: true, size: 35)
        label.textAlignment = .center
        return label
    }()
    
    lazy var animatedLabelRight: UILabel = {
        var label = UILabel()
        label.text = "5"
        label.textColor = .white
        label.font = graphics.getHiraginoSansFont(W3: true, size: 35)
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        addSegmentedBar()
        setupAnimatedView()
        addLabel()
        addPlayerInTextField()
        addPlayerOutTextField()
        addImage()
        addDoneButton()
        addLeftAnimatedTextView()
        addRightAnimatedTextView()
        addLeftAnimtedLabel()
        addRightAnimatedLabel()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSegmentedBar(){
        addSubview(teamSegmentedBar)
        teamSegmentedBar.translatesAutoresizingMaskIntoConstraints = false
        teamSegmentedBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        teamSegmentedBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        teamSegmentedBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        teamSegmentedBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        teamSegmentedBar.addTarget(self, action: #selector(segmentedBarPressed(sender:)), for: UIControl.Event.valueChanged)
    }
    @objc func segmentedBarPressed(sender: UISegmentedControl){
        UIView.animate(withDuration: 0.3) {
            self.animatedView.frame.origin.x = (self.teamSegmentedBar.frame.width / CGFloat(self.teamSegmentedBar.numberOfSegments)) * CGFloat(self.teamSegmentedBar.selectedSegmentIndex)
        }
    }
    func addLabel(){
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: teamSegmentedBar.bottomAnchor, constant: 30).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    func addPlayerInTextField(){
        addSubview(playerInTextField)
        playerInTextField.translatesAutoresizingMaskIntoConstraints = false
        playerInTextField.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -95).isActive = true
        playerInTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        playerInTextField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        playerInTextField.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    func addPlayerOutTextField(){
        addSubview(playerOutTextField)
        playerOutTextField.translatesAutoresizingMaskIntoConstraints = false
        playerOutTextField.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 95).isActive = true
        playerOutTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        playerOutTextField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        playerOutTextField.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    func setupAnimatedView(){
        addSubview(animatedView)
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        animatedView.topAnchor.constraint(equalTo: teamSegmentedBar.bottomAnchor).isActive = true
        animatedView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        animatedView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedView.widthAnchor.constraint(equalTo: teamSegmentedBar.widthAnchor, multiplier: 0.5).isActive = true
    }
    func addImage(){
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerYAnchor.constraint(equalTo: playerInTextField.centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func addDoneButton() {
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    func addLeftAnimatedTextView(){
        addSubview(textAnimationViewLeft)
        textAnimationViewLeft.translatesAutoresizingMaskIntoConstraints = false
        textAnimationViewLeft.heightAnchor.constraint(equalTo: playerInTextField.heightAnchor).isActive = true
        textAnimationViewLeft.widthAnchor.constraint(equalTo: playerInTextField.widthAnchor).isActive = true
        textAnimationViewLeft.centerXAnchor.constraint(equalTo: playerInTextField.centerXAnchor).isActive = true
        textAnimationViewLeft.centerYAnchor.constraint(equalTo: playerInTextField.centerYAnchor).isActive = true
        
    }
    
    func addRightAnimatedTextView(){
        addSubview(textAnimationViewRight)
        textAnimationViewRight.translatesAutoresizingMaskIntoConstraints = false
        textAnimationViewRight.heightAnchor.constraint(equalTo: playerOutTextField.heightAnchor).isActive = true
        textAnimationViewRight.widthAnchor.constraint(equalTo: playerOutTextField.widthAnchor).isActive = true
        textAnimationViewRight.centerXAnchor.constraint(equalTo: playerOutTextField.centerXAnchor).isActive = true
        textAnimationViewRight.centerYAnchor.constraint(equalTo: playerOutTextField.centerYAnchor).isActive = true
        
    }
    func addLeftAnimtedLabel() {
        animatedLabelLeft.translatesAutoresizingMaskIntoConstraints = false
        animatedLabelLeft.centerXAnchor.constraint(equalTo: textAnimationViewLeft.centerXAnchor).isActive = true
        animatedLabelLeft.centerYAnchor.constraint(equalTo: textAnimationViewLeft.centerYAnchor).isActive = true
        animatedLabelLeft.leadingAnchor.constraint(equalTo: textAnimationViewLeft.leadingAnchor).isActive = true
        animatedLabelLeft.trailingAnchor.constraint(equalTo: textAnimationViewLeft.trailingAnchor).isActive = true
        
    }
    func addRightAnimatedLabel() {
        animatedLabelRight.translatesAutoresizingMaskIntoConstraints = false
        animatedLabelRight.centerXAnchor.constraint(equalTo: textAnimationViewRight.centerXAnchor).isActive = true
        animatedLabelRight.centerYAnchor.constraint(equalTo: textAnimationViewRight.centerYAnchor).isActive = true
        animatedLabelRight.leadingAnchor.constraint(equalTo: textAnimationViewRight.leadingAnchor).isActive = true
        animatedLabelRight.trailingAnchor.constraint(equalTo: textAnimationViewRight.trailingAnchor).isActive = true
    }
}
