//
//  CommentDataSource.swift
//  guntagram
//
//  Created by Cem Kılınç on 28.12.2021.
//

import Foundation

class CommentDataSource {
    
    private var comments: [Comment] = []
    
    func getComments(post: Post) {
        let rawComments = post.comments
        for rawComment in rawComments {
            comments.append(Comment(owner: rawComment.0, ownerUsername: rawComment.1, comment: rawComment.2))
        }
    }
    
    func getNumberOfComment() -> Int {
        return comments.count
    }
    
    func getCommentAtIndex(index: Int) -> Comment?{
        return comments[index]
    }
}
