//
//  PlayerTableViewCell.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var teamCode: UILabel!
    @IBOutlet weak var creditScore: UILabel!
  
    @IBOutlet weak var selectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        
    }

    
    func setInfo( player:Player ,  squad : PlayingTeamsData)  {
        
        //print(player.toJSON())
        
       
        
        playerName.text = player.name
        creditScore.text = "\(player.creditPoints ?? 0)"
        
        self.selectButton.isSelected = player.playerSelected
        
        if self.selectButton.isSelected{
            
             self.backgroundColor = UIColor("#FAE5D3")
            
        }else{
            
             self.backgroundColor = UIColor.white
        }
        
        let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(player.playerImage ?? "")")
        
        playerImage.kf.setImage(with: url1)
        
        
        if player.teamBelong == 1
        {
            teamCode.text = squad.firstTeam?.teamKey?.uppercased()
            
            if player.playerImage == nil{
                
                playerImage.image = UIImage.init(named: "player_avatar_team_1.png")
            }else if url1 == nil{
                playerImage.image = UIImage.init(named: "player_avatar_team_1.png")
            }
            
        }
        else
        {
            teamCode.text = squad.secondTeam?.teamKey?.uppercased()
            if player.playerImage == nil{
                playerImage.image = UIImage.init(named: "player_avatar_team_2.png")
            }else if url1 == nil{
                playerImage.image = UIImage.init(named: "player_avatar_team_2.png")
            }

        }
        
        
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     //   self.selectButton.isSelected = selected
        
        // Configure the view for the selected state
    }
}
