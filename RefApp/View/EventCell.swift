//
//  EventCell.swift
//  RefApp
//
//  Created by Leandro Wauters on 3/4/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    var graphics = GraphicClient()
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellSubtitle: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        graphics.changeImageToRound(image: cellImage)
    }
}
