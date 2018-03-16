//
//  TimerViewController.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/13/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

import UIKit
import UICircularProgressRing
import UserNotifications

class TimerViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var focusTimer: UICircularProgressRingView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    //Variables and constants
    var timeInSeconds = 20
    var timer = Timer()
    var isTimerRunning = false
    
    
    //ViewDidLoad and viewWillDisapear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSoundsToArray()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeActivityController), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openactivity), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        focusTimer.ringStyle = .ontop
        focusTimer.outerCapStyle = .round
        
        pauseButton.isHidden = true
        stopButton.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    //Functions
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        if timeInSeconds < 1 {
            timer.invalidate()
            
        } else {
            timeInSeconds -= 1
            timerLabel.text = timeString(time: TimeInterval(timeInSeconds))
        }
    }
    
    //Functions that calculate the time between when the app has been closed and opened again
    //Does not work yet!!!
    @objc func closeActivityController()  {
        
    }

    @objc func openactivity(timeAppClosed: Double)  {
        
    }

    
    
    
    //IBActions
    @IBAction func startTimer(_ sender: Any) {
        
        //Ask the user permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
            
            //Show notification when time is over
            let notification = UNMutableNotificationContent()
            notification.title = "Time's up!"
            notification.subtitle = "You completed focus round 1! Take a short break of about 5 minutes."
            notification.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
            //Request the notification
            let request = UNNotificationRequest(identifier: "Alert sent that time is up!", content: notification, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            if didAllow {
                print("succes")
            } else {
                print("error")
            }
            
        }
        
        //Hide the start button and unhide the pause button
        startButton.isHidden = true
        pauseButton.isHidden = false
        stopButton.isHidden = false
        
        if isTimerRunning == false {
            runTimer()
        }
        
        focusTimer.setProgress(value: 100, animationDuration: 20.0) {
            print("Time's up!")
            
        }
        
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
    }
    
}
