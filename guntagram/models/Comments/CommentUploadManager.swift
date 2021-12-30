//
//  CommentUploadManager.swift
//  guntagram
//
//  Created by Cem Kılınç on 28.12.2021.
//

import Foundation
import Firebase

class CommentUploadManager {
    
    var delegate: CommentUploadManagerDelegate?
    
    func uploadComment(comment: String, postReference: DocumentReference) {
        postReference.updateData(["comments": FieldValue.arrayUnion([["owner" : FireStoreConstants.shared.currentUser!.userReference, "owner_username" : FireStoreConstants.shared.currentUser!.userName, "comment" : comment]])]) {error in
            if let error = error {
                self.delegate?.uploadFailed(error: error)
            }else{
                self.delegate?.commentUploaded()
            }
        }
    }
}
