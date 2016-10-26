//
//  LoginTextField.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 10/1/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = UIColor(red:0.45, green:0.89, blue:0.56, alpha:1.0).cgColor
        self.layer.borderWidth = 1
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 7)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
