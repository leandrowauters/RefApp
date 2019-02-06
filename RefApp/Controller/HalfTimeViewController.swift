//
//  HalfTimeViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/4/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class HalfTimeViewController: UIViewController {
    
    
    lazy var customSegmentedBar: UISegmentedControl = {
        var segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Events", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Subtitution", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Notes", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.orange
            ], for: .selected)
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCustomSegmentedBar()
        // Do any additional setup after loading the view.
    }
    
    func setUpCustomSegmentedBar() {
        view.addSubview(customSegmentedBar)
        customSegmentedBar.translatesAutoresizingMaskIntoConstraints = false
        customSegmentedBar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: ( ( -self.view.frame.height / 2) * 0.5)).isActive = true
        customSegmentedBar.centerXAnchor.constraint(equalToSystemSpacingAfter: self.view.centerXAnchor, multiplier: 0).isActive = true
        customSegmentedBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customSegmentedBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }

}
