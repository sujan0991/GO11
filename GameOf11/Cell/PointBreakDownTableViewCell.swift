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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        captainLabel.isHidden = true
        xLabel.isHidden = true
        
    }
    
    func setInfo(_ playerInfo:PlayerInfoData)  {
        
        playerName.text = playerInfo.player_name
        playerRollLabel.text = playerInfo.player_role
        pointLabel.text = "\(playerInfo.player_earning_point ?? 0)"
        
        if playerInfo.is_captain == 1{
            
            captainLabel.isHidden = false
            xLabel.isHidden = false
            captainLabel.text = "C"
            xLabel.text = "2x"
            
        }else if playerInfo.is_vice_captain == 1{
            
            captainLabel.isHidden = false
            captainLabel.text = "VC"
            xLabel.isHidden = false
            xLabel.text = "1.5x"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
