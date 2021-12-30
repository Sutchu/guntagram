//
//  User.swift
//  guntagram
//
//  Created by Ali Sutcu on 24.12.2021.
//

import Foundation
import Firebase
import FirebaseFirestore

struct User: Equatable {
    
    let userName: String
    let userReference: DocumentReference
    
}
