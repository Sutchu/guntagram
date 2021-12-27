//
//  CommentDataSource.swift
//  guntagram
//
//  Created by Cem Kılınç on 28.12.2021.
//

import Foundation
import Firebase

class CommentDataSource {
    
    private var comments: [Comment] = []
    
    func getComments(post: Post) {
        let rawComments = post.comments
        for rawComment in rawComments {
            comments.append(Comment(owner: rawComment["owner"] as! DocumentReference , ownerUsername: rawComment["owner_username"] as! String, comment: rawComment["comment"] as! String ))
        }
    }
    
    func getNumberOfComment() -> Int {
        return comments.count
    }
    
    func getCommentAtIndex(index: Int) -> Comment?{
        return comments[index]
    }
}
