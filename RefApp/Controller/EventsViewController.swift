//
//  EventsViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/13/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    weak var timerDelegate: TimerDelegate!
    weak var eventDelegate: EventDelegate!
    var events = Game.events
    
    @IBOutlet weak var eventTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.dataSource = self
        eventTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        if MainGameVC.halfTime {
            eventDelegate.halfTime(bool: true)
            timerDelegate?.keepStartButtonDisable(disable: false)
            timerDelegate?.keepStartButtonHidden(hide: false)
            eventDelegate.redCard(bool: false)
            eventDelegate.yellowCall(bool: false)
        } else {
        eventDelegate.halfTime(bool: false)
        timerDelegate?.keepStartButtonDisable(disable: true)
        timerDelegate?.keepStartButtonHidden(hide: true)
        eventDelegate.redCard(bool: false)
        eventDelegate.yellowCall(bool: false)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let eventToSet = events[indexPath.row]
        cell.textLabel?.text = "\(eventToSet.team) - Player: \(eventToSet.playerNum)"
        cell.backgroundColor = eventToSet.color
        cell.detailTextLabel?.text = eventToSet.timeStamp
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
