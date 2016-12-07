//
//  RequestDetailViewController.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 12/6/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseStorageUI
import SDWebImage
import FirebaseMessaging

class RequestDetailViewController: UIViewController {

    @IBOutlet weak var requestorProfileImage: UIImageView!
    
    @IBOutlet weak var requestorNameLabel: UILabel!
    
    @IBOutlet weak var address1Label: UILabel!
    
    @IBOutlet weak var address2Label: UILabel!
    
    var currentUser: User!
    var fullName: String!
    
    var familyName: String!
    var familyID: String!
    
    var addressLine1: String!
    var addressLine2: String!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.currentUser = User(authData: user)
            //print("Current user is: \(self.currentUser.uid)")
        }
        
       ref.child("families").child(familyID).observeSingleEvent(of: .value, with: {(snap) in
            
            let vals = snap.value as? NSDictionary
            
            self.addressLine1 = vals?["addressLine1"] as? String ?? ""
            self.addressLine2 = vals?["addressLine2"] as? String ?? ""
            
            self.fullName = vals?["firstName"] as? String ?? ""
            self.fullName = self.fullName + " "
            self.fullName = self.fullName + (vals?["lastName"] as? String ?? "")
            
            self.requestorNameLabel.text = self.familyName
            
            self.address1Label.text = self.addressLine1
            self.address2Label.text = self.addressLine2
        
        
            self.requestorProfileImage.image = #imageLiteral(resourceName: "iwzNJLiuCVhHUBKJFAA0Uw9p08Y2")
        
            self.requestorProfileImage.layer.cornerRadius =
            self.requestorProfileImage.frame.size.width / 3;
        
            self.requestorProfileImage.layer.borderWidth = 2.0;
    })
        
       { (error) in
        print(error.localizedDescription)
       }
        
        /*
        ref.child("caregivers").child(babysitterID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let values = snapshot.value as? NSDictionary
                        print("The address is \(self.addressLine1)")
            
            let storage = FIRStorage.storage().reference(forURL: "gs://three-rivers-sitters.appspot.com")
            
            let imageFile = "babysitters/" + self.babysitterID + ".png"
            
            let imageRef = storage.child(imageFile)
            
            self.babysitterProfileImage.sd_setImage(with: imageRef)
            
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        */
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func acceptRequest(_ sender: Any) {
        
        var bookingInfo = [String: String]()
            
            bookingInfo = ["caregiver":currentUser.uid,
                        "comment":"",
                        "family":familyID,
                        "payment-status":"pending",
                        "rating":"0",
                        "service-duration":"1",
                        "total":"15"
                        ]
        
        self.ref.child("booking-schema").childByAutoId().updateChildValues(bookingInfo)
        
        self.ref.child("pending-requests").child(currentUser.uid).setValue(nil)
        
        self.ref.child("online-caregivers").child(currentUser.uid).setValue(nil)
        
        /*
        var bookingInfo = [String: String]()
        
        print("Current user is: \(self.babysitterID)")
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        bookingInfo = [currentUser.uid: self.fullName]
        
        let newRef = ref.child("pending-requests")
        newRef.updateChildValues([self.babysitterID: bookingInfo])
        
        //ref.child("pending-requests").child((self.babysitterID)!).setValue(bookingInfo)
        
        let successAlert = UIAlertController(title: "Booking Info", message: "Booking request sent to babysitter. You should receive a confirmation if the babysitter accepts.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        successAlert.addAction(okAction)
        self.present(successAlert, animated: true, completion: nil)
    */
   }
 
    
}
