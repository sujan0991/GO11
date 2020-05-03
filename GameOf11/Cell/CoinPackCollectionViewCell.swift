//
//  CoinPackCollectionViewCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 1/8/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class CoinPackCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var oldpackLabel: UILabel!
    
    @IBOutlet weak var newPackLabel: UILabel!
    
    @IBOutlet weak var counAmountLabel: UILabel!
    
    override func awakeFromNib() {
        
        self.layer.applySketchShadow(
            color: UIColor.lightGray,
            alpha: 1.0,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0)
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.contentView.backgroundColor = UIColor.init(named: "on_green")!
                
            }
            else
            {
                self.contentView.backgroundColor = UIColor.init(named: "cell_bg")!
            }
            
           oldpackLabel.textColor = isSelected ? UIColor.white: UIColor.init(named: "brand_txt_color_black")!
           newPackLabel.textColor = isSelected ? UIColor.white: UIColor.init(named: "brand_txt_color_black")!
           counAmountLabel.textColor = isSelected ? UIColor.white: UIColor.init(named: "brand_txt_color_black")!
        }
    }

}
