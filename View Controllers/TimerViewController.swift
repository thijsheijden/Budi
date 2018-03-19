//
//  TimerViewController.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/13/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

//MARK: Importing all the frameworks and pods
import UIKit
import UserNotifications
import AudioToolbox

class TimerViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    //MARK: Variables and constants
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
    
    //MARK: ViewDidLoad and ViewWillDisapear
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding all the daily progresses to the dailyProgressArray
        addDailyProgressToArray()
        
        //Function that adds all the ambientSound classes to the array
        addSoundsToArray()
        
        //Functions that check wether the app has gone into the background
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeActivityController), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openactivity), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        
        //Hiding buttons that are not supposed to be accesible
        hideButtonsWhenNotAccesible()
        
        //All the code for the animated progress ring
        //Drawing a circle
        let center = view.center
        
        //Create my track layer
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
    
    //MARK: All the Functions
    
    //Function to hide the buttons which are not supposed to be visible when the app opens
    func hideButtonsWhenNotAccesible() {
        stopButton.isHidden = true
        pauseButton.isHidden = true
        resumeButton.isHidden = true
    }
    
    //Function to show the pause and stop button
    func showButtonsWhenAccesible() {
        stopButton.isHidden = false
        pauseButton.isHidden = false
    }
    
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

    //Stop the ring from animating when for instance pause or stop is pressed
    func stopAnimatingProgressRing() {
        shapeLayer.speed = 0.0
        isProgressRingAnimating = false
    }
    
    //Resume the ring animation when for instance resume has been pressed
    func resumeAnimatingProgressRing() {
        shapeLayer.speed = 0.8
        isProgressRingAnimating = true
    }
    
    //Convert the time in seconds to hours, minutes and seconds and display this in the correct format
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    //Function that starts the timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    //Function that checks the round number and sets the timeInSeconds accordingly for the next round
    func setNextRoundTimeInSeconds(roundNumber: Int) {
        if roundNumber % 2 == 0 && roundNumber < 4 {
            timeInSeconds = 300
        } else if roundNumber % 4 == 0 {
            timeInSeconds = 1800
        } else {
            timeInSeconds = 1500
            focusRounds += 1
        }
    }
    
    //Function that sets
    
    //Function which updates the timer
    @objc func updateTimer() {
        if timeInSeconds < 1 {
            timer.invalidate()
            
            //Display the start button again
            startButton.isHidden = false
            
            //Hiding all the other buttons
            hideButtonsWhenNotAccesible()
            
            //Timer is not running anymore so set that variable to false
            isTimerRunning = false
            
            //setting the label to 00 : 00 : 00 in case the app was closed when the timer reached 0
            timerLabel.text = timeString(time: TimeInterval(0))
            
            //Add one to the roundnumber so that the correct notification is displayed next round
            roundNumber += 1
            
            //Pass the roundnumber to the function which sets the timeInSeconds correctly
            setNextRoundTimeInSeconds(roundNumber: roundNumber)
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
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
    
    //Function that is called with the quick action from the homescreen
    func quickActionFocusTimer() {
        startTimerFunction()
        isTimerRunning = true
    }
    
    //Function that creates notifications according to the roundnumber
    func createNotificationAccordingToRoundNumber(roundNumber: Int, timeInSeconds: Int) {

        //MARK: All code having to do with notifications
        //Ask the user permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
            
            //Show notification when time is over
            let notification = UNMutableNotificationContent()
            notification.badge = 1
            notification.sound = UNNotificationSound.default()
            
            //Adding actions to the notifications (start next round)
            let startNextRound = UNNotificationAction(identifier: "startNextRound", title: "Start the next round", options: .foreground)
            let notificationCategory = UNNotificationCategory(identifier: "category", actions: [startNextRound], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([notificationCategory])
            notification.categoryIdentifier = "category"
            
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
        
    }
    
    //This function gets called when the start button is pressed
    func startTimerFunction() {

        //Call the notification Function
        createNotificationAccordingToRoundNumber(roundNumber: roundNumber, timeInSeconds: timeInSeconds)
    
        if isTimerRunning == false {
            runTimer()
        } else {
            print("Timer was already running")
        }
        
    }
    
    //MARK: All the Button IBACTIONS
    @IBAction func startTimer(_ sender: Any) {
        
        startAnimatedProgressRing()
        
        startTimerFunction()
        
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
