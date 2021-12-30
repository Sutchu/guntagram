//
//  PostUpdateManager.swift
//  guntagram
//
//  Created by Ali Sutcu on 25.12.2021.
//

import Foundation
import Firebase

class PostUpdateManager {
    private let db = Firestore.firestore()
    var delegate: PostUpdateManagerProtocol?
    let user = FireStoreConstants.shared.currentUser!
    
    func changeLikeCount(post: Post) {
        let postReference = post.postReference
        if post.isPostLiked {
            modifyPostObject(post: post, isLiked: true)
            self.removeFromLikingUsers(postReference: postReference, completion: {
                self.decreaseLikeCount(postReference: postReference)
            })
        } else {
            modifyPostObject(post: post, isLiked: false)
            self.addToLikingUsers(postReference: postReference, completion: {
                self.increaseLikeCount(postReference: postReference)
            })
        }        
    }
    
    func modifyPostObject(post: Post, isLiked: Bool){
        if isLiked {
            if let index = post.likingUsers.firstIndex(of: user) {
                post.likeCount -= 1
                post.likingUsers.remove(at: index)
                post.isPostLiked = false
            }
        } else {
            post.likeCount += 1
            post.likingUsers.append(user)
            post.isPostLiked = true
        }
    }
    
    func increaseLikeCount(postReference: DocumentReference) {
        postReference.updateData([
            "like_count": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                self.delegate?.updateFailed(error: error)
            }
        }
    }
    
    func decreaseLikeCount(postReference: DocumentReference) {
        postReference.updateData([
            "like_count": FieldValue.increment(Int64(-1))
        ]) { error in
            if let error = error {
                self.delegate?.updateFailed(error: error)
            }
        }
    }

    
    func addToLikingUsers(postReference: DocumentReference,completion: @escaping () -> Void) {
        postReference.updateData(["liking_users": FieldValue.arrayUnion([["user_name": FireStoreConstants.shared.currentUser!.userName, "user_reference": FireStoreConstants.shared.currentUser!.userReference]])]) { error in
            if let error = error {
                self.delegate?.updateFailed(error: error)
            } else {
                completion()
            }
        }
    }
    
    func removeFromLikingUsers(postReference: DocumentReference,completion: @escaping () -> Void) {
        postReference.updateData(["liking_users": FieldValue.arrayRemove([["user_name": FireStoreConstants.shared.currentUser!.userName, "user_reference": FireStoreConstants.shared.currentUser!.userReference]])]) { error in
            if let error = error {
                self.delegate?.updateFailed(error: error)
            } else {
                completion()
            }
        }
    }
}
