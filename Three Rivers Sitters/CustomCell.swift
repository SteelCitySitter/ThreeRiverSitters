//
//  CustomCell.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 11/15/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileDistance: UILabel!
    
    @IBOutlet weak var availableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 3;
        
        self.profileImage.layer.borderWidth = 2.0;
        self.profileImage.layer.borderColor = UIColor.green.cgColor
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
