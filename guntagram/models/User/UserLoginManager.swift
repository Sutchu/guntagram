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
                    let userReference = self?.db.collection("users").document(authResult.user.uid)
                    FireStoreConstants.shared.userReference = userReference
                    userReference!.getDocument(completion: { querySnapshot,_ in
                        FireStoreConstants.shared.userName = querySnapshot!.get("user_name") as? String
                    })
                    self?.delegate?.userLoggedIn()
                }
            }
        }
    }
}
