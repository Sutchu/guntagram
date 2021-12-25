//
//  PostUploadManager.swift
//  guntagram
//
//  Created by Ali Sutcu on 25.12.2021.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class PostUploadManager {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var delegate: PostUploadManagerProtocol?
    
    func uploadPost(imageData: Data) {
        
        if let userId = Auth.auth().currentUser?.uid {
            let timestamp = NSDate().timeIntervalSince1970
            let imagePath = "images/\(userId)-\(timestamp).png"
            let userReference = db.collection("users").document(userId)
            var error: Error?
            let group = DispatchGroup()
            group.enter()
            let postReference = self.createPostInDatabase(userReference: userReference, imagePath: imagePath, timeStamp: timestamp)
            self.sendImageToStorage(imageData: imageData, imagePath: imagePath, timeStamp: timestamp) {err in
                if let err = err {
                    error = err
                }
                group.leave()
            }
            group.enter()
            self.addPostReferenceToUserInDatabase(postReference: postReference, userReference: userReference) {err in
                if let err = err {
                    error = err
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                if let error = error {
                    self.delegate?.uploadFailed(error: error)
                } else {
                    self.delegate?.postUploaded()
                }
            }
        } else {
            self.delegate?.uploadFailed(error: UserError.unexpected)
        }
    }
    
    func sendImageToStorage(imageData: Data, imagePath: String, timeStamp: TimeInterval, completion: @escaping (_ error: Error?) -> Void) {
        var returnVal: Error?
        storage.child(imagePath).putData(imageData, metadata: nil) {_, err in
            if let err = err {
                //self.delegate?.uploadFailed(error: err)
                returnVal = err
            }
            completion(returnVal)
        }
    }
    
    func createPostInDatabase(userReference: DocumentReference, imagePath: String, timeStamp: TimeInterval) -> DocumentReference {
        
        return db.collection("posts").addDocument(data: [
            "like_count": 0,
            "upload_time": timeStamp,
            "owner": userReference,
            "image_path": imagePath,
            "liking_users": [],
            "owner_username": FireStoreConstants.shared.userName
        ]) { (error) in
            if let e = error {
                print(e)
            } else {
                print("user created suksesful")
            }
        }
    }
    
    func addPostReferenceToUserInDatabase(postReference: DocumentReference, userReference: DocumentReference, completion: @escaping (_ error: Error?) -> Void) {
        var returnVal: Error?
        
        userReference.updateData([
            "posts": FieldValue.arrayUnion([postReference])
        ]) { err in
            if let err = err {
                returnVal = err
            }
            completion(returnVal)
        }
    }
}
