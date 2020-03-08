//
//  CteatedTableViewCell.swift
//  GameOf11
//
//  Created by Tanvir Palash on 17/4/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class CteatedTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var vCaptainImageView: UIImageView!
    
    @IBOutlet weak var captainimageView: UIImageView!
    @IBOutlet weak var viceCaptainName: UILabel!
    @IBOutlet weak var captainName: UILabel!
    @IBOutlet weak var keeperCountLabel: UILabel!
    @IBOutlet weak var batsmanCountLabel: UILabel!
    @IBOutlet weak var allrounderCountLabel: UILabel!
    @IBOutlet weak var bowlerCountLabel: UILabel!
    
    @IBOutlet weak var keeperLabel: UILabel!
    @IBOutlet weak var batsmanLabel: UILabel!
    @IBOutlet weak var allrounderLabel: UILabel!
    @IBOutlet weak var bowlerLabel: UILabel!
    

    @IBOutlet weak var selectView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    
    @IBOutlet weak var selectButton: UIButton!
    
    let formatter = NumberFormatter()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        self.containerView.layer.cornerRadius = 5
        previewButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        editButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        confirmButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        self.containerView.layer.applySketchShadow(
            color: UIColor.lightGray,
            alpha: 1.0,
            x: 0,
            y: 2,
            blur: 4,
            spread: 0)

    }
    
    func setInfo(_ team:CreatedTeam)  {
        
        print("team......CteatedTableViewCell",team.userTeamId!)
        
        self.teamName.text = team.teamName?.uppercased()
        self.captainName.text = team.captainName
        self.viceCaptainName.text = team.viceCaptainName
        
        if Language.language == Language.english{
            
            self.keeperCountLabel.text = String.init(format: "%d", team.keeperCount ?? 0)
            self.allrounderCountLabel.text = String.init(format: "%d", team.allrounderCount ?? 0)
            self.batsmanCountLabel.text = String.init(format: "%d", team.batsmanCount ?? 0)
            self.bowlerCountLabel.text = String.init(format: "%d", team.bowlerCount ?? 0)
            
        }else{
            
            self.keeperCountLabel.text = String.init(format: "%@", formatter.string(from: NSNumber(value: team.keeperCount!))!)
            self.allrounderCountLabel.text = String.init(format: "%@", formatter.string(from: NSNumber(value: team.allrounderCount!))!)
            self.batsmanCountLabel.text = String.init(format: "%@", formatter.string(from: NSNumber(value: team.batsmanCount!))!)
            self.bowlerCountLabel.text = String.init(format: "%@", formatter.string(from: NSNumber(value: team.bowlerCount!))!)
            
        }
       
        
        
        if team.captain_image != nil{
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(team.captain_image ?? "")")
            
            self.captainimageView.kf.setImage(with: url1)
            if url1 == nil{
                captainimageView.image = UIImage.init(named: "player_avatar_global.png")
            }
        }else{
            
             captainimageView.image = UIImage.init(named: "player_avatar_global.png")
        }
        
        if team.vice_captain_image != nil{
            let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(team.vice_captain_image ?? "")")
            
            self.vCaptainImageView.kf.setImage(with: url2)
            if url2 == nil{
                vCaptainImageView.image = UIImage.init(named: "player_avatar_global.png")
            }
        }else{
            
            vCaptainImageView.image = UIImage.init(named: "player_avatar_global.png")
        }
  

        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
    }
    
    
    func setInfoFootball(_ team:CreatedTeamFootball)  {
        
        print("team......CteatedTableViewCell",team.userTeamId!)
        
        self.teamName.text = team.teamName?.uppercased()
        self.captainName.text = team.captainName
        self.viceCaptainName.text = team.viceCaptainName
        
        if Language.language == Language.english{
            
            self.keeperCountLabel.text = String.init(format: "%d", team.keeperCount ?? 0)
            self.allrounderCountLabel.text = String.init(format: "%d", team.midfielderCount ?? 0)
            self.batsmanCountLabel.text = String.init(format: "%d", team.defenderCount ?? 0)
            self.bowlerCountLabel.text = String.init(format: "%d", team.strikerCount ?? 0)
            
        }else{
            
            self.keeperCountLabel.text = String.init(format: "%@", formatter.string(from: NSNumber(value: team.keeperCount!))!)
            self.allrounderCountLabel.text = String.init(format: "%@", formatter.string(from: NSNumber(value: team.midfielderCount!))!)
            self.batsmanCountLabel.text = String.init(format: "%@", formatter.string(from: NSNumber(value: team.defenderCount!))!)
            self.bowlerCountLabel.text = String.init(format: "%@", formatter.string(from: NSNumber(value: team.strikerCount!))!)
            
        }
        
        
        
        if team.captain_image != nil{
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(team.captain_image ?? "")")
            
            self.captainimageView.kf.setImage(with: url1)
            if url1 == nil{
                if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                captainimageView.image = UIImage.init(named: "player_avatar_global.png")
                }else{
                    captainimageView.image = UIImage.init(named: "player_football_avatar_global.png")
                }
            }
        }else{
            
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                captainimageView.image = UIImage.init(named: "player_avatar_global.png")
            }else{
                captainimageView.image = UIImage.init(named: "player_football_avatar_global.png")
            }
        }
        
        if team.vice_captain_image != nil{
            let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(team.vice_captain_image ?? "")")
            
            self.vCaptainImageView.kf.setImage(with: url2)
            if url2 == nil{
                if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                    vCaptainImageView.image = UIImage.init(named: "player_avatar_global.png")
                }else{
                    vCaptainImageView.image = UIImage.init(named: "player_football_avatar_global.png")
                }
                
            }
        }else{
            
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                vCaptainImageView.image = UIImage.init(named: "player_avatar_global.png")
            }else{
                vCaptainImageView.image = UIImage.init(named: "player_football_avatar_global.png")
            }

        }
        
        
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
  
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        
        
    }
    
}
