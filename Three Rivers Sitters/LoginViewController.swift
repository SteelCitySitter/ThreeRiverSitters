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

class LoginViewController: UIViewController {
    
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
                let successAlert = UIAlertController(title: "Login success!", message: "Your login is successful", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                successAlert.addAction(okAction)
                self.present(successAlert, animated: true, completion: nil)
            }
            //self.signedIn(user!)
        }
        
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
        FIRApp.configure()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
