//
//  ratingView.swift
//  Three-River-Sitters
//
//  Created by Vikesh Inbasekharan on 11/15/16.
//  Copyright © 2016 MSE. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ratingView : UIViewController{

    @IBOutlet weak var ratingStars: ServiceRatingControl!
    @IBOutlet weak var firstNameBabysitter: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var lastNameBabysitter: UILabel!
    var babySitterIDFromPayment: String? = " "
    var timeStampFromPayment: String? = " "
    var fNme : String? = " "
    var lNme : String? = " "
    var totalRating : String? = " "
    var currentUser: User!

    var ref: FIRDatabaseReference! = nil

    override func viewDidLoad() {
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.currentUser = User(authData: user)
        }
        
        ratingStars.careGiverIDRatingScreen = self.babySitterIDFromPayment
        ratingStars.timeStampFromRatingScreen = self.timeStampFromPayment
        
     self.ref =  FIRDatabase.database().reference(fromURL: "https://three-rivers-sitters.firebaseio.com/")
        print("Babysitter in ratingview---->\(self.babySitterIDFromPayment)")
        self.ref.child("caregivers").child(self.babySitterIDFromPayment!).observeSingleEvent(of: .value, with: {snapshot in
            
            let profile = snapshot.value as? NSDictionary
            let name = profile?["firstName"] as? String
            self.firstNameBabysitter.text = name
            let lastN = profile?["lastName"] as? String
            self.lastNameBabysitter.text = lastN
            
        })

    }//viewDidLoad
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)}

    @IBAction func submitButtonAction(_ sender: Any) {
        //---> booking write
        
        // ----> booking history
        
        self.ref.child("booking-history").child(self.babySitterIDFromPayment!).child(self.timeStampFromPayment!).updateChildValues(["comment": commentTextField.text!])
        
        self.ref.child("caregivers").child(self.babySitterIDFromPayment!).updateChildValues(["serviceStatus":"inactive"])
        
        self.ref.child("families").child(self.currentUser.uid).updateChildValues(["bookingStatus":"NoRequest"])
        
        self.ref.child("booking-schema").child(self.babySitterIDFromPayment!).child(self.timeStampFromPayment!).setValue(nil)
    
        let alert = UIAlertController(title: "Thank you", message: "Click OK to continue", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "unwindBefore", sender: self)
        
    }

 }
