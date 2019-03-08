//
//  EventHalfTimeView.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/5/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class EventsView: UIView {
    lazy var eventsTableView: UITableView = {
       var tableView = UITableView()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        eventsTableView.register(EventsTableViewCell.self, forCellReuseIdentifier: "HalfTimeEventCell")
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    func setupTableView() {
        addSubview(eventsTableView)
        eventsTableView.translatesAutoresizingMaskIntoConstraints = false
        eventsTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        eventsTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        eventsTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        eventsTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
