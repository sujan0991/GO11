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
    @IBOutlet weak var selectedPerLbl: UILabel!
    
    @IBOutlet weak var teamCode: UILabel!
    @IBOutlet weak var creditScore: UILabel!
  
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var isInLineUp: UIImageView!
    @IBOutlet weak var announcedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      
        playerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        isInLineUp.makeCircular(borderWidth: 0, borderColor: .clear)
        
        announcedLabel.text = "Announced".localized
        
    }

    
    func setInfo( player:Player ,  squad : PlayingTeamsData, isLineUpOut: Int)  {
        
        //print(player.toJSON())
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
             
       
        
        playerName.text = player.name
        creditScore.text = "\(player.creditPoints ?? 0)"
    
        var bnLowRankString = "\(player.selectedPer ?? 0)"
        
        if Language.language != Language.english{
            
            bnLowRankString = formatter.string(for:player.selectedPer)!
        }
        
        print("bnLowRankString...............",bnLowRankString,player.selectedPer,player.name)
        
        selectedPerLbl.text =  String.init(format: "Favourite: %@%%".localized, bnLowRankString)
        
        self.selectButton.isSelected = player.playerSelected
        
        if self.selectButton.isSelected{
            
            self.backgroundColor = UIColor.init(named: "orange_to_blue")
            
        }else{
            
             self.backgroundColor = UIColor.init(named: "brand_bg_color")
        }
        
        let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(player.playerImage ?? "")")
        
        playerImage.kf.setImage(with: url1)
        
        print("isLineUpOut..........????",isLineUpOut)
        if isLineUpOut == 1{
            
            if player.is_in_playing_xi == 1{
                
                isInLineUp.isHidden = false
                isInLineUp.backgroundColor = UIColor.init(named: "on_green")!
                announcedLabel.isHidden = false
                
            }else{
                
                isInLineUp.isHidden = false
                isInLineUp.backgroundColor = UIColor.init(named: "brand_orange")!
                announcedLabel.isHidden = true
            }
        }else{
            
            isInLineUp.isHidden = true
            announcedLabel.isHidden = true
        }
        
        
        if player.teamBelong == 1
        {
             if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                teamCode.text = squad.firstTeam?.teamKey?.uppercased()
                if player.playerImage == nil{
                    
                    playerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                }else if url1 == nil{
                    playerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                }
                
             }else{
                
                teamCode.text = squad.firstTeam?.code?.uppercased()
                if player.playerImage == nil{
                    
                    playerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                }else if url1 == nil{
                    playerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                }
                
             }
            
            
            
        }
        else
        {
             if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                teamCode.text = squad.secondTeam?.teamKey?.uppercased()
                if player.playerImage == nil{
                    playerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                }else if url1 == nil{
                    playerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                }
             }else{
                teamCode.text = squad.secondTeam?.code?.uppercased()
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

     //   self.selectButton.isSelected = selected
        
        // Configure the view for the selected state
    }
}
