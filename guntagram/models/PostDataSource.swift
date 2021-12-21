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

class PostDataSource {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()

    var postArray: [Post] = []
    var delegate: PostDataSourceProtocol?
    
    func fetchAllPosts() {
        let postsRef = db.collection("posts").order(by: "upload_time").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let likeCount = document.get("like_count") as! Int
                    let imagePath = document.get("image_path") as! String
                    let ownerReference = document.get("owner") as! DocumentReference
                    
                    //let uploadTime = document.value(forKey: "upload_time")
                    //print(imagePath)
                    // Create a reference to the file you want to download
                    let imageRef = self.storage.child(imagePath)

                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    imageRef.getData(maxSize: 1 * 10024 * 10024) { data, error in
                        if let error = error {
                            print("Error occured when getting image with url from storage \(error)")
                        } else {
                            if let image = UIImage(data: data!) {
                                print("saas")
                                self.postArray.append(Post(uiImage: image, likeCount: likeCount, owner: ownerReference))
                                self.delegate?.postLoaded()

                            }
                        }
                    }
                }
                            }
        }
    }
    
    func getPostAtIndex(index: Int) -> Post {
        return postArray[index]
    }
    
    func getPostCount() -> Int {
        print(postArray.count)
        return postArray.count
    }
}
