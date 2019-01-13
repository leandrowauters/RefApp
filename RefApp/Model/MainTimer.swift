//
//  Timer.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/2/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
class MainTimer {
    
    let timeInterval: TimeInterval
    static var time = 0
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    var eventHandler: (() -> Void)?
    
    enum State {
        case suspended
        case resumed
        case restated
    }
    
    var state: State = .suspended
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }

}

protocol TimerDelegate: class {
    func turnOnTimer(turnOn: Bool)
    func keepStartButtonHidden(hide: Bool)
    func keepStartButtonDisable(disable: Bool)
}
