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
            print("selected...............")
//            self.positionIcon.tintColor = isSelected ? UIColor.init(named: "on_green") : UIColor.init(named: "HighlightGrey")
           
//            positionTitle.textColor = UIColor.init(named: "dark_to_white")
//            playerCount.textColor = UIColor.init(named: "dark_to_white")

        }
    }
    
    override func awakeFromNib() {
        playerCount.makeCircular(borderWidth: 0, borderColor: .clear)
        
    }
}
