//
//  Post.swift
//  guntagram
//
//  Created by Ali Sutcu on 16.12.2021.
//

import Foundation
import UIKit
import Firebase

class Post {
    let uiImage: UIImage
    var likeCount: Int = 0
    let owner: User
    let postReference: DocumentReference
    var likingUsers: [User]
    var isPostLiked: Bool
    
    init(uiImage : UIImage, likeCount: Int, owner: User, postReference: DocumentReference, likingUsers: [User], isPostLiked: Bool) {
        self.likingUsers = likingUsers
        self.postReference = postReference
        self.isPostLiked = isPostLiked
        self.likeCount = likeCount
        self.owner = owner
        self.uiImage = uiImage
    }
}
