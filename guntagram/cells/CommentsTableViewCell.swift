//
//  CommentsTableViewCell.swift
//  guntagram
//
//  Created by Cem Kılınç on 27.12.2021.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var commentOwnerLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

 
}
