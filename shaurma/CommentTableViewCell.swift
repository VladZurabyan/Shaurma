//
//  CommentTableViewCell.swift
//  shaurma
//
//  Created by Admin on 8/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Cosmos

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
