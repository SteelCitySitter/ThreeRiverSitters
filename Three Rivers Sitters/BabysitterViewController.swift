//
//  BabysitterViewController.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 11/13/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class BabysitterViewController: UITableViewController {
    
    var ref: FIRDatabaseReference!
    var currentUser: User!
    
    var onlineBabysitters: [String] = []
    var onlineBabysitterIDs: [String] = []
    var onlineBabysitterName: String = ""
    var onlineBabysitterID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let rootRef = FIRDatabase.database().reference()
        
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.currentUser = User(authData: user)
        }
        
        
        let caregiversRef = FIRDatabase.database().reference(withPath: "online-caregivers")
        
        caregiversRef.observe(.childAdded, with: { snap in
            // 2
            guard let babysitterName = snap.value as? String else { return }
            
            guard let babysitterID = snap.key as? String else { return }
            
            self.onlineBabysitters.append(babysitterName)
            self.onlineBabysitterIDs.append(babysitterID)
            //3
            let row = self.onlineBabysitters.count - 1
            //4
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .top)
        })
        
        caregiversRef.observe(.childRemoved, with: { snap in
            guard let babysitterName = snap.value as? String else { return }
            for (index, name) in self.onlineBabysitters.enumerated() {
                if name == babysitterName {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.onlineBabysitters.remove(at: index)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        })
        
        /*
        ref.observe(.value, with: {snapshot in
            print(snapshot.value!)
            
            var newItems : [String] = []
            
            for item in snapshot.children {
                let babysitter =
            }
            
        })
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(onlineBabysitters.count)
        return onlineBabysitters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        let storage = FIRStorage.storage().reference(forURL: "gs://three-rivers-sitters.appspot.com")
        
        let imageFile = "babysitters/" + onlineBabysitterIDs[indexPath.row] + ".jpg"
        
        let imageRef = storage.child(imageFile)
        
        cell.profileImage.sd_setImage(with: imageRef)
        
        //cell.profileImage.image = #imageLiteral(resourceName: "iwzNJLiuCVhHUBKJFAA0Uw9p08Y2")
        cell.profileName.text = onlineBabysitters[indexPath.row]
        cell.profileDistance.text = "\((Double(indexPath.row) + 1.0) * 0.38) miles"
        return cell
    }
    
    // MARK: Actions
    
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        
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
        
        if segue.identifier == "babysitterDetail"
        {
            if let destinationVC = segue.destination as? BabysitterDetailViewController
            {
                destinationVC.babysitterName = onlineBabysitters[index!]
                destinationVC.babysitterID = onlineBabysitterIDs[index!]
            }
        }
    }
    
    @IBAction func unwindToBabysitterView(segue: UIStoryboardSegue) {
        
    }
    
    
    /*
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        if(indexPath.row == 1) {
        cell.profileImage.image = #imageLiteral(resourceName: "uzU48XY3feTXoULAy5RXzxJQJhn1")
        cell.profileName.text = "Sadie Jones"
        cell.profileDistance.text = "0.89 mi"
        cell.availableLabel.text = "2.30 pm"
        return cell
        }
        
        else if(indexPath.row == 2) {
            cell.profileImage.image = #imageLiteral(resourceName: "iwzNJLiuCVhHUBKJFAA0Uw9p08Y2")
            cell.profileName.text = "Kate Upton"
            cell.profileDistance.text = "1.20 mi"
            cell.availableLabel.text = "4.00 pm"
            return cell
        }
        
        else if(indexPath.row == 3) {
            cell.profileImage.image = #imageLiteral(resourceName: "kfS3K38eulQJKr0NQpUizRjOMOF3")
            cell.profileName.text = "Irina Shayk"
            cell.profileDistance.text = "2.00 mi"
            cell.availableLabel.text = "6.30 pm"
            return cell
        }
        
        else {
            cell.profileImage.image = #imageLiteral(resourceName: "CLDZvRocUbcXrGcbZFmQXtMh6I62")
            cell.profileName.text = "Karlie Kloss"
            cell.profileDistance.text = "2.57 mi"
            cell.availableLabel.text = "1.00 pm"
            return cell
        }
        
    }
    */
    
    
 
    /*
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
    */
}
