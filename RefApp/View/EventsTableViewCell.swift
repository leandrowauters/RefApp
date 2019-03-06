//
//  EventsTableViewCell.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/5/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    var graphics = GraphicClient()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        graphics.changeImageToRound(image: cellImage)
    }
    lazy var cellText: UILabel = {
       var label = UILabel()
        label.text = "Label"
        label.textColor = .white
        return label
    }()
    lazy var cellDetail: UILabel = {
       var label = UILabel()
        label.text = "Label"
        label.textColor = .white
        return label
    }()
    lazy var cellImage: UIImageView = {
        var image = UIImageView()
        return image
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default , reuseIdentifier: "HalfTimeEventCell")
        setupImage()
        backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        setupLabels()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupImage() {
        addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: (bounds.width / 2) * 0.7).isActive = true
        cellImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cellImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        cellImage.widthAnchor.constraint(equalTo: cellImage.heightAnchor, multiplier: 1).isActive = true
    }
    func setupLabels() {
        addSubview(cellDetail)
        addSubview(cellText)
        cellText.translatesAutoresizingMaskIntoConstraints = false
        cellDetail.translatesAutoresizingMaskIntoConstraints = false
        cellDetail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        cellDetail.trailingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: -15).isActive = true
        cellDetail.centerYAnchor.constraint(equalTo: cellImage.centerYAnchor, constant: (bounds.height / 2) * 0.8).isActive = true
        cellText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        cellText.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor).isActive = true
        cellText.bottomAnchor.constraint(equalTo: cellDetail.topAnchor, constant: -8).isActive = true
        
    }
}
