//
//  RadioCell.swift
//  RadioButtonDemo
//
//  Created by Roland Leth on 19.10.2016.
//  Copyright © 2016 Roland Leth. All rights reserved.
//

import UIKit

class PaymentChannelCell: UITableViewCell {
    
    
    @IBOutlet weak var methodIcon: UIImageView!
    @IBOutlet weak var radioButton: UIImageView!
    @IBOutlet weak var methodName: UILabel!
    
    
    // 2
    private var checked = UIImage(named: "radioSelected")
    private var unchecked = UIImage(named: "radioDeSelected")
    
    // 3
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // 4
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 5
//    public func configure(_ text: String, _ channelImageLink: String) {
//
//        methodName.text = text
//
//
//        let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(channelImageLink)")
//
//        self.methodIcon.kf.setImage(with: url1)
//
//    }
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
