//
//  SubHalfTimeView.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/5/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class SubHalfTimeView: UIView {

    lazy var teamSegmentedBar: UISegmentedControl = {
        var segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Home", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Away", at: 1, animated: true)
        segmentedControl.backgroundColor = #colorLiteral(red: 0.354026258, green: 0.7636645436, blue: 0.9697399735, alpha: 1)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .clear
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22.0),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .selected)
        return segmentedControl
    }()
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Enter Substitution"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var playerInTextField: UITextField = {
       var textField = UITextField()
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "In",attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textAlignment = .center
        textField.borderStyle = .line
        textField.font = UIFont.systemFont(ofSize: 35)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
        
    }()
    lazy var playerOutTextField: UITextField = {
        var textField = UITextField()
           textField.textColor = .white
           textField.attributedPlaceholder = NSAttributedString(string: "Out",attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textAlignment = .center
        textField.borderStyle = .line
        textField.font = UIFont.systemFont(ofSize: 35)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }()
    
    lazy var animatedView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var image: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "substitution")
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.2737779021, green: 0.4506875277, blue: 0.6578510404, alpha: 1)
        addSegmentedBar()
        setupAnimatedView()
        addLabel()
        addPlayerInTextField()
        addPlayerOutTextField()
        addImage()
        
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

    func performSub(playerNumber: Int){
        var index = 0
        for player in Game.homePlayers {
            if playerNumber == player{
                index += 1
                print(index)
//                Game.homePlayers.remove(at: index)
//                Game.homePlayers.insert(playerNumber, at: index)
            } else {
                index += 1
            }
        }
    }
}
