//
//  PostionCollectionViewCell.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class PositionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var positionTitle: UILabel!
    @IBOutlet weak var positionIcon: UIImageView!
    @IBOutlet weak var playerCount: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.positionIcon.tintColor = isSelected ? UIColor.init(named: "GreenHighlight") : UIColor.init(named: "HighlightGrey")
           
        }
    }
    
    override func awakeFromNib() {
        playerCount.makeCircular(borderWidth: 0, borderColor: .clear)
        
    }
}
