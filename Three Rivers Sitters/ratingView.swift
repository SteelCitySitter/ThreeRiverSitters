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
    var babySitterID: String? = " "
    var fNme : String? = " "
    var lNme : String? = " "
    var totalRating : String? = " "

      var ref: FIRDatabaseReference! = nil

    override func viewDidLoad() {
        
        
        print("ratingView->ID \(self.babySitterID!)")
        ratingStars.careGiverIDRatingScreen = self.babySitterID
     self.ref =  FIRDatabase.database().reference(fromURL: "https://three-rivers-sitters.firebaseio.com/")
        
        self.ref.child("caregivers").child(self.babySitterID!).observeSingleEvent(of: .value, with: {snapshot in
            
            let profile = snapshot.value as? NSDictionary
            let name = profile?["firstName"] as? String
            self.firstNameBabysitter.text = name
            let lastN = profile?["lastName"] as? String
            self.lastNameBabysitter.text = lastN
            
        })

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)}

    @IBAction func submitButtonAction(_ sender: Any) {
        
        self.ref.child("booking-schema").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                
                for child in result {
                    let userKey = child.key
                    
                    if(userKey == self.babySitterID){
                        
                        self.ref.child("booking-schema").child(userKey).child("comment").setValue(self.commentTextField.text)
                    }
                }
            }
        })
        
        let alert = UIAlertController(title: "Thank you", message: "Click OK to continue", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "unwindBefore", sender: self)
        
    }

 }
