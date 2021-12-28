//
//  CommentDataSource.swift
//  guntagram
//
//  Created by Cem Kılınç on 28.12.2021.
//

import Foundation
import Firebase

class CommentFetchManager {
    
    private var comments: [Comment?] = []
    private let db = Firestore.firestore()
    var delegate: CommentFetchManagerDelegate?
    
    func fetchComments(post: Post) {
        let postReference = post.postReference
        postReference.getDocument { (document, error) in
            if let error = error {
                self.delegate?.fetchingFailed(error: error)
            }
            if let document = document, document.exists {
                let rawComments = document.data()!["comments"] as! [Dictionary<String, Any>]
                self.comments = [Comment?](repeating: nil, count: rawComments.count)
                for (i, rawComment) in rawComments.enumerated() {
                    let ownerUserName = rawComment["owner_username"] as! String
                    let comment = rawComment["comment"] as! String
                    let owner = rawComment["owner"] as! DocumentReference
                    self.comments[i] = Comment(owner: owner, ownerUsername: ownerUserName, comment: comment)
                }
                self.delegate?.fetchCompleted()
            }
        }
    }
    
    func getNumberOfComment() -> Int {
        return comments.count
    }
    
    func getCommentAtIndex(index: Int) -> Comment?{
        return comments[index]
    }
}
