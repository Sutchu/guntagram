//
//  PostDataSource.swift
//  guntagram
//
//  Created by Ali Sutcu on 21.12.2021.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class PostFetchManager {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    private var lastFetchedDocument: DocumentSnapshot?
    private var postArray: [Post?] = []
    
    var isBusy: Bool = false
    
    var delegate: PostFetchManagerProtocol?
    
    

    func fetchNewPosts(batchSize: Int = 6) {
        if isBusy {
            return
        } else {
            isBusy = true
        }
        
        var query: Query!
        let dispatchGroup = DispatchGroup()
        
        if postArray.isEmpty {
                query = db.collection("posts").order(by: "upload_time", descending: true).limit(to: batchSize)
            } else {
                query = db.collection("posts").order(by: "upload_time", descending: true).start(afterDocument: lastFetchedDocument!).limit(to: batchSize)
            }
            
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err.localizedDescription)")
            } else if querySnapshot!.isEmpty {
                self.delegate?.postLoaded()
            } else {
                let documents = querySnapshot!.documents
                self.postArray.insert(contentsOf: [Post?](repeating: nil, count: documents.count), at: self.postArray.endIndex)
                
                for (index, document) in documents.enumerated() {
                    let likeCount = document.get("like_count") as! Int
                    let imagePath = document.get("image_path") as! String
                    let ownerReference = document.get("owner") as! DocumentReference
                    let likingUsers = document.get("liking_users") as! [Dictionary<String, Any>]
                    let uploadTime = document.get("upload_time") as! TimeInterval
                    var likingUserArray: [User] = []
                    for likingUser in likingUsers {
                        let userName = likingUser["user_name"] as! String
                        let userReference = likingUser["user_reference"] as! DocumentReference
                        likingUserArray.append(User(userName: userName, userReference: userReference))
                    }
                    let ownerUserName = document.get("owner_username") as! String
                    let owner = User(userName: ownerUserName, userReference: ownerReference)

                    // Reference to the post image to download
                    let imageRef = self.storage.child(imagePath)

                    dispatchGroup.enter()
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    imageRef.getData(maxSize: 1 * 10024 * 10024) { data, error in
                        if let error = error {
                            print("Error occured when getting image with url from storage \(error.localizedDescription)")
                        } else {
                            if let image = UIImage(data: data!) {
                                let isPostLiked = likingUserArray.contains(FireStoreConstants.shared.currentUser!)
                                let post = Post(uiImage: image, likeCount: likeCount, owner: owner, postReference: document.reference, likingUsers: likingUserArray, isPostLiked: isPostLiked, uploadTime: uploadTime)
                                self.postArray[self.postArray.endIndex - documents.count + index] = post
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
                self.lastFetchedDocument = querySnapshot!.documents.last
            }
            
            dispatchGroup.notify(queue: .main) {
                self.delegate?.postLoaded()
                self.isBusy = false
            }
        }
    }
    
    func refreshPostArray() {
        postArray = []
        fetchNewPosts()
    }
    
    func getPostAtIndex(index: Int) -> Post? {
        if postArray.count > index {
            return postArray[index]
        } else {
            return nil
        }
    }
    
    func getPostCount() -> Int {
        return postArray.count
    }
    
}
