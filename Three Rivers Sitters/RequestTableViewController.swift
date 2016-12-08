//
//  RequestTableViewController.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 12/5/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class RequestTableViewController: UITableViewController {

var ref: FIRDatabaseReference!
var currentUser: User!

var requestingFamilies: [String] = []
var requestingFamilyIDs: [String] = []

override func viewDidLoad() {
    
    super.viewDidLoad()
    //let rootRef = FIRDatabase.database().reference()
    
    FIRAuth.auth()!.addStateDidChangeListener { auth, user in
        guard let user = user else { return }
        self.currentUser = User(authData: user)
        
        let requestsRef = FIRDatabase.database().reference(withPath: "pending-requests").child(self.currentUser.uid)
        
        requestsRef.observe(.childAdded, with: { snap in
            
            guard let requestingFamilyID = snap.key as? String else {
                return
            }
            
            guard let requestingFamilyName = snap.value as? String else {
                return
            }
            
            self.requestingFamilyIDs.append(requestingFamilyID)
            self.requestingFamilies.append(requestingFamilyName)
            
            let row = self.requestingFamilyIDs.count - 1
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .top)
            
        })
        
        requestsRef.observe(.childRemoved, with: { snap in
            guard let requestingFamilyName = snap.value as? String else { return }
            
            for (index, name) in self.requestingFamilies.enumerated() {
                if name == requestingFamilyName {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.requestingFamilies.remove(at: index)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        })

    }
    
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //print(onlineBabysitters.count)
    return requestingFamilies.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
    
    let storage = FIRStorage.storage().reference(forURL: "gs://three-rivers-sitters.appspot.com")
    
    //let imageFile = "babysitters/" + onlineBabysitterIDs[indexPath.row] + ".png"
    
    //let imageRef = storage.child(imageFile)
    
    //cell.profileImage.sd_setImage(with: imageRef)
    
    cell.profileImage.image = #imageLiteral(resourceName: "iwzNJLiuCVhHUBKJFAA0Uw9p08Y2")
    cell.profileName.text = requestingFamilies[indexPath.row]
    cell.profileDistance.text = "\((Double(indexPath.row) + 1.0) * 0.38) miles"
    return cell
}

// MARK: Actions

@IBAction func signoutButtonPressed(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)

}
    
@IBAction func unwindToRequestTableView(segue: UIStoryboardSegue) {
        
    }
    
/*
 override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
 
 
 //performSegue(withIdentifier:"babysitterDetail", sender: self)
 }
 */
override func prepare(for segue: UIStoryboardSegue, sender: Any?)
{
    let backItem = UIBarButtonItem()
    backItem.title = "back"
    
    backItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState.normal)
    navigationItem.backBarButtonItem = backItem
    
    
    let index = tableView.indexPathForSelectedRow?.row
    
    if segue.identifier == "requestDetail"
    {
        if let destinationVC = segue.destination as? RequestDetailViewController
        {
            destinationVC.familyName = requestingFamilies[index!]
            destinationVC.familyID = requestingFamilyIDs[index!]
        }
    }
}

}
