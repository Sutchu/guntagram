//
//  UserManager.swift
//  guntagram
//
//  Created by Ali Sutcu on 25.12.2021.
//

import Foundation
import Firebase
import UIKit

class UserManager {
    
    var delegate: UserManagerProtocol?
    private let firebaseAuth = Auth.auth()
    
    func logoutUser() {
        do {
            try firebaseAuth.signOut()
                self.delegate?.userDidLogout()
        } catch let signOutError as NSError {
            self.delegate?.errorOccured(error: signOutError)
        }
    }
    
}
