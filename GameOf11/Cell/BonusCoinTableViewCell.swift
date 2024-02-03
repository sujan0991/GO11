//
//  BonusCoinTableViewCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 29/3/22.
//  Copyright © 2022 Tanvir Palash. All rights reserved.
//

import UIKit

class BonusCoinTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bonusPackNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var bonusAmountLabel: UILabel!
    
    override func awakeFromNib() {
        
//        self.layer.applySketchShadow(
//            color: UIColor.lightGray,
//            alpha: 1.0,
//            x: 0,
//            y: 2,
//            blur: 8,
//            spread: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

            // Set background color
            let view = UIView()
            view.backgroundColor = UIColor.lightGray
            selectedBackgroundView = view

        
    }
    


}
