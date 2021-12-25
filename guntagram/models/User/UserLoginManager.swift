//
//  UserLoginManager.swift
//  guntagram
//
//  Created by Ali Sutcu on 25.12.2021.
//

import Foundation
import Firebase
import UIKit

class UserLoginManager {

    private let db = Firestore.firestore()
    var delegate: UserLoginManagerProtocol?
    
    func logInUser(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let e = error {
                self?.delegate?.loginFailed(error: e)
            } else {
                self?.delegate?.userLoggedIn()
            }
          // ...
        }
    }
}
