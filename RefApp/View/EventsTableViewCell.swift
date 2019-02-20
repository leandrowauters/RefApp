//
//  EventsTableViewCell.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/5/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    lazy var typeLabel: UILabel = {
       var label = UILabel()
        label.text = "Label"
        label.textColor = .white
        return label
    }()
    lazy var playerLabel: UILabel = {
       var label = UILabel()
        label.text = "Label"
        label.textColor = .white
        return label
    }()
    lazy var timeStampLabel: UILabel = {
        var label = UILabel()
        label.text = "Label"
        label.textColor = .white 
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default , reuseIdentifier: "HalfTimeEventCell")
        setupLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabels() {
        addSubview(typeLabel)
        addSubview(playerLabel)
        addSubview(timeStampLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        timeStampLabel.translatesAutoresizingMaskIntoConstraints = false
        playerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11).isActive = true
        playerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 11).isActive = true
        typeLabel.bottomAnchor.constraint(equalTo: playerLabel.topAnchor, constant: -30).isActive = true
        typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11).isActive = true
        typeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11).isActive = true
        timeStampLabel.topAnchor.constraint(equalTo: playerLabel.bottomAnchor, constant: 30).isActive = true
        timeStampLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11).isActive = true
        timeStampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11).isActive = true
    }
}
