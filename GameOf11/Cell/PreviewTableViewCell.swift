//
//  PreviewTableViewCell.swift
//  GameOf11
//
//  Created by Tanvir Palash on 24/4/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class PreviewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var firstPlayer: UIView!
    @IBOutlet weak var secondPlayer: UIView!
    @IBOutlet weak var thirdPlayer: UIView!
    
    @IBOutlet weak var fourthPlayer: UIView!
    @IBOutlet weak var fifthPlayer: UIView!
    @IBOutlet weak var sixthPlayer: UIView!
    
    @IBOutlet weak var firstPlayerImage: UIImageView!
    @IBOutlet weak var secondPlayerImage: UIImageView!
    @IBOutlet weak var thirdPlayerImage: UIImageView!
    @IBOutlet weak var fourthPlayerImage: UIImageView!
    @IBOutlet weak var fifthPlayerImage: UIImageView!
    @IBOutlet weak var sixthPlayerImage: UIImageView!
    
    @IBOutlet weak var firstPlayerName: UILabel!
    @IBOutlet weak var secondPlayerName: UILabel!
    @IBOutlet weak var thirdPlayerName: UILabel!
    @IBOutlet weak var fourthPlayerName: UILabel!
    @IBOutlet weak var fifthPlayerName: UILabel!
    @IBOutlet weak var sixthPlayerName: UILabel!
    
    @IBOutlet weak var firstCap: UILabel!
    @IBOutlet weak var secondCap: UILabel!
    @IBOutlet weak var thirdCap: UILabel!
    @IBOutlet weak var fourthCap: UILabel!
    @IBOutlet weak var fifthCap: UILabel!
    @IBOutlet weak var sixthCap: UILabel!
    
    @IBOutlet weak var firstPlayerCP: UILabel!
    @IBOutlet weak var secondPlayerCP: UILabel!
    @IBOutlet weak var thirdPlayerCP: UILabel!
    @IBOutlet weak var fourthPlayerCP: UILabel!
    @IBOutlet weak var fifthPlayerCP: UILabel!
    @IBOutlet weak var sixthPlayerCP: UILabel!
   
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        secondPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        thirdPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        fourthPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        fifthPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        sixthPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        
//        firstCap.makeCircular(borderWidth: 1.0, borderColor: UIColor.clear)
//        secondCap.makeCircular(borderWidth: 1.0, borderColor: UIColor.clear)
//        thirdCap.makeCircular(borderWidth: 1.0, borderColor: UIColor.clear)
//        fourthCap.makeCircular(borderWidth: 1.0, borderColor: UIColor.clear)
//        fifthCap.makeCircular(borderWidth: 1.0, borderColor: UIColor.clear)
//        sixthCap.makeCircular(borderWidth: 1.0, borderColor: UIColor.clear)

    }



func setInfo( players:[Player])  {
    
    print(players.count)
    //[self.stackView.arrangedSubviews[_expandedViewIndex] setHidden: YES];
    // print(player.toJSON())
    
    firstPlayer.isHidden = true
    secondPlayer.isHidden = true
    thirdPlayer.isHidden = true
    fourthPlayer.isHidden = true
    fifthPlayer.isHidden = true
    sixthPlayer.isHidden = true
    
    var player: Player!
    
    for index in 0..<players.count
    {
        let firstView = stackView.arrangedSubviews[index]
        firstView.isHidden = false
        
        player = players.item(at: index)
        
        if index == 0
        {
            firstPlayerName.text = player.lastName()
            firstPlayerCP.text = "\(player.creditPoints ?? 0)"
            if player.playerImage != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(player.playerImage ?? "")")
                firstPlayerImage.kf.setImage(with: url1)
                
                if url1 == nil{
                  
                    if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                    }
                    }else{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                        }
                        
                    }
                    
                }
            }else {
                
                if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                    }
                }else{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                    }
                    
                }
                
            }
            
            
        }
        else if index == 1
        {
            secondPlayerName.text = player.lastName()
            secondPlayerCP.text = "\(player.creditPoints ?? 0)"
          
            if player.playerImage != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(player.playerImage ?? "")")
                secondPlayerImage.kf.setImage(with: url1)
                
                if url1 == nil{
                    
                    if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                        }
                    }else{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                        }
                        
                    }
                    
                }

            }else{
                if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                    }
                }else{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                    }
                    
                }
            }
            
        
        }
        else if index == 2
        {
            thirdPlayerName.text = player.lastName()
            thirdPlayerCP.text = "\(player.creditPoints ?? 0)"
          
            if player.playerImage != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(player.playerImage ?? "")")
                thirdPlayerImage.kf.setImage(with: url1)
                
                if url1 == nil{
                    
                    if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                        }
                    }else{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                        }
                        
                    }
                    
                }

            }else{
                
                if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                    }
                }else{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                    }
                    
                }
            }

           
   
        }
        else if index == 3
        {
            fourthPlayerName.text = player.lastName()
            fourthPlayerCP.text = "\(player.creditPoints ?? 0)"
          
            if player.playerImage != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(player.playerImage ?? "")")
                fourthPlayerImage.kf.setImage(with: url1)
                
                if url1 == nil{
                    
                    if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                        }
                    }else{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                        }
                        
                    }
                    
                }

            }else{
                
                if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                    }
                }else{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                    }
                    
                }
            }

            if player.isCaptain {
                
                fourthCap.isHidden = false
                fourthCap.text = "C"
                fourthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
            }else if player.isViceCaptain{
                fourthCap.isHidden = false
                fourthCap.text = "VC"
                fourthCap.backgroundColor = UIColor.init(named: "brand_orange")!
            }
        }
        else if index == 4
        {
            fifthPlayerName.text = player.lastName()
            fifthPlayerCP.text = "\(player.creditPoints ?? 0)"
          
            if player.playerImage != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(player.playerImage ?? "")")
                fifthPlayerImage.kf.setImage(with: url1)
                
                if url1 == nil{
                    
                    if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                        }
                    }else{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                        }
                        
                    }
                    
                }

            }else{
                
                if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                    }
                }else{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                    }
                    
                }
            }
    
            if player.isCaptain {
                
                fifthCap.isHidden = false
                fifthCap.text = "C"
                fifthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
            }else if player.isViceCaptain{
                fifthCap.isHidden = false
                fifthCap.text = "VC"
                fifthCap.backgroundColor = UIColor.init(named: "brand_orange")!
            }
          
        }
        else if index == 5
        {
            sixthPlayerName.text = player.lastName()
            sixthPlayerCP.text = "\(player.creditPoints ?? 0)"
          
            if player.playerImage != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(player.playerImage ?? "")")
                sixthPlayerImage.kf.setImage(with: url1)
                
                if url1 == nil{
                    
                    if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                        }
                    }else{
                        
                        if player.teamBelong == 1{
                            
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                        }else{
                            firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                        }
                        
                    }
                    
                }

            }else{
                
                if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_avatar_team_2.png")
                    }
                }else{
                    
                    if player.teamBelong == 1{
                        
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_1.png")
                    }else{
                        firstPlayerImage.image = UIImage.init(named: "player_football_avatar_team_2.png")
                    }
                    
                }
            }
            
  
            if player.isCaptain {
                
                sixthCap.isHidden = false
                sixthCap.text = "C"
                sixthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
            }else if player.isViceCaptain{
                sixthCap.isHidden = false
                sixthCap.text = "VC"
                sixthCap.backgroundColor = UIColor.init(named: "brand_orange")!
            }
            
        }
        
    }
    
   
//
//    self.viceCaptainButton.isSelected = player.isViceCaptain
//    self.captainButton.isSelected = player.isCaptain
//
//    if(player.isCaptain == true)
//    {
//        offerImage.isHidden = false
//        offerImage.image = UIImage.init(named: "2xPointImage")
//    }
//    else if(player.isViceCaptain)
//    {
//        offerImage.isHidden = false
//        offerImage.image = UIImage.init(named: "1.5xPointImage")
//    }
//    else
//    {
//        offerImage.isHidden = true
//    }
//
//
//    if player.teamBelong == 1
//    {
//        playerDetails.text = " \(squad.firstTeam?.name ?? "") | \(player.creditPoints ?? 0)"
//
//    }
//    else
//    {
//        playerDetails.text = " \(squad.secondTeam?.name ?? "") | \(player.creditPoints ?? 0)"
//    }
//
//    let url1 = URL(string: "\(API_K.BaseUrlStr)\(player.playerImage ?? "")")
//
//    playerImage.kf.setImage(with: url1)
    self.needsUpdateConstraints()
    self.setNeedsLayout()
    
}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
