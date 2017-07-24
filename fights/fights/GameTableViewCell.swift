//
//  GameTableViewCell.swift
//  fights
//
//  Created by Юрий on 13.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet var player1: UILabel!
    @IBOutlet var score: UILabel!
    @IBOutlet var player2: UILabel!
    
    var game_id: Int!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
