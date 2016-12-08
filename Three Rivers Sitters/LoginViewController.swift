//
//  LoginViewController.swift
//  ThreeRiversSitters
//
//  Created by Shrinath on 10/16/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging
import FirebaseCore
import FirebaseStorage
import FirebaseStorageUI
import SDWebImage
import UserNotifications

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailField: LoginTextField!
    
    @IBOutlet weak var passwordField: LoginTextField!
    
    @IBAction func didTapSignIn(_ sender: UIButton) {
        
        guard let email = emailField.text, let password = passwordField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                let failureAlert = UIAlertController(title: "Login failure", message: "Either you're not a registered user or your username/password is invalid", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                failureAlert.addAction(okAction)
                self.present(failureAlert, animated: true, completion: nil)
                return
            }
                
            else {
                
                var category : String = ""
                var status : String = ""
                var userCategory : String = ""
                
                var ref: FIRDatabaseReference!
                var userRef: FIRDatabaseReference!
                
                ref = FIRDatabase.database().reference()
                userRef = FIRDatabase.database().reference()
                
                let userID = (FIRAuth.auth()?.currentUser?.uid)!
                
                ref.child("category-list").observeSingleEvent(of: .value, with: {(snap) in
                    
                    let vals = snap.value as? NSDictionary
                    
                    userCategory = vals?[userID] as! String
                    
                    if(userCategory == "caregiver") {
                        
                      userRef.child("caregivers").child(userID).observe(.value, with: {(snapshot) in
                            
                            let values = snapshot.value as? NSDictionary
                            
                            category = values?["category"] as! String
                            
                            status = values?["status"] as! String
                            
                            if(status=="pending") {
                                let midAlert = UIAlertController(title: "Pending approval", message: "Your sign up is pending administrator approval", preferredStyle: UIAlertControllerStyle.alert)
                                let midAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                    print("OK")
                                }
                                midAlert.addAction(midAction)
                                self.present(midAlert, animated: true, completion: nil)
                            }
                                
                            else if status == "approved" {
                                print("This is the success branch for babysitter - \(userID)")
                                let successAlert = UIAlertController(title: "Login success!", message: "Your login is successful", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                    print("OK")
                                }
                                successAlert.addAction(okAction)
                                //self.present(successAlert, animated: true, completion: nil)
                                self.performSegue(withIdentifier: "babysitterHome", sender: sender)
                            }
                            
                        })
                    }
                    
                    else if(userCategory == "family") {
                        
                        userRef.child("families").child(userID).observe(.value, with: {(snapshot) in
                            
                            let values = snapshot.value as? NSDictionary
                            
                            //category = values?["category"] as! String
                            
                            status = values?["status"] as! String
                            
                            if(status=="pending") {
                                let midAlert = UIAlertController(title: "Pending approval", message: "Your sign up is pending administrator approval", preferredStyle: UIAlertControllerStyle.alert)
                                let midAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                    print("OK")
                                }
                                midAlert.addAction(midAction)
                                self.present(midAlert, animated: true, completion: nil)
                            }
                                
                            else if status == "approved" {
                                
                                let successAlert = UIAlertController(title: "Login success!", message: "Your login is successful", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                    print("OK")
                                }
                                successAlert.addAction(okAction)
                                //self.present(successAlert, animated: true, completion: nil)
                                self.performSegue(withIdentifier: "loginToList", sender: sender)
                            }
                            
                        })
                        
                    }
                    
                }) //ref cat-list
                
                
                        
                
           }//outer else
            
        }//FIRAuth
        
    }//didTapSignIn
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "back"
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "Hoefler Text", size: 20)!]
        
        backItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState.normal)
        
        navigationItem.backBarButtonItem = backItem
        
        self.performSegue(withIdentifier: "signUp", sender: sender)
    }
    
    @IBAction func didRequestPasswordReset(_ sender: AnyObject) {
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        self.present(prompt, animated: true, completion: nil);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
        
    }
    
    /*
    func signedIn(_ user: FIRUser?) {
            
            MeasurementHelper.sendLoginEvent()
            AppState.sharedInstance.displayName = user?.displayName ?? user?.email
            AppState.sharedInstance.photoURL = user?.photoURL
            AppState.sharedInstance.signedIn = true
            let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
            performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        //FIRApp.configure()
        /*
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        */
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}

}
