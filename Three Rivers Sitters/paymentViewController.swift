//
//  paymentViewController.swift
//  secondTRS
//
//  Created by Vikesh Inbasekahran  on 11/25/16.
//  Copyright © 2016 MSE. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import Alamofire
import Firebase

class paymentViewController: UIViewController, STPPaymentCardTextFieldDelegate , UITextFieldDelegate {

    @IBOutlet weak var totalChargeAmt: UILabel!
    @IBOutlet weak var serverHours: UILabel!
    var totalChargeAm: UInt8 = 0
    var babySitterIDFromTimerScrn: String = " "
    @IBOutlet weak var payButton: UIButton!
    
    var servHrs: UInt8!
    var timeStampFromTimerScreen: String = " "
    let paymentTextField = STPPaymentCardTextField()
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var ref: FIRDatabaseReference! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref =  FIRDatabase.database().reference(fromURL: "https://three-rivers-sitters.firebaseio.com/")
        
        payButton.layer.cornerRadius = payButton.frame.size.width / 2
        
        let rect = CGRect(x: 10, y: 399,width: self.view.frame.width-30, height: 40)
        paymentTextField.frame=rect
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        self.payButton.isHidden=true
        
        
        // Charge Calculation -> @ $15 an hour
        // Serverd hours come through as parameter from timer screen
        
        let hourlyCharge: UInt8 = 15
       
        let totalCharge = self.servHrs * hourlyCharge
        self.totalChargeAm = totalCharge
        
        self.totalChargeAmt.text = String(totalCharge)
        self.serverHours.text = String(servHrs)
        
        self.ref.child("booking-schema").child(babySitterIDFromTimerScrn).observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    let userKey = child.key
                    if(userKey == self.timeStampFromTimerScreen){
                        self.ref.child("booking-schema").child(self.babySitterIDFromTimerScrn).child(userKey).child("total").setValue(totalCharge)
                    }
                }
            }
        })
        // ----> booking history
        self.ref.child("booking-history").child(babySitterIDFromTimerScrn).observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    let userKey = child.key
                    if(userKey == self.timeStampFromTimerScreen){
                        self.ref.child("booking-history").child(self.babySitterIDFromTimerScrn).child(userKey).child("total").setValue(totalCharge)
                    }
                }
            }
        })
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        if textField.valid{
            self.payButton.isHidden=false
        }
        
    }

    @IBAction func paymentAction(_ sender: Any) {
        
        let card = paymentTextField.cardParams
        print(card)
        
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        STPAPIClient.shared().createToken(withCard: card, completion: {(token,error)-> Void in
            if let error  = error{
                print(error)
                let alert = UIAlertController(title: "Payment Failed  check the card details again", message: "click OK to continue", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if let token = token{
                print(token)
                self.chargeUsingToken(token: token)
            }
        })
 
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func chargeUsingToken(token:STPToken){
        
        
        let params=["stripeToken": token.tokenId,"amount": self.totalChargeAm,"currency": "usd","description": "testing"] as [String : Any]

        Alamofire.request("https://limitless-journey-86165.herokuapp.com/charge.php", method: .post, parameters: params).responseJSON { (response) in
            self.activityIndicator.stopAnimating()
            print(response.request as Any)
            print(response.response as Any)
            print(response.data as Any)
            print(response.result)

            if let JSON = response.result.value{print("JSON: \(JSON)") }
          
            // calling rating screen here --->
            
            self.ref.child("booking-schema").child(self.babySitterIDFromTimerScrn).observeSingleEvent(of: .value, with: { (snapshot) in
                if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for child in result {
                        let userKey = child.key
                        if(userKey == self.timeStampFromTimerScreen){
                            self.ref.child("booking-schema").child(self.babySitterIDFromTimerScrn).child(userKey).child("payment-status").setValue("Paid")
                        }
                    }
                }
            })
            // ----> booking history
            self.ref.child("booking-history").child(self.babySitterIDFromTimerScrn).observeSingleEvent(of: .value, with: { (snapshot) in
                if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for child in result {
                        let userKey = child.key
                        if(userKey == self.timeStampFromTimerScreen){
                            self.ref.child("booking-history").child(self.babySitterIDFromTimerScrn).child(userKey).child("payment-status").setValue("Paid")
                        }
                    }
                }
            })
            
            
            let vc : ratingView = self.storyboard!.instantiateViewController(withIdentifier: "ratingView") as! ratingView
            vc.babySitterIDFromPayment = self.babySitterIDFromTimerScrn
            vc.timeStampFromPayment = self.timeStampFromTimerScreen
            self.present(vc, animated: true, completion: nil)
        
            
            
        }
  }

}

