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
    
    @IBOutlet weak var teamNamelabel: UILabel!
    
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var viceCaptainButton: UIButton!
    @IBOutlet weak var captainButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        captainButton.makeCircular(borderWidth: 0.5, borderColor: UIColor.darkGray)
        viceCaptainButton.makeCircular(borderWidth: 0.5, borderColor: UIColor.darkGray)
    }
    
    func setInfo( player:Player ,  squad : PlayingTeamsData)  {
        
        // print(player.toJSON())
        
        playerName.text = player.name
        
        self.viceCaptainButton.isSelected = player.isViceCaptain
        self.captainButton.isSelected = player.isCaptain
        
        if self.captainButton.isSelected {
            captainButton.backgroundColor = UIColor.init(named: "GreenHighlight")
            captainButton.layer.borderColor = UIColor.init(named: "GreenHighlight")?.cgColor
            captainButton.setTitleColor(UIColor.white, for: .selected)
        }else{
            captainButton.backgroundColor = UIColor.white
            captainButton.layer.borderColor = UIColor.darkGray.cgColor
            captainButton.setTitleColor(UIColor.init(named: "brand_txt_color_black"), for: .normal)
        }
        if self.viceCaptainButton.isSelected {
            viceCaptainButton.backgroundColor = UIColor.init(named: "brand_orange")
            viceCaptainButton.layer.borderColor = UIColor.init(named: "brand_orange")?.cgColor
            viceCaptainButton.setTitleColor(UIColor.white, for: .selected)
        }else{
            viceCaptainButton.backgroundColor = UIColor.white
            viceCaptainButton.layer.borderColor = UIColor.darkGray.cgColor
            viceCaptainButton.setTitleColor(UIColor.init(named: "brand_txt_color_black"), for: .normal)
        }
        
        
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
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                teamNamelabel.text = squad.firstTeam?.teamKey?.uppercased() ?? ""
            }else{
                
                teamNamelabel.text = squad.firstTeam?.code?.uppercased() ?? ""
            }
            
            playerDetails.text = " | \(player.role?.uppercased() ?? "") | \(player.creditPoints ?? 0)"
            
        }
        else
        {
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                teamNamelabel.text = squad.secondTeam?.teamKey?.uppercased() ?? ""
                
            }else{
                teamNamelabel.text = squad.secondTeam?.code?.uppercased() ?? ""                
            }
            
            playerDetails.text = " | \(player.role?.uppercased() ?? "") | \(player.creditPoints ?? 0)"
        }
        let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(player.playerImage ?? "")")
        playerImage.kf.setImage(with: url1)
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            if player.teamBelong == 1{
                
                if player.playerImage == nil{
                    
                    playerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                }else if url1 == nil{
                    playerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                }
            }else{
                
                if player.playerImage == nil{
                    
                    playerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                }else if url1 == nil{
                    playerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                }
            }
            
        }else{
            
            if player.teamBelong == 1{
                
                if player.playerImage == nil{
                    
                    playerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                }else if url1 == nil{
                    playerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                }
            }else{
                
                if player.playerImage == nil{
                    
                    playerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                }else if url1 == nil{
                    playerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                }
            }
            
        }
        
        
        
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }
    
}
