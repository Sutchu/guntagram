//
//  PostTableViewCell.swift
//  guntagram
//
//  Created by Ali Sutcu on 21.12.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    var likePressedCallback: (() -> Void)?
    var postObject: Post?

    @IBOutlet weak var ownerUsernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.updateFields()        
    }
    
    func updateFields() {
        if let postObject = self.postObject {
            self.likeLabel.text = "\(postObject.likeCount) likes"
            self.postImage.image = postObject.uiImage
            self.ownerUsernameLabel.text = postObject.ownerUsername
            if postObject.isPostLiked {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                likeButton.tintColor = UIColor.red
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                likeButton.tintColor = UIColor.white
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if let callback = self.likePressedCallback {
            callback()
        }
    }
    
}
