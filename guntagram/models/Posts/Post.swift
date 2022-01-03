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
    let uploadTime: Date
    var likingUsers: [User]
    var isPostLiked: Bool
    var uploadTimeDescription: String
    
    init(uiImage : UIImage, likeCount: Int, owner: User, postReference: DocumentReference, likingUsers: [User], isPostLiked: Bool, uploadTime: TimeInterval) {
        self.likingUsers = likingUsers
        self.postReference = postReference
        self.isPostLiked = isPostLiked
        self.likeCount = likeCount
        self.owner = owner
        self.uiImage = uiImage
        self.uploadTime = Date(timeIntervalSince1970: uploadTime)
        self.uploadTimeDescription = ""
        
        initUploadTimeString()
    }
    
    func initUploadTimeString() {
        let passedSeconds = Int(uploadTime.distance(to: Date.now))
        
        if (passedSeconds < 60) {
            uploadTimeDescription =  "\(passedSeconds) seconds ago"
        } else if (passedSeconds < 60 * 60) {
            uploadTimeDescription =  "\(passedSeconds / 60) minutes ago"
        } else if (passedSeconds < (24 * 60 * 60)) {
            uploadTimeDescription =  "\(passedSeconds / (60 * 60)) hours ago"
        } else if (passedSeconds < (7 * 24 * 60 * 60)) {
            uploadTimeDescription =  "\(passedSeconds / (60 * 60 * 24)) days ago"
        } else {
            uploadTimeDescription = uploadTime.description(with: Locale.current)
        }
    }
}
