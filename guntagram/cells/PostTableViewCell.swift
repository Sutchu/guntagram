//
//  PostTableViewCell.swift
//  guntagram
//
//  Created by Ali Sutcu on 21.12.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
