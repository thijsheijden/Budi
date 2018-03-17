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
import AudioToolbox

class TimerViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var focusTimer: UICircularProgressRingView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    //Variables and constants
    var timeInSeconds = 1500
    var timer = Timer()
    var isTimerRunning = false
    var roundNumber = 1
    
    
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
        resumeButton.isHidden = true
        
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
            startButton.isHidden = false
            pauseButton.isHidden = true
            stopButton.isHidden = true
            isTimerRunning = false
            
            roundNumber += 1
            
            if roundNumber % 2 == 0 {
                timeInSeconds = 300
            } else if roundNumber % 4 == 0 {
                timeInSeconds = 1800
            } else {
                timeInSeconds = 1500
            }
            
        } else {
            timeInSeconds -= 1
            timerLabel.text = timeString(time: TimeInterval(timeInSeconds))
        }
    }
    
    //Functions that calculate the time between when the app has been closed and opened again
    //Does not work yet!!!
    
    //Function to get time difference
    func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        print(components)
        var minutesPassedInSeconds = components.minute! * 60
        var timeInSecondsSinceAppClosed = minutesPassedInSeconds + components.second!
        print(timeInSecondsSinceAppClosed)
        UserDefaults.standard.set(timeInSecondsSinceAppClosed, forKey: "secondsPassedSinceAppClosed")
        updateTimerSinceAppClosed(secondsPassed: UserDefaults.standard.integer(forKey: "secondsPassedSinceAppClosed"))
        return(components.hour!, components.minute!, components.second!)
    }
    
    @objc func closeActivityController()  {
        print("Closed application")
        var startDate = Date()
        print(startDate)
        UserDefaults.standard.set(startDate, forKey: "startDate")
    }
    
    @objc func openactivity()  {
        print("Opened application")
        var dateAppClosed = UserDefaults.standard.object(forKey: "startDate") as? Date?
        
        getTimeDifference(startDate: dateAppClosed as! Date)
        
    }

    func updateTimerSinceAppClosed(secondsPassed: Int) {
        timeInSeconds = (timeInSeconds - secondsPassed) + 1
        print(secondsPassed)
        updateTimer()
    }
    
    
    //IBActions
    @IBAction func startTimer(_ sender: Any) {
        
        //Ask the user permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (didAllow, error) in
            
            //Show notification when time is over
            let notification = UNMutableNotificationContent()
            notification.title = "Time's up!"
            notification.subtitle = "You completed focus round 1! Take a short break of about 5 minutes."
            notification.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(self.timeInSeconds), repeats: false)
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
        
        focusTimer.setProgress(value: 100, animationDuration: 1500.0) {
            
        }
        
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        timer.invalidate()
        resumeButton.isHidden = false
        isTimerRunning = false
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        timer.invalidate()
        isTimerRunning = false
    }
    
    @IBAction func resumeButtonPressed(_ sender: Any) {
        runTimer()
        isTimerRunning = true
        resumeButton.isHidden = true
        pauseButton.isHidden = false
    }
    
    
}
