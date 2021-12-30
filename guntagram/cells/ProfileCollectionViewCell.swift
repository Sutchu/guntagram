//
//  ProfileCollectionViewCell.swift
//  guntagram
//
//  Created by Ali Sutcu on 31.12.2021.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    
    func setImageFromPost(post: Post) {
        postImageView.image = post.uiImage
        
    }
}
