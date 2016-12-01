//
//  User.swift
//  Three Rivers Sitters
//
//  Created by Shrinath on 11/18/16.
//  Copyright © 2016 Three Rivers Sitters. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
