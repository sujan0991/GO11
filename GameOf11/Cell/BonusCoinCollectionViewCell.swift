//
//  BonusCoinCollectionViewCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 29/3/22.
//  Copyright © 2022 Tanvir Palash. All rights reserved.
//
import UIKit

class BonusCoinCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var coinAmountLabel: UILabel!
    
    override func awakeFromNib() {
        
        self.layer.applySketchShadow(
            color: UIColor.lightGray,
            alpha: 1.0,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0)
        
        self.contentView.makeRound(10, borderWidth: 1, borderColor: UIColor.init(named: "on_green")!)
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
            
            coinAmountLabel.textColor = isSelected ? UIColor.white: UIColor.init(named: "green_to_white")!
        }
    }

}
