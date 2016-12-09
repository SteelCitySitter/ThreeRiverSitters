//
//  ViewController.swift
//  secondTRS
//
//  Created by Vikesh Inbasekharan on 11/25/16.
//  Copyright © 2016 MSE. All rights reserved.
//

import UIKit
import Firebase

class TimerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var babySitterIDFromBookScreen : String!
    var timeStampFromBookScreen : String!
    
    @IBOutlet weak var fName: UILabel!
    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var cLable: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    var cID: String!
    var serviceHours: UInt8!
    let transition = circularTransition()
    
    var ref: FIRDatabaseReference! = nil
    
    var startTime = TimeInterval()
    var timer:Timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref =  FIRDatabase.database().reference(fromURL: "https://three-rivers-sitters.firebaseio.com/")
        
        startButton.layer.cornerRadius = startButton.frame.size.width / 2
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.white.cgColor
        stopButton.layer.cornerRadius = stopButton.frame.size.width / 2
        stopButton.layer.borderWidth = 2
        stopButton.layer.borderColor = UIColor.white.cgColor
        
        // Do any additional setup after loading the view, typically from a nib.
        
        ref.child("caregivers").child(babySitterIDFromBookScreen).observe(.value, with: { snap in
            
            let profile = snap.value as? NSDictionary
            let firstName = profile?["firstName"] as? String
            let lastName = profile?["lastName"] as? String
            
            self.fName.text = firstName
            self.lName.text = lastName
        })
    
    }//viewDidLoad
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let payVC = segue.destination as! paymentViewController
        payVC.transitioningDelegate = self
        payVC.modalPresentationStyle = .custom
        payVC.servHrs = self.serviceHours
        payVC.timeStampFromTimerScreen = self.timeStampFromBookScreen
        payVC.babySitterIDFromTimerScrn = self.babySitterIDFromBookScreen
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = stopButton.center
        transition.circleColor = UIColor.white
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = stopButton.center
        transition.circleColor = UIColor.green
        return transition
        
    }
    
    

    @IBAction func Start(_ sender: Any) {
        if (!timer.isValid) {
            let aSelector : Selector = #selector(TimerViewController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
        
    }
    
    @IBAction func Stop(_ sender: Any) {
        timer.invalidate()
    //   self.ref.child("Booking-Schema").child("iwEEREHBop98Tghe234").setValue(["servicedHrs": chours])
        
        self.ref.child("booking-schema").child(babySitterIDFromBookScreen).observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    let userKey = child.key 
                    if(userKey == self.timeStampFromBookScreen){
                        self.ref.child("booking-schema").child(self.babySitterIDFromBookScreen).child(userKey).child("service-duration").setValue(self.serviceHours)
                    }
                }
            }
        })
        // ----> booking history
        self.ref.child("booking-history").child(babySitterIDFromBookScreen).observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    let userKey = child.key
                    if(userKey == self.timeStampFromBookScreen){
                        self.ref.child("booking-history").child(self.babySitterIDFromBookScreen).child(userKey).child("service-duration").setValue(self.serviceHours)
                    }
                }
            }
        })
        
        
    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        print(currentTime)
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the hours in elapsed time.
        let hours = UInt8(elapsedTime / 3600.0)
        elapsedTime -= (TimeInterval(hours) * 3600)
       self.serviceHours = hours
        
        if(self.serviceHours < 1)
        {self.serviceHours = 1
        }else{
            self.serviceHours = hours
        }
        
        //calculate the minutes in elapsed time.
        let minutes = (UInt8(elapsedTime / 60.0)) % 60
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
    //    self.serviceHours = seconds
        //find out the fraction of milliseconds to be displayed.
        // let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        //let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        cLable.text = "\(strHours):\(strMinutes):\(strSeconds)"//:\(strFraction)"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

