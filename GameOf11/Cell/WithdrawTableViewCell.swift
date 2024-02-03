//
//  WithdrawTableViewCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 27/8/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class WithdrawTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var withdrawMethodLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var transnumberLabel: UILabel!
    @IBOutlet weak var transIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
