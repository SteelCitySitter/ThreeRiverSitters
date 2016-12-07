//
//  RatingControl.swift
//
//  Created by Vikesh Inbasekharan on 10/26/16.
//

import UIKit
import Firebase
import FirebaseAuth

class RatingControl: UIView {
    // MARK: Properties
    
    var currentUser: User!
    //var careGiverIDRatingScreen: String =
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var ratingButtons = [UIButton]()
    var spacing = 5
    var stars = 5
    var rting: String!
    // MARK: Initialization

        required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
            
            FIRAuth.auth()!.addStateDidChangeListener { auth, user in
                guard let user = user else { return }
                self.currentUser = User(authData: user)
                
                var ref: FIRDatabaseReference! = nil
                ref =  FIRDatabase.database().reference(fromURL: "https://three-rivers-sitters.firebaseio.com/")
                // Fetching the current rating from the babysitter schema to calculate the final rating
                ref.child("caregivers").child(self.currentUser.uid).observe(.value, with: {snapshot in
                    
                    let profile1 = snapshot.value as? NSDictionary

                    
                    print(profile1?["rating"] as Any!)
                    //let totalRating = CInt(profile1?["rating"] as Any)
                    
                    let bnd: Int = Int(profile1?["rating"] as Any! as! String)!
                    
                    for _ in 0..<bnd {
                        let button = UIButton()
                        button.isUserInteractionEnabled = false
                        button.setImage(filledStarImage, for: UIControlState())
                        button.setImage(filledStarImage, for: .selected)
                        button.adjustsImageWhenHighlighted = false
                        
                        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), for: .touchDown)
                        self.ratingButtons += [button]
                        self.addSubview(button)
                    }
                    
                    for _ in bnd+1..<6 {
                        let button = UIButton()
                        button.isUserInteractionEnabled = false
                        button.setImage(emptyStarImage, for: UIControlState())
                        button.setImage(filledStarImage, for: .selected)
                        button.setImage(filledStarImage, for: [.highlighted, .selected])
                        
                        // button.setImage(filledStarImage, for: UIControlState())
                        //  button.setImage(filledStarImage, for: .selected)
                        //  button.adjustsImageWhenHighlighted = false
                        
                        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), for: .touchDown)
                        self.ratingButtons += [button]
                        self.addSubview(button)
                    }
                    
                })
                
            }
            
            //print("User --> \(currentUser.uid)")
            
            //Rating--> capturing the stars
            
    }
    
    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus spacing.
        for (index, button) in ratingButtons.enumerated() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        updateButtonSelectionStates()
    }
    
    override var intrinsicContentSize : CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * stars
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    
    func ratingButtonTapped(_ button: UIButton) {
        rating = ratingButtons.index(of: button)! + 1
        rting = String(rating)
    
      //Rating--> capturing the stars
 
    
     
            
      // Wrinting the final rating - > DB under caregiver schema

        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
    
    
}
