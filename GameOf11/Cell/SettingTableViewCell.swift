//
//  SettingTableViewCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 31/3/20.
//  Copyright © 2020 Tanvir Palash. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
