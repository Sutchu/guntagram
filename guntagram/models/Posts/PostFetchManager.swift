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
    private var lastFetchTimeStamp = 0.0
    private var postArray: [Post?] = []
    var delegate: PostFetchManagerProtocol?

    func fetchNewPosts(startingIndex: Int, endingIndex: Int) {
        db.collection("posts").whereField("upload_time", isGreaterThanOrEqualTo: self.lastFetchTimeStamp).order(by: "upload_time", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let documents = querySnapshot!.documents
                self.lastFetchTimeStamp = NSDate().timeIntervalSince1970
                self.postArray.insert(contentsOf: [Post?](repeating: nil, count: documents.count), at: 0)
                if documents.count == 0 {
                    self.delegate?.postLoaded()
                }
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

                    // Create a reference to the file you want to download
                    let imageRef = self.storage.child(imagePath)

                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    imageRef.getData(maxSize: 1 * 10024 * 10024) { data, error in
                        if let error = error {
                            print("Error occured when getting image with url from storage \(error)")
                            //self.delegate?.postLoaded()
                        } else {
                            if let image = UIImage(data: data!) {
                                let isPostLiked = likingUserArray.contains(FireStoreConstants.shared.currentUser!)
                                self.postArray[index] = Post(uiImage: image, likeCount: likeCount, owner: owner, postReference: document.reference, likingUsers: likingUserArray, isPostLiked: isPostLiked, uploadTime: uploadTime)
                                self.delegate?.postLoaded()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func refreshPostArray() {
        //postArray = []
        fetchNewPosts(startingIndex: 1, endingIndex: 10)
    }
    
    func getPostAtIndex(index: Int) -> Post? {
        return postArray[index]
    }
    
    func getPostCount() -> Int {
        return postArray.count
    }
    
}
