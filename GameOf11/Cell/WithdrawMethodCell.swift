//
//  RadioCell.swift
//  RadioButtonDemo
//
//  Created by Roland Leth on 19.10.2016.
//  Copyright © 2016 Roland Leth. All rights reserved.
//

import UIKit

class WithdrawMethodCell: UITableViewCell {
	
    
    @IBOutlet weak var radioButton: UIImageView!
    @IBOutlet weak var methodName: UILabel!
    

    // 2
        private let checked = UIImage(named: "radioSelected")
        private let unchecked = UIImage(named: "radioDeSelected")
     
        // 3
        override func awakeFromNib() {
            super.awakeFromNib()
        }
     
        // 4
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
     
        // 5
        public func configure(_ text: String) {
            methodName.text = text
        }
     
        // 6
        public func isSelected(_ selected: Bool) {
            setSelected(selected, animated: false)
            let image = selected ? checked : unchecked
            radioButton.image = image
        }
}
