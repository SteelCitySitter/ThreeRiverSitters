//
//  SignUpViewController.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 9/25/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
import Firebase
import FirebaseAuth
import FirebaseDatabase

var pickGender = ["male", "female"]
var pickCategory = ["parent", "care provider"]
let genderPicker = UIPickerView()
let categoryPicker = UIPickerView()



class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: FIRDatabaseReference!

    @IBOutlet weak var firstNameField: LoginTextField!

    @IBOutlet weak var lastNameField: LoginTextField!
    
    @IBOutlet weak var emailField: LoginTextField!
    
    @IBOutlet weak var passwordField: LoginTextField!
    
    @IBOutlet weak var confirmPassField: LoginTextField!
    
    @IBOutlet weak var genderField: LoginTextField!
    
    @IBOutlet weak var phoneField: LoginTextField!
    
    @IBOutlet weak var birthdayField: LoginTextField!
    
    @IBOutlet weak var address1Field: LoginTextField!
    
    @IBOutlet weak var address2Field: LoginTextField!
    
    @IBOutlet weak var cityField: LoginTextField!
    
    @IBOutlet weak var stateField: LoginTextField!
    
    @IBOutlet weak var zipcodeField: LoginTextField!
    
    @IBOutlet weak var categoryField: LoginTextField!
    
    @IBOutlet weak var infoField: LoginTextField!
    

    @IBAction func signUpTapped(_ sender: UIButton) {
        
        //validator.validate(self)
        
        guard let email = emailField.text, let password = passwordField.text else {return}

        let firstName = firstNameField.text
        let lastName = lastNameField.text
        let sex = genderField.text
        let phone = phoneField.text
        let birthday = birthdayField.text
        let address1 = address1Field.text
        let address2 = address2Field.text
        let city = cityField.text
        let state = stateField.text
        let zipcode = zipcodeField.text
        let category = categoryField.text
        let info = infoField.text
        
        var userInfo = [String: String]()
        
        if category == "care provider" {
        
            userInfo = ["firstName":firstName!,
                        "lastName":lastName!,
                        "addressLine1":address1!,
                        "addressLine2":address2!,
                        "city":city!,
                        "state":state!,
                        "zipcode":zipcode!,
                        "email":email,
                        "birthday":birthday!,
                        "gender":sex!,
                        "phone":phone!,
                        "category":info!,
                        "status":"pending",
                        "availability": "no"]
        }
        
        else if category == "parent" {
            
            userInfo = ["firstName":firstName!,
                            "lastName":lastName!,
                            "addressLine1":address1!,
                            "addressLine2":address2!,
                            "city":city!,
                            "state":state!,
                            "zipcode":zipcode!,
                            "email":email,
                            "birthday":birthday!,
                            "gender":sex!,
                            "phone":phone!,
                            "children":info!,
                            "status":"pending"]
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) {(user, error) in
            if let error = error {
                let failureAlert = UIAlertController(title: "Sign Up Failure", message: "Looks like you're already a user!", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                failureAlert.addAction(okAction)
                self.present(failureAlert, animated: true, completion: nil)
               return
            }
            
            else {
                let successAlert = UIAlertController(title: "Signed Up!", message: "You've successfully signed up! You should receive a verification email soon.", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("OK")
                
                    if (category == "care provider") {
                        self.ref.child("caregivers").child((user?.uid)!).setValue(userInfo)
                    }
                    
                    else if category == "parent" {
                        self.ref.child("families").child((user?.uid)!).setValue(userInfo)
                    }
            }
                
                successAlert.addAction(okAction)
                self.present(successAlert, animated: true, completion: nil)
                let user = FIRAuth.auth()?.currentUser
                
                user?.sendEmailVerification() { error in
                    if let error = error {
                        // An error happened.
                    } else {
                        // Email sent.
                    }
                }
                
            }
        
       }
        
    }
    
    @IBAction func dateFieldEdited(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(SignUpViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        /*
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.locale = Locale(identifier: "en_US")
      dateFormatter.setLocalizedDateFormatFromTemplate("dd-MMM-yyyy")
        */
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "dd-MMM-yyyy"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        birthdayField.text = RFC3339DateFormatter.string(from: sender.date)
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 5
    }
    
    
   /* override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    } */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        genderField.resignFirstResponder()
        phoneField.resignFirstResponder()
        birthdayField.resignFirstResponder()
        address1Field.resignFirstResponder()
        address2Field.resignFirstResponder()
        cityField.resignFirstResponder()
        stateField.resignFirstResponder()
        zipcodeField.resignFirstResponder()
        categoryField.resignFirstResponder()
        infoField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryField.resignFirstResponder()
        
        //FIRApp.configure()
        
        ref = FIRDatabase.database().reference()
        
        genderPicker.delegate = self
        categoryPicker.delegate = self
        
        genderPicker.dataSource = self
        categoryPicker.dataSource = self
        
        categoryField.inputView = categoryPicker
        genderField.inputView = genderPicker
        
        genderPicker.tag = 1
        categoryPicker.tag = 2
        
        emailField.delegate = self
        phoneField.delegate = self
        zipcodeField.delegate = self
        
        //validator.registerField(emailField, rules: EmailRule)
        //validator.registerField(phoneField, rules: PhoneNumberRule)
        
    }
    /*
    func validationSuccessful() {
        let alertController = UIAlertController(title: "Input validation", message: "Invalid input fields", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    
    }
    */
        
    //Data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
        
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickGender.count
    }
    
             
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == genderPicker.tag {
            return pickGender[row]
        }
        
        if pickerView.tag == categoryPicker.tag {
            return pickCategory[row]
        }
        
        return ""
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == genderPicker.tag {
            genderField.text = pickGender[row]
        }
        
        if pickerView.tag == categoryPicker.tag {
            categoryField.text = pickCategory[row]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}//class
