//
//  HomeTextField.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 10/19/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class HomeTextField: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = UIColor(red:1, green:1, blue:1, alpha:1.0).cgColor
        self.layer.borderWidth = 1
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 7)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
