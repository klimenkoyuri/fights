//
//  CommentTableViewCell.swift
//  fights
//
//  Created by Юрий on 25.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet var Author: UILabel!
    @IBOutlet var comment: UILabel!
    var player_id: Int!
    var is_liked:Bool!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
