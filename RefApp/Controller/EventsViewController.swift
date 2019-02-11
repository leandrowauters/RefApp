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
    lazy var customSegmentedBar: UISegmentedControl = {
        var segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Home", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Away", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = #colorLiteral(red: 0.2567201853, green: 0.4751234055, blue: 0.4362891316, alpha: 1)
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
    lazy var animatedView: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var animatedViewRail: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2567201853, green: 0.4751234055, blue: 0.4362891316, alpha: 1)
        return view
    }()
    @IBOutlet weak var eventTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimatedViewRail()
        setupCustomSegmentedBar()
        setupAnimatedView()
        
        
        
        eventTableView.dataSource = self
        eventTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    func setupCustomSegmentedBar() {
        view.addSubview(customSegmentedBar)
        customSegmentedBar.translatesAutoresizingMaskIntoConstraints = false
        customSegmentedBar.centerXAnchor.constraint(equalTo: eventTableView.centerXAnchor).isActive = true
        
        customSegmentedBar.bottomAnchor.constraint(equalTo: animatedViewRail.topAnchor).isActive = true
        customSegmentedBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        customSegmentedBar.widthAnchor.constraint(equalTo: eventTableView.widthAnchor).isActive = true

        customSegmentedBar.addTarget(self, action: #selector(customSegmentedBarPressed(sender:)), for: UIControl.Event.valueChanged)
    }
    func setupAnimatedView(){
        view.addSubview(animatedView)
        animatedView.centerXAnchor.constraint(equalTo: eventTableView.centerXAnchor).isActive = true
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        animatedView.topAnchor.constraint(equalTo: customSegmentedBar.bottomAnchor).isActive = true
        animatedView.leadingAnchor.constraint(equalTo: animatedViewRail.leadingAnchor).isActive = true
        animatedView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedView.widthAnchor.constraint(equalTo: animatedViewRail.widthAnchor, multiplier: 0.5).isActive = true
        
        
    }
    func setupAnimatedViewRail(){
        view.addSubview(animatedViewRail)
        animatedViewRail.translatesAutoresizingMaskIntoConstraints = false
        animatedViewRail.centerXAnchor.constraint(equalTo: eventTableView.centerXAnchor).isActive = true
        animatedViewRail.bottomAnchor.constraint(equalTo: eventTableView.topAnchor).isActive = true
        animatedViewRail.heightAnchor.constraint(equalToConstant: 5).isActive = true
        animatedViewRail.widthAnchor.constraint(equalTo: eventTableView.widthAnchor).isActive = true
    }
    @IBAction func dismiss(_ sender: UIButton) {
       
        eventDelegate.halfTime(bool: false)
        timerDelegate?.keepStartButtonDisable(disable: true)
        timerDelegate?.keepStartButtonHidden(hide: true)
            eventDelegate.redCard(bool: false, home: nil)
            eventDelegate.yellowCall(bool: false, home: nil)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func customSegmentedBarPressed(sender: UISegmentedControl){
        let selectorStartPosition = self.eventTableView.frame.width / CGFloat(2) * CGFloat(sender.selectedSegmentIndex)
        UIView.animate(withDuration: 0.3) {
            self.animatedView.frame.origin.x = selectorStartPosition + (self.view.frame.width - self.eventTableView.frame.width) / 2
        }
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
