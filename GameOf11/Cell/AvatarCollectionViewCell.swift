//
//  AvatarCollectionViewCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 22/8/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var selectionImageView: UIImageView!
    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                selectionImageView.isHidden = false
            }
            else
            {
                selectionImageView.isHidden = true
            }
            
            
        }
    }

}
