//
//  RatingControl.swift
//
//  Created by Vikesh Inbasekahran on 10/26/16.
//
//

import UIKit
import Firebase
class ServiceRatingControl: UIView {
    // MARK: Properties
    var careGiverIDRatingScreen: String!
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    var ref: FIRDatabaseReference! = nil
        var ratingButtons = [UIButton]()
    var spacing = 5
    var stars = 5
    var rting: String!
    // MARK: Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        
        for _ in 0..<5 {
            let button = UIButton()
            
            button.setImage(emptyStarImage, for: UIControlState())
            button.setImage(filledStarImage, for: .selected)
            button.setImage(filledStarImage, for: [.highlighted, .selected])
            
            button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), for: .touchDown)
            ratingButtons += [button]
            addSubview(button)
        }
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
    
    //Rating--> capturing the stars, calculating the rating and writing to database
  //  print("fromRatingViewID:\(careGiverIDRatingScreen)")
        self.ref =  FIRDatabase.database().reference(fromURL: "https://three-rivers-sitters.firebaseio.com/")
        self.ref.child("Booking-Schema").observeSingleEvent(of: .value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for child in result {
                    let userKey = child.key
                    if(userKey == "iwEEREHBop98Tghe234"){
                        self.ref.child("Booking-Schema").child(userKey).child("Rating").setValue(self.rting)
                    }
                }
            }
        })
    
       // Fetching the current rating from the babysitter schema to calculate the final rating
        self.ref.child("caregivers").child(self.careGiverIDRatingScreen).observeSingleEvent(of: .value, with: {snapshot in
            
            let profile1 = snapshot.value as? NSDictionary
            let totalRating = profile1?["totalRating"] as? Int
            let totalRaters = profile1?["totalRaters"] as? Int
            let tRating: Int = Int(totalRating!) + Int(self.rting)!
            let fRating: Int = tRating / (totalRaters! + 1)
            
            self.ref.child("caregivers").observeSingleEvent(of: .value, with: { (snapshot) in
                if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for child in result {
                        let userKey = child.key
                        if(userKey == self.careGiverIDRatingScreen){
                            self.ref.child("caregivers").child(userKey).child("totalRating").setValue(tRating)
                        }
                    }
                    for child in result {
                        let userKey = child.key
                        if(userKey == self.careGiverIDRatingScreen){
                            self.ref.child("caregivers").child(userKey).child("totalRaters").setValue(totalRaters! + 1)
                        }
                    }
                }
            })
            
       // Wrinting the final rating - > DB under caregiver schema
            
            self.ref.child("caregivers").observeSingleEvent(of: .value, with: { (snapshot) in
                if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for child in result {
                        let userKey = child.key
                        if(userKey == self.careGiverIDRatingScreen){
                            self.ref.child("caregivers").child(userKey).child("rating").setValue(fRating)
                        }
                    }
                }
            })
            
        })
        

        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
    
    
}
