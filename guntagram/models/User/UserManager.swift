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
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var delegate: UserManagerProtocol?
    private let firebaseAuth = Auth.auth()
    
    func logoutUser() {
        do {
            try firebaseAuth.signOut()
            FireStoreConstants.shared.currentUser = nil
            self.delegate?.userDidLogout()
        } catch let signOutError as NSError {
            self.delegate?.errorOccured(error: signOutError)
        }
    }
    
    func changeProfilePhoto(imageData: Data) {
        
        if let userId = Auth.auth().currentUser?.uid {
            let imagePath = "profile-images/\(userId)-profile.png"
            let userReference = db.collection("users").document(userId)
            var error: Error?
            let group = DispatchGroup()
            group.enter()
            self.sendProfilePhotoToStorage(imageData: imageData, imagePath: imagePath) {err in
                if let err = err {
                    error = err
                }
                group.leave()
            }
            group.enter()
            self.addProfilePhotoPathToFireBase(imagePath: imagePath, userReference: userReference) {err in
                if let err = err {
                    error = err
                }
                group.leave()
            }
            group.notify(queue: .main) {
                if let error = error {
                    self.delegate?.errorOccured(error: error)
                } else {
                    //self.delegate?.postUploaded()
                }
            }
        }
    }
    
    func addProfilePhotoPathToFireBase(imagePath: String, userReference: DocumentReference, completion: @escaping (_ error: Error?) -> Void) {
        var returnVal: Error?
        
        userReference.updateData([
            "profile-photo": imagePath
        ]) { err in
            if let err = err {
                returnVal = err
            }
            completion(returnVal)
        }
    }
    
    func sendProfilePhotoToStorage(imageData: Data, imagePath: String, completion: @escaping (_ error: Error?) -> Void) {
        var returnVal: Error?
        storage.child(imagePath).putData(imageData, metadata: nil) {_, err in
            if let err = err {
                //self.delegate?.uploadFailed(error: err)
                returnVal = err
            }
            completion(returnVal)
        }
    }
    
}
