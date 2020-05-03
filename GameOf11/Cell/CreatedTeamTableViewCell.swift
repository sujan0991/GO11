//
//  CreatedTeamTableViewCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 28/7/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class CreatedTeamTableViewCell: UITableViewCell {

    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var captainNameLabel: UILabel!
    
    @IBOutlet weak var captainLabel: UILabel!
    
    @IBOutlet weak var viceCaptainNameLabel: UILabel!
    
    @IBOutlet weak var viceCaptainLabel: UILabel!
    @IBOutlet weak var keeperCountLabel: UILabel!
    @IBOutlet weak var batCountLabel: UILabel!
    @IBOutlet weak var arCountLabel: UILabel!
    @IBOutlet weak var bowlCountLabel: UILabel!
    @IBOutlet weak var selectTeamButton: UIButton!
    
    @IBOutlet weak var chooseTeamLabel: UILabel!
    
    @IBOutlet weak var keeperLabel: UILabel!
    @IBOutlet weak var batsmanLabel: UILabel!
    @IBOutlet weak var allrounderLabel: UILabel!
    @IBOutlet weak var bowlerLabel: UILabel!
    
    
    let formatter = NumberFormatter()
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        captainLabel.text = "CAPTAIN".localized
        viceCaptainLabel.text = "VICE-CAPTAIN".localized
        chooseTeamLabel.text = "CHOOSE TEAM".localized
        
    }

    func setInfo(_ team:CreatedTeam)  {
        
        print("team......CteatedTableViewCell",team.userTeamId!)
        
        self.teamNameLabel.text = team.teamName
        self.captainNameLabel.text = team.captainName
        self.viceCaptainNameLabel.text = team.viceCaptainName
        
        if Language.language == Language.english{
            
            self.keeperCountLabel.text = String.init(format: "%d", team.keeperCount ?? 0)
            self.arCountLabel.text = String.init(format: "%d", team.allrounderCount ?? 0)
            self.batCountLabel.text = String.init(format: "%d", team.batsmanCount ?? 0)
            self.bowlCountLabel.text = String.init(format: "%d", team.bowlerCount ?? 0)
        }else{
            
            
            self.keeperCountLabel.text = String.init(format: "%@",formatter.string(from: team.keeperCount! as NSNumber)!)
            self.arCountLabel.text = String.init(format: "%@", formatter.string(from: team.allrounderCount! as NSNumber)!)
            self.batCountLabel.text = String.init(format: "%@", formatter.string(from: team.batsmanCount! as NSNumber)!)
            self.bowlCountLabel.text = String.init(format: "%@", formatter.string(from: team.bowlerCount! as NSNumber)!)
 
        }
        
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
    }
    
    func setInfoFootball(_ team:CreatedTeamFootball)  {
        
        print("team......CteatedTableViewCell",team.userTeamId!)
        
        self.teamNameLabel.text = team.teamName
        self.captainNameLabel.text = team.captainName
        self.viceCaptainNameLabel.text = team.viceCaptainName
        
        if Language.language == Language.english{
            
            self.keeperCountLabel.text = String.init(format: "%d", team.keeperCount ?? 0)
            self.arCountLabel.text = String.init(format: "%d", team.midfielderCount ?? 0)
            self.batCountLabel.text = String.init(format: "%d", team.defenderCount ?? 0)
            self.bowlCountLabel.text = String.init(format: "%d", team.strikerCount ?? 0)
        }else{
            
            
            self.keeperCountLabel.text = String.init(format: "%@",formatter.string(from: team.keeperCount! as NSNumber)!)
            self.arCountLabel.text = String.init(format: "%@", formatter.string(from: team.midfielderCount! as NSNumber)!)
            self.batCountLabel.text = String.init(format: "%@", formatter.string(from: team.defenderCount! as NSNumber)!)
            self.bowlCountLabel.text = String.init(format: "%@", formatter.string(from: team.strikerCount! as NSNumber)!)
            
        }
        
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
