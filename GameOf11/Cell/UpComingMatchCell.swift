//
//  UpComingMatchCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 18/8/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class UpComingMatchCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var firstTeamFlag: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    
    @IBOutlet weak var secondTeamFlag: UIImageView!
    @IBOutlet weak var secondTeamName: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tournamentName: UILabel!

    @IBOutlet weak var tournamentTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.containerView.layer.cornerRadius = 3
        
        self.containerView.layer.applySketchShadow(
            color: UIColor.init(named: "ShadowColor")!,
            alpha: 1.0,
            x: 0,
            y: 2,
            blur: 6,
            spread: 0)

    }

    func setInfo(_ match:MatchList)  {
        
        
        firstTeamName.text = match.teams.item(at: 0).teamKey ?? ""
        secondTeamName.text = match.teams.item(at: 1).teamKey ?? ""
        tournamentName.text = String.init(format: "%@",match.tournamentName ?? "")
        tournamentTypeLabel.text = String.init(format: "%@",match.format!.uppercased() )
        
        print("match.teams.item(at: 0).logo",match.teams.item(at: 0).logo)
        
        if match.teams.item(at: 0).logo != nil{
            
           let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(match.teams.item(at: 0).logo ?? "")")
           firstTeamFlag.kf.setImage(with: url1)
            
        }else{
   
           self.firstTeamFlag.image = UIImage.init(named: "teamPlaceHolder_icon")
                
            
        }
        
        if match.teams.item(at: 1).logo != nil{
            
            let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(match.teams.item(at: 1).logo ?? "")")
            
            secondTeamFlag.kf.setImage(with: url2)
        }else{
            
  
            self.secondTeamFlag.image = UIImage.init(named: "teamPlaceHolder_icon")
                
          
        }
        
        

        self.needsUpdateConstraints()
        self.setNeedsLayout()
       
    }
    
    func setFootballInfo(_ match:FootBallMatchList)  {
        
        
        firstTeamName.text = match.teams.item(at: 0).code ?? ""
        secondTeamName.text = match.teams.item(at: 1).code ?? ""
        tournamentName.text = String.init(format: "%@",match.tournamentName ?? "")
        tournamentTypeLabel.isHidden = true
      //  tournamentTypeLabel.text = String.init(format: "%@",match.format!.uppercased() )
        
        print("match.teams.item(at: 0).logo",match.teams.item(at: 0).logo)
        
        if match.teams.item(at: 0).logo != nil{
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(match.teams.item(at: 0).logo ?? "")")
            print("logo..................................",url1)
            firstTeamFlag.kf.setImage(with: url1)
        }else{
            self.firstTeamFlag.image = UIImage.init(named: "placeholder_football_team_logo")
            
        }
        
        if match.teams.item(at: 1).logo != nil{
            
            let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(match.teams.item(at: 1).logo ?? "")")
            
            secondTeamFlag.kf.setImage(with: url2)
        }else{
            self.secondTeamFlag.image = UIImage.init(named: "placeholder_football_team_logo")
            
        }
        
        
        
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
