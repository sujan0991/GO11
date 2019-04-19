//
//  TeamPlayerTableViewCell.swift
//  GameOf11
//
//  Created by Tanvir Palash on 16/4/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class TeamPlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerDetails: UILabel!
    
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var viceCaptainButton: UIButton!
    @IBOutlet weak var captainButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         playerImage.makeCircular(borderWidth: 0, borderColor: .clear)
    }
    
    func setInfo( player:Player ,  squad : PlayingTeamsData)  {
        
       // print(player.toJSON())
        
        playerName.text = player.name
        
        self.viceCaptainButton.isSelected = player.isViceCaptain
        self.captainButton.isSelected = player.isCaptain
        
        if(player.isCaptain == true)
        {
            offerImage.isHidden = false
            offerImage.image = UIImage.init(named: "2xPointImage")
        }
        else if(player.isViceCaptain)
        {
            offerImage.isHidden = false
            offerImage.image = UIImage.init(named: "1.5xPointImage")
        }
        else
        {
             offerImage.isHidden = true
        }
        
        
        if player.teamBelong == 1
        {
            playerDetails.text = " \(squad.firstTeam?.name ?? "") | \(player.creditPoints ?? 0)"
            
        }
        else
        {
            playerDetails.text = " \(squad.secondTeam?.name ?? "") | \(player.creditPoints ?? 0)"
        }
        
        let url1 = URL(string: "\(API_K.BaseUrlStr)\(player.playerImage ?? "")")
        
        playerImage.kf.setImage(with: url1)
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
