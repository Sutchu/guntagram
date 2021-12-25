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

    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.updateFields()
    }
    
    func updateFields() {
        if let postObject = self.postObject {
            self.likeLabel.text = "\(postObject.likeCount) likes, \(postObject.owner)"
            self.postImage.image = postObject.uiImage
            if postObject.isPostLiked {
                likeButton.setTitle("Unlike", for: .normal)
            } else {
                likeButton.setTitle("Like", for: .normal)
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
