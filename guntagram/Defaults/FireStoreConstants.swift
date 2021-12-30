//
//  FireStoreDefaults.swift
//  guntagram
//
//  Created by Ali Sutcu on 25.12.2021.
//

import Foundation
import Firebase

struct FireStoreConstants {
    
    static var shared = FireStoreConstants()
    var currentUser: User?
    private init() {}
    
}
