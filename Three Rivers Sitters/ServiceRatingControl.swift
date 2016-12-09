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
    var timeStampFromRatingScreen: String!
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
        
        ref = FIRDatabase.database().reference()
    
    //Rating--> capturing the stars, calculating the rating and writing to database
        
   // print("from Service rating controller-->>:\(careGiverIDRatingScreen!)")
  //      print("timestamp-->:\(timeStampFromRatingScreen!)")
        
   //     print(rting)
        self.ref.child("booking-schema").child(careGiverIDRatingScreen!).child(timeStampFromRatingScreen!).updateChildValues(["rating":rting])
        
        self.ref.child("booking-history").child(careGiverIDRatingScreen!).child(timeStampFromRatingScreen!).updateChildValues(["rating":rting])
        
   //     print("caregiverid-->:\(self.careGiverIDRatingScreen)")
   //     print("timestamp-->:\(self.timeStampFromRatingScreen)")
       
        self.ref.child("caregivers").child(self.careGiverIDRatingScreen!).observeSingleEvent(of: .value, with: {snapshot in
            
            let profile1 = snapshot.value as? NSDictionary
            let totalRating = profile1?["totalRating"] as? Int
   //         print("Total Rating-->\(totalRating!)")
            
            let totalRaters = profile1?["totalRaters"] as? Int
   //         print("Total Raters-->\(totalRaters)")
     //       let tRating: Int = Int(totalRating!) + Int(self.rting)!
    //        let fRating: Int = tRating / (totalRaters! + 1)
            
            
      //  self.ref.child("caregivers").child(self.careGiverIDRatingScreen!).updateChildValues(["totalRating":totalRating as? String])
            
      //      self.ref.child("caregivers").child(self.careGiverIDRatingScreen!).updateChildValues(["totalRaters":totalRaters as? String])
            
         //   let finalRating = String(fRating)
       // Writing the final rating - > DB under caregiver schema
            
            self.ref.child("caregivers").child(self.careGiverIDRatingScreen!).updateChildValues(["rating":"4"])
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
