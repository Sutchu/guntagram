//
//  UserDataSource.swift
//  guntagram
//
//  Created by Ali Sutcu on 24.12.2021.
//

import Foundation
import Firebase
import UIKit

class UserRegisterManager {
    
    private let db = Firestore.firestore()
    var delegate: UserRegisterManagerProtocol?
    
    func createNewUser(email: String, userName: String, password: String)  {
        checkUsernameUniqueness(userName: userName) { returnVal in
            if returnVal {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                if let error = error {
                                    print(error)
                                    self.delegate?.registerFailed(error: error)
                                } else {
                                    self.createUserInDatabase(userName: userName)
                                }
                            }
            } else {
                self.delegate?.registerFailed(error: UserError.userNameNotUnique)
            }
        }
    }
    
    func createUserInDatabase(userName: String) {
        if let user = Auth.auth().currentUser, let usermail = user.email {
            let userReference = db.collection("users").document(user.uid)
            userReference.setData([
                "email": usermail,
                "posts": [],
                "user_name": userName
            ]) { (error) in
                if let error = error {
                    print(error)
                    self.delegate?.registerFailed(error: error)
                } else {
                    FireStoreConstants.shared.userReference = userReference
                    self.delegate?.userIsRegistered()
                }
            }
        }
    }
    
    func checkUsernameUniqueness(userName: String, completion: @escaping (_ returnVal: Bool) -> Void){
        let userCollection = db.collection("users")
        let query = userCollection.whereField("user_name", isEqualTo: userName)
        var returnVal: Bool = false
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                self.delegate?.registerFailed(error: err)
            } else {
                if querySnapshot?.documents.count == 0 {
                    returnVal = true
                }
            }
            completion(returnVal)
        }
    }
    
}
