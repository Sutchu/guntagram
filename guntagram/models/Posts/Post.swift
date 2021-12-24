//
//  Post.swift
//  guntagram
//
//  Created by Ali Sutcu on 16.12.2021.
//

import Foundation
import UIKit
import Firebase

struct Post {
    let uiImage: UIImage
    let likeCount: Int
    let owner: DocumentReference
}
