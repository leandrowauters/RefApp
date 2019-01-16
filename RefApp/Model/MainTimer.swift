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
    static var time = 0.0
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
    
    func restartTimer(){
        timer.suspend()
        state = .restated
//        MainTimer.time = -1
        //        self.timer.eventHandler = {
        //            self.action()
        //            MainTimer.time += 1
        //        }
        //        self.timer.resume()
    }
    static func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    static func timeStringWithMilSec(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let milliseconds = Int(((time.truncatingRemainder(dividingBy: 1)) * 1000) / 10)
        return String(format: "%02i:%02i:%02i:%0.2i", hours, minutes, seconds, milliseconds)
    }
}

protocol TimerDelegate: class {
    func turnOnTimer(turnOn: Bool)
    func keepStartButtonHidden(hide: Bool)
    func keepStartButtonDisable(disable: Bool)
    func addTapAfterSub(add: Bool)
}
