//
//  HalfTimeViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/4/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class HalfTimeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let events = Game.events
    let eventHalfTimeView = EventHalfTimeView()
    let subHalftimeView = SubHalfTimeView()
    let noteHalfTimeView = NoteHalfTimeView()
    var views = [UIView]()
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
        views = [eventHalfTimeView,subHalftimeView,noteHalfTimeView]
        setupCustomSegmentedBar()
        setupViews(views: views)
        eventHalfTimeView.eventsTableView.dataSource = self
        eventHalfTimeView.eventsTableView.delegate = self
        
    }
    
    func setupCustomSegmentedBar() {
        view.addSubview(customSegmentedBar)
        customSegmentedBar.translatesAutoresizingMaskIntoConstraints = false
        customSegmentedBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: ( ( -view.frame.height / 2) * 0.5)).isActive = true
        customSegmentedBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customSegmentedBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customSegmentedBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customSegmentedBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        customSegmentedBar.addTarget(self, action: #selector(customSegmentedBarPressed(sender:)), for: UIControl.Event.valueChanged)
    }
    @objc func customSegmentedBarPressed(sender: UISegmentedControl){
        for i in 0...views.count - 1 {
            if i == sender.selectedSegmentIndex{
                views[i].isHidden = false
            } else {
                views[i].isHidden = true
            }
        }
    }
    func setupViews(views: [UIView]){
        for view in views{
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: customSegmentedBar.bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            view.isHidden = true
        }
        views.first?.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HalfTimeEventCell", for: indexPath) as? EventsTableViewCell else {print("Cell Not Working")
            return UITableViewCell()
        }
        let eventToSet = events[indexPath.row]
        cell.typeLabel.text = eventToSet.type
        cell.playerLabel.text = "Player: \(eventToSet.playerNum), Team: \(eventToSet.team)"
        cell.timeStampLabel.text = "Timestamp: \(eventToSet.timeStamp)"
        cell.backgroundColor = eventToSet.color
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

}
