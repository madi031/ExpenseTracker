//
//  TimerApplication.swift
//  Expense Tracker
//
//  Created by madi on 3/28/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    public static let TimeOutUserInteraction: NSNotification.Name = NSNotification.Name(rawValue: "TimeOutUserInteraction")
}

class TimerApplication: UIApplication {
    static let appDidTimeout = "App Timeout"
    
    // Timeout - 2 min
    let timeoutInSeconds: TimeInterval = 2 * 60
    
    var idleTimer: Timer?
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        if idleTimer != nil {
            self.resetIdleTimer()
        }
        
        if let touches = event.allTouches {
            for touch in touches {
                if touch.phase == UITouch.Phase.began {
                    self.resetIdleTimer()
                }
            }
        }
    }
    
    func resetIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds, target: self, selector: #selector(self.idleTimeExceeded), userInfo: nil, repeats: false)
    }
    
    @objc
    func idleTimeExceeded() {
        NotificationCenter.default.post(name:Notification.Name(rawValue: TimerApplication.appDidTimeout), object: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "BiometricViewController") as! BiometricViewController
        appDelegate.window?.rootViewController = loginVC
        appDelegate.window?.makeKeyAndVisible()
    }
}
