//
//  TimerViewController.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/13/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox

class TimerViewController: UIViewController {
    
    //IBOutlets
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
    var focusRounds = 1
    var isProgressRingAnimating = false
    
    //Circular progressring constants and variables
    let shapeLayer = CAShapeLayer()
    let yellowColor = UIColor(red:1.00, green:0.92, blue:0.23, alpha:1.0)
    let indiGoColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
    
    
    //ViewDidLoad and viewWillDisapear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Function that adds all the ambientSound classes to the array
        addSoundsToArray()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeActivityController), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openactivity), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        
        //Hiding buttons that are not supposed to be accesible
        pauseButton.isHidden = true
        stopButton.isHidden = true
        resumeButton.isHidden = true
        
        //MARK: All the code for the animated progress ring
        // let's start by drawing a circle somehow
        let center = view.center
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 150, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = yellowColor.cgColor
        trackLayer.lineWidth = 12
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapButt
        view.layer.addSublayer(trackLayer)
        
        //let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = indiGoColor.cgColor
        shapeLayer.lineWidth = 12
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapButt
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    //ViewWillDisappear function
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    //MARK: Functions
    
    func startAnimatedProgressRing() {
        if isProgressRingAnimating == true {
            print("Ring already animating")
        } else {
            print("Attempting to animate stroke")
            
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.speed = 0.8
            basicAnimation.toValue = 1
            
            basicAnimation.duration = Double(timeInSeconds)
            
            basicAnimation.fillMode = kCAFillModeForwards
            basicAnimation.isRemovedOnCompletion = false
            
            shapeLayer.add(basicAnimation, forKey: "urSoBasic")
            isProgressRingAnimating = true
        }
        
    }

    func stopAnimatingProgressRing() {
        shapeLayer.speed = 0.0
        isProgressRingAnimating = false
    }
    
    func resumeAnimatingProgressRing() {
        shapeLayer.speed = 0.8
        isProgressRingAnimating = true
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    //Function that starts the timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    //Function which updates the timer
    @objc func updateTimer() {
        if timeInSeconds < 1 {
            timer.invalidate()
            startButton.isHidden = false
            pauseButton.isHidden = true
            stopButton.isHidden = true
            isTimerRunning = false
            
            //setting the label to 00 : 00 : 00 in case the app was closed when the timer reached 0
            timerLabel.text = timeString(time: TimeInterval(0))
            
            roundNumber += 1
            
            if roundNumber % 2 == 0 && roundNumber < 4 {
                timeInSeconds = 300
            } else if roundNumber % 4 == 0 {
                timeInSeconds = 1800
            } else {
                timeInSeconds = 1500
                focusRounds += 1
            }
            
        } else {
            timeInSeconds -= 1
            timerLabel.text = timeString(time: TimeInterval(timeInSeconds))
        }
    }
    
    //Functions that calculate the time between when the app has been closed and opened again
    
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
    
    //Function which determines what happens when the app is closed (ie homescreen/task manager)
    @objc func closeActivityController()  {
        print("Closed application")
        
        if isTimerRunning == false {
            print("Time was not running")
        } else {
            var startDate = Date()
            print(startDate)
            UserDefaults.standard.set(startDate, forKey: "startDate")
        }
        
    }
    
    //What happens when the app is opened again
    @objc func openactivity()  {
        print("Opened application")
        
        //Reseting the app badge count back to 0 when the app is opened
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if isTimerRunning == false {
            print("Timer was not running time not updated")
        } else {
            var dateAppClosed = UserDefaults.standard.object(forKey: "startDate") as? Date?
            getTimeDifference(startDate: dateAppClosed as! Date)
        }
        
    }
    
    //Updating the timer UI to show the correct time
    func updateTimerSinceAppClosed(secondsPassed: Int) {
        timeInSeconds = (timeInSeconds - secondsPassed) + 1
        print(secondsPassed)
        updateTimer()

    }
    
    
    //IBActions
    @IBAction func startTimer(_ sender: Any) {
        
        startAnimatedProgressRing()
        
        //Ask the user permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
            
            //Show notification when time is over
            let notification = UNMutableNotificationContent()
            notification.badge = 1
            
            //Creating different notifications for different types of rounds
            
            if self.roundNumber % 2 == 0 && self.roundNumber < 4 {
                notification.title = "5 minute break over!"
                notification.body = "The short 5 minute break is over. You should focus and get back to work! This was round number \(self.roundNumber)."
            } else if self.roundNumber == 4 {
                notification.title = "30 minute break over!"
                notification.body = "The long pause round is over, you should focus and get back to work! This was round number \(self.roundNumber)."
            } else {
                notification.title = "25 minutes focus is over!"
                notification.body = "The focus round is over, you may now have a short break. This was focus round \(self.focusRounds)."
            }
            
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
        
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        timer.invalidate()
        resumeButton.isHidden = false
        isTimerRunning = false
        
        if isProgressRingAnimating == true {
            stopAnimatingProgressRing()
            isProgressRingAnimating = false
        } else {
            print("ring was already paused")
        }
        
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        timer.invalidate()
        
        if isProgressRingAnimating == true {
            stopAnimatingProgressRing()
            isProgressRingAnimating = false
        } else {
            print("ring was already paused")
        }
    }
    
    @IBAction func resumeButtonPressed(_ sender: Any) {
        runTimer()
        isTimerRunning = true
        resumeButton.isHidden = true
        pauseButton.isHidden = false
        
        if isProgressRingAnimating == true {
            print("Sorry ring was already animating")
        } else {
            resumeAnimatingProgressRing()
            isProgressRingAnimating = true
        }
        
    }
    
    
}
