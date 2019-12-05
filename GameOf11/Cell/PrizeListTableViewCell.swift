//
//  PrizeListTableViewCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 14/7/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class PrizeListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var prizeIconImageView: UIImageView!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
