//
//  AnnouncementTableViewCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 4/2/20.
//  Copyright © 2020 Tanvir Palash. All rights reserved.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
