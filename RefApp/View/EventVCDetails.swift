//
//  EventVCDetails.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/12/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class EventVCDetails: UIView {
    var graphics = GraphicClient()
    lazy var teamsLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Game.homeTeam) vs. \(Game.awayTeam)"
        label.textAlignment = .center
        label.textColor = .white
        label.font = graphics.getHiraginoSansFont(W3: true, size: 20)
        return label
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0 - 0"
        label.textAlignment = .center
        label.textColor = .white
        label.font = graphics.getHiraginoSansFont(W3: true, size: 20)
        return label
    }()
    lazy var redCardImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "redCard")

        return image
    }()
    lazy var yellowCardImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "yellowCard")

        return image
    }()
    lazy var goalImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "goal")
       
        return image
    }()
    lazy var yellowCardLabelHome: UILabel = {
       var label = UILabel()
        label.text = "Home:"
        label.textColor = .white
        label.numberOfLines = 5
        label.font = graphics.getHiraginoSansFont(W3: true, size: 20)
        return label
    }()
    lazy var yellowCardLabelAway: UILabel = {
        var label = UILabel()
        label.text = "Away:"
        label.textColor = .white
        label.numberOfLines = 5
        label.font = graphics.getHiraginoSansFont(W3: true, size: 20)
        return label
    }()
    lazy var goalLabelHome: UILabel = {
        var label = UILabel()
        label.text = "Home:"
        label.textColor = .white
        label.numberOfLines = 5
        label.font = graphics.getHiraginoSansFont(W3: true, size: 20)
        return label
    }()
    lazy var goalLabelAway: UILabel = {
        var label = UILabel()
        label.text = "Away:"
        label.textColor = .white
        label.numberOfLines = 5
        label.font = graphics.getHiraginoSansFont(W3: true, size: 20)
        return label
    }()
    lazy var redCardLabelHome: UILabel = {
        var label = UILabel()
        label.text = "Home:"
        label.textColor = .white
        label.numberOfLines = 5
        label.font = graphics.getHiraginoSansFont(W3: true, size: 20)
        return label
    }()
    lazy var redCardLabelAway: UILabel = {
        var label = UILabel()
        label.text = "Away:"
        label.textColor = .white
        label.numberOfLines = 5
        label.font = graphics.getHiraginoSansFont(W3: true, size: 20)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        setupTeamsLabel()
        setupScoreLabel()
        setupYellowCardImage()
        setupRedCardImage()
        setupGoalImage()
        setupYellowCardLabels(labels: [yellowCardLabelAway, yellowCardLabelHome])
        setupRedCardLabels(labels: [redCardLabelHome,redCardLabelAway])
        setupGoalLabels(labels: [goalLabelHome,goalLabelAway])
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupTeamsLabel(){
        addSubview(teamsLabel)
        teamsLabel.translatesAutoresizingMaskIntoConstraints = false
        teamsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        teamsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11).isActive = true
        teamsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11).isActive = true
    }
    func setupScoreLabel(){
        addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.topAnchor.constraint(equalTo: teamsLabel.bottomAnchor, constant: 10).isActive = true
        scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11).isActive = true
    }
    func setupYellowCardImage(){
        addSubview(yellowCardImage)
        yellowCardImage.translatesAutoresizingMaskIntoConstraints = false
        yellowCardImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -115).isActive = true
        yellowCardImage.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 30).isActive = true
        yellowCardImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        yellowCardImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setupRedCardImage() {
        addSubview(redCardImage)
        redCardImage.translatesAutoresizingMaskIntoConstraints = false
        redCardImage.centerXAnchor.constraint(equalTo: yellowCardImage.centerXAnchor).isActive = true
        redCardImage.topAnchor.constraint(equalTo: yellowCardImage.bottomAnchor, constant: 30).isActive = true
        redCardImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        redCardImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupGoalImage() {
        addSubview(goalImage)
        goalImage.translatesAutoresizingMaskIntoConstraints = false
        goalImage.centerXAnchor.constraint(equalTo: redCardImage.centerXAnchor).isActive = true
        goalImage.topAnchor.constraint(equalTo: redCardImage.bottomAnchor, constant: 30).isActive = true
        goalImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        goalImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupYellowCardLabels(labels: [UILabel]){
        for label in labels {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
//        label.centerYAnchor.constraint(equalTo: yellowCardImage.centerYAnchor).isActive = true
        }
        
        yellowCardLabelHome.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 30).isActive = true
        yellowCardLabelHome.leadingAnchor.constraint(equalTo: yellowCardImage.trailingAnchor, constant: 10).isActive = true
        yellowCardLabelAway.topAnchor.constraint(equalTo: yellowCardLabelHome.bottomAnchor, constant: 2).isActive = true
        yellowCardLabelAway.leadingAnchor.constraint(equalTo: yellowCardImage.trailingAnchor, constant: 10).isActive = true
    }
    func setupRedCardLabels(labels: [UILabel]){
        for label in labels {
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
            
        }
        redCardLabelHome.topAnchor.constraint(equalTo: yellowCardLabelAway.bottomAnchor, constant: 30).isActive = true
        redCardLabelHome.leadingAnchor.constraint(equalTo: redCardImage.trailingAnchor, constant: 10).isActive = true
        redCardLabelAway.topAnchor.constraint(equalTo: redCardLabelHome.bottomAnchor, constant: 2).isActive = true
        redCardLabelAway.leadingAnchor.constraint(equalTo: redCardImage.trailingAnchor, constant: 10).isActive = true
    }
    func setupGoalLabels(labels: [UILabel]){
        for label in labels {
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        }
        goalLabelHome.topAnchor.constraint(equalTo: redCardLabelAway.bottomAnchor, constant: 30).isActive = true
        goalLabelHome.leadingAnchor.constraint(equalTo: goalImage.trailingAnchor, constant: 10).isActive = true
        goalLabelAway.topAnchor.constraint(equalTo: goalLabelHome.bottomAnchor, constant: 2).isActive = true
        goalLabelAway.leadingAnchor.constraint(equalTo: goalImage.trailingAnchor, constant: 10).isActive = true
    }
}
