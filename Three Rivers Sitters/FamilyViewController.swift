//
//  FamilyViewController.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 12/4/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FamilyViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //@IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var status: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    let ImagePicker = UIImagePickerController()
    
    
    var ref: FIRDatabaseReference!
    var currentUser: User!
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.currentUser = User(authData: user)
            
            self.ImagePicker.delegate = self
            self.ref =  FIRDatabase.database().reference()
            
            self.ref.child("families").child(self.currentUser.uid).observeSingleEvent(of: .value, with: {snapshot in
                
                let profile1 = snapshot.value as? NSDictionary
                let name = profile1?["firstName"] as? String
                self.firstName.text = name
                
                let lname = profile1?["lastName"] as? String
                self.lastName.text = lname
                let email = profile1?["email"] as? String
                self.email.text = email
                let add = profile1?["addressLine1"] as? String
                self.addressField.text = add
                let phone = profile1?["phone"] as? String
                self.phone.text = phone
                let zip = profile1?["zipcode"] as? String
                self.zipCode.text = zip
                //let state = profile1?["state"] as? String
                //self.state.text = state
                let status = profile1?["status"] as? String
                self.status.text = status
                //let city = profile1?["city"] as? String
                //self.city.text = city
            })
            
            self.saveButton.layer.cornerRadius = self.saveButton.frame.size.width / 2
            self.saveButton.isHidden = true
            self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
            self.profilePicture.layer.borderWidth = 2
            self.profilePicture.layer.borderColor = UIColor.white.cgColor
            self.profilePicture.clipsToBounds = true
            
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://three-rivers-sitters.appspot.com")
            let imagesRef = storageRef.child("babysitters")
            let fName: String = "\(self.currentUser.uid).jpg"
            let fileName = fName
            
            let spaceRef = imagesRef.child(fileName)
            spaceRef.data(withMaxSize: 1 * 1080 * 1080) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    let alert = UIAlertController(title: "Set your image", message: "Touch the placeholder image to set your profile image", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                    
                else {
                    // Data for "images/island.jpg" is returned
                    // ... let islandImage: UIImage! = UIImage(data: data!)
                    self.profilePicture.image = UIImage(data: data!)
                }
            }
            
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Edit profile", message: "Touch each text field to edit it", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.firstName.isUserInteractionEnabled = true
        self.lastName.isUserInteractionEnabled = true
        self.addressField.isUserInteractionEnabled = true
        self.email.isUserInteractionEnabled = true
        self.phone.isUserInteractionEnabled = true
        //self.city.isUserInteractionEnabled = true
        //self.state.isUserInteractionEnabled = true
        self.zipCode.isUserInteractionEnabled = true
        saveButton.isHidden = false
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let storage = FIRStorage.storage()
        
        let storageRef = storage.reference(forURL: "gs://three-rivers-sitters.appspot.com")
        
        //  var imageData = UIImagePNGRepresentation(profilePicture.image!)
        
        let imageData = UIImageJPEGRepresentation(profilePicture.image!, 0.9)
        
        let uploadPath: String = "families/\(currentUser.uid).jpg"
        
        if (imageData != nil) {
            
            let postPicReference = storageRef.child(uploadPath)
            
            postPicReference.put(imageData!, metadata: nil, completion: nil)
            
        }

        
        self.ref.child("families").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    let userKey = child.key
                    if(userKey == self.currentUser.uid){
                        self.ref.child("families").child(userKey).child("firstName").setValue(self.firstName.text!)
                        self.ref.child("families").child(userKey).child("lastName").setValue(self.lastName.text!)
                        self.ref.child("families").child(userKey).child("email").setValue(self.email.text!)
                        self.ref.child("families").child(userKey).child("phone").setValue(self.phone.text!)
                        self.ref.child("families").child(userKey).child("address").setValue(self.addressField.text!)
                        self.ref.child("families").child(userKey).child("zipcode").setValue(self.zipCode.text!)
                        
                    }
                }
            }
        })
        
        let alert = UIAlertController(title: "Your information is now updated!", message: "Click OK to continue", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        saveButton.isHidden = true
        self.firstName.isUserInteractionEnabled = false
        self.lastName.isUserInteractionEnabled = false
        self.addressField.isUserInteractionEnabled = false
        self.email.isUserInteractionEnabled = false
        self.phone.isUserInteractionEnabled = false
        //self.city.isUserInteractionEnabled = false
        //self.state.isUserInteractionEnabled = false
        self.zipCode.isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func profileSelect(_ sender: UIButton) {
        //  let ImagePicker = UIImagePickerController()
        
        //    ImagePicker.delegate = self
        ImagePicker.allowsEditing = false
        ImagePicker.sourceType = .photoLibrary
        
        self.present(ImagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("picking image")
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePicture.contentMode = .scaleAspectFit
            self.profilePicture.image = pickedImage
            print("Image:\(pickedImage)")
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    @nonobjc func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject])
    {
        //  let profileView = info[UIImagePickerControllerOriginalImage] as! UIImage
        
    }
 
    
    @nonobjc func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

