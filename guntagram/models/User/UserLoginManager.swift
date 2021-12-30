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
                
                if let authResult = authResult {
                    self?.db.collection("users").document(authResult.user.uid).getDocument() { querySnapshot, err in
                        if let querySnapshot = querySnapshot {
                            let userName = querySnapshot.get("user_name") as! String
                            FireStoreConstants.shared.currentUser = User(userName: userName, userReference: querySnapshot.reference)
                            self?.delegate?.userLoggedIn()
                        }
                    }
                }
            }
        }
    }
}
