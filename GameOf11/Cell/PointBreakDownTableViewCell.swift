//
//  PointBreakDownTableViewCell.swift
//  CompleteCont
//
//  Created by Md.Ballal Hossen on 12/3/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit

class PointBreakDownTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerRollLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var captainLabel: UILabel!
    
     let formatter = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        captainLabel.isHidden = true
        xLabel.isHidden = true
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
    }
    
    func setInfo(_ playerInfo:PlayerInfoData)  {
        
        playerName.text = playerInfo.player_name ?? ""
        playerRollLabel.text = playerInfo.player_role?.uppercased()
        
        if Language.language == Language.english{
            pointLabel.text = "\(playerInfo.player_earning_point ?? 0)"
            
        }else{
            
            pointLabel.text = formatter.string(from: playerInfo.player_earning_point! as NSNumber) ?? "০.০"
            
        }
        
        captainLabel.layer.cornerRadius = 12
        captainLabel.clipsToBounds = true
        captainLabel.layer.borderWidth = 1.0
        captainLabel.layer.borderColor = UIColor.lightGray.cgColor
        
        if playerInfo.player_image != nil{
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(playerInfo.player_image ?? "")")
            playerImageView.kf.setImage(with: url1)
            if url1 == nil{
                playerImageView.image = UIImage.init(named: "player_avatar_global.png")
            }
        }else{
            
            playerImageView.image = UIImage.init(named: "player_avatar_global.png")
        
        }
        
//        if playerInfo.is_captain == 1{
//
//
//            self.captainLabel.isHidden = false
//            self.xLabel.isHidden = false
//            self.captainLabel.text = "C"
//            self.captainLabel.backgroundColor = UIColor.init(named: "GreenHighlight")!
//            self.xLabel.text = "2x"
//            self.xLabel.textColor = UIColor.init(named: "GreenHighlight")!
//
//        }
//        if playerInfo.is_vice_captain == 1{
//
//            self.captainLabel.isHidden = false
//            self.captainLabel.text = "VC"
//            self.captainLabel.backgroundColor = UIColor.init(named: "TabOrangeColor")!
//            self.xLabel.isHidden = false
//            self.xLabel.text = "1.5x"
//            self.xLabel.textColor = UIColor.init(named: "TabOrangeColor")!
//
//        }
        
    }
    override func prepareForReuse() {

        super.prepareForReuse()
        
        self.captainLabel.isHidden = true
        self.xLabel.isHidden = true

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
