//
//  OYCountDownManager.swift
//  OYCountDown
//
//  Created by Gold on 2016/10/27.
//  Copyright © 2016年 Gold. All rights reserved.
//

import UIKit

let OYCountDownManagerNotification: Notification.Name = Notification.Name("OYCountDownManagerNotification")

class OYCountDownManager: NSObject {
    var timeInterval: Int = 0
    private var timer: Timer?
    
    static let sharedManager :OYCountDownManager = {
        let instance = OYCountDownManager()
        return instance
    }()
    
    func start() ->Void {
        weak var weakSelf = self
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timers) in
            weakSelf?.timerAction()
        })
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    func timerAction() -> Void {
        self.timeInterval = self.timeInterval + 1
        let noti: Notification = Notification(name: OYCountDownManagerNotification, object: nil, userInfo: nil)
        NotificationCenter.default.post(noti)
    }
    
    func reload() -> Void {
        self.timeInterval = 0
    }
}
