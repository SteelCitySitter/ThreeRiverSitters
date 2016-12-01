//
//  BabysitterDetailViewController.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 11/17/16.
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

class BabysitterDetailViewController: UIViewController {
    
    
    @IBOutlet weak var babysitterProfileImage: UIImageView!
    
    @IBOutlet weak var babysitterNameLabel: UILabel!
    
    @IBOutlet weak var address1Label: UILabel!

    @IBOutlet weak var address2Label: UILabel!
    
    var currentUser: User!
    var babysitterName: String!
    var babysitterID: String!
    var addressLine1: String!
    var addressLine2: String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.currentUser = User(authData: user)
            //print("Current user is: \(self.currentUser.uid)")
        }
        
        ref.child("caregivers").child(babysitterID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let values = snapshot.value as? NSDictionary
            self.addressLine1 = values?["addressLine1"] as? String ?? ""
            self.addressLine2 = values?["addressLine2"] as? String ?? ""
            print("The address is \(self.addressLine1)")
            
            let storage = FIRStorage.storage().reference(forURL: "gs://three-rivers-sitters.appspot.com")
            
            let imageFile = "babysitters/" + self.babysitterID + ".png"
            
            let imageRef = storage.child(imageFile)
            
            self.babysitterProfileImage.sd_setImage(with: imageRef)
            
            self.babysitterProfileImage.layer.cornerRadius =
                self.babysitterProfileImage.frame.size.width / 3;
            
            self.babysitterProfileImage.layer.borderWidth = 2.0;
            self.babysitterProfileImage.layer.borderColor = UIColor.green.cgColor
            
            self.babysitterNameLabel.text = self.babysitterName
            
            self.address1Label.text = self.addressLine1
            self.address2Label.text = self.addressLine2
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
      // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func bookNowTapped(_ sender: Any) {
        
        var bookingInfo = [String: Double]()
        
        print("Current user is: \(self.babysitterID)")
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        bookingInfo = [currentUser.uid: NSDate().timeIntervalSince1970]
        
        ref.child("pending-requests").child((self.babysitterID)!).setValue(bookingInfo)
        
        let successAlert = UIAlertController(title: "Booking Info", message: "Booking request sent to babysitter. You should receive a confirmation if the babysitter accepts.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
            }
        
        successAlert.addAction(okAction)
        self.present(successAlert, animated: true, completion: nil)
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

}
