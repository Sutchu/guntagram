//
//  ProfileFetchManager.swift
//  guntagram
//
//  Created by Ali Sutcu on 30.12.2021.
//

import Foundation
import Firebase
import FirebaseStorage

class ProfileFetchManager {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    var posts: [Post?] = []
    var delegate: ProfileFetchManagerProtocol?
    
    var totalLikeCount: Int = 0
    
    func fetchPosts(user: User) {
        db.collection("posts").whereField("owner", isEqualTo: user.userReference).order(by: "upload_time", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let documents = querySnapshot!.documents
                self.posts = [Post?](repeating: nil, count: documents.count)
                self.totalLikeCount = 0
                if documents.count == 0 {
                    self.delegate?.postLoaded()
                }
                let currentUser = FireStoreConstants.shared.currentUser!
                for (index, document) in documents.enumerated() {
                    let likeCount = document.get("like_count") as! Int
                    self.totalLikeCount += likeCount
                    let imagePath = document.get("image_path") as! String
                    let ownerReference = document.get("owner") as! DocumentReference
                    let likingUsers = document.get("liking_users") as! [Dictionary<String, Any>]
                    var likingUserArray: [User] = []
                    for likingUser in likingUsers {
                        let userName = likingUser["user_name"] as! String
                        let userReference = likingUser["user_reference"] as! DocumentReference
                        likingUserArray.append(User(userName: userName, userReference: userReference))
                    }
                    let ownerUserName = document.get("owner_username") as! String
                    let owner = User(userName: ownerUserName, userReference: ownerReference)
                    //let uploadTime = document.value(forKey: "upload_time")
                    // Create a reference to the file you want to download
                    let imageRef = self.storage.child(imagePath)

                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    imageRef.getData(maxSize: 1 * 10024 * 10024) { data, error in
                        if let error = error {
                            print("Error occured when getting image with url from storage \(error)")
                            //self.delegate?.postLoaded()
                        } else {
                            if let image = UIImage(data: data!) {
                                let isPostLiked = likingUserArray.contains(currentUser)
                                self.posts[index] = Post(uiImage: image, likeCount: likeCount, owner: owner, postReference: document.reference, likingUsers: likingUserArray, isPostLiked: isPostLiked)
                                self.delegate?.postLoaded()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getPostCount() -> Int {
        return posts.count
    }
    
    func getTotalLikeCount() -> Int {
        return totalLikeCount
    }
    
    func getPostAt(index: Int) -> Post? {
        return posts[index]
    }
}
