//
//  MatchTableViewCell.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import Kingfisher

class MatchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstTeamFlag: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    
    @IBOutlet weak var statusBackground: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tournamentName: UILabel!
    @IBOutlet weak var secondTeamFlag: UIImageView!
    @IBOutlet weak var secondTeamName: UILabel!
    
    @IBOutlet weak var contestNumberView: UIView!
    
    @IBOutlet weak var contestLabel: UILabel!
    @IBOutlet weak var seeContestButton: UIButton!
    @IBOutlet weak var contestMessageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var totalJoinedLabel: UILabel!
    
    let formatter = NumberFormatter()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
        
        self.containerView.layer.cornerRadius = 3
        
        totalJoinedLabel.text = "Total Joined Contest".localized
        
        // self.contestNumberView.layer.cornerRadius = 5
        
        self.containerView.layer.applySketchShadow(
            color: UIColor.init(named: "ShadowColor")!,
            alpha: 1.0,
            x: 0,
            y: 2,
            blur: 6,
            spread: 0)
        
        contestNumberView.layer.cornerRadius = 3
    }
    
    func setInfo(_ match:MatchList)  {
        
        
        firstTeamName.text = match.teams.item(at: 0).teamKey?.uppercased() ?? ""
        secondTeamName.text = match.teams.item(at: 1).teamKey?.uppercased() ?? ""
        tournamentName.text = String.init(format: "%@ %@",match.tournamentName ?? "",match.format! )
        //        statusLabel.text = String.init(format: "JOIN ENDS:\n %@",match.joiningLastTime ?? "" )
        
        contestMessageHeightConstraint.constant = 0
        
        if Language.language == Language.english{
            
            contestLabel.text = String.init(format: "%d", match.totalJoinedContests ?? 0)
            
        }else{
            
            contestLabel.text = String.init(format: "%@",formatter.string(from: NSNumber(value: match.totalJoinedContests!))!)
        }
        
        
        //  let urlStr = "\(API_K.BaseUrlStr)public/images/blog/\(blog.image ?? "")"
        
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
        
        //        firstTeamFlag?.kf.setImage(with: url1, placeholder: UIImage.init(named: "BDFlag"), options: nil, progressBlock: nil, completionHandler: nil)
        //
        //        secondTeamFlag?.kf.setImage(with: url2, placeholder: UIImage.init(named: "IndiaFlag"), options: nil, progressBlock: nil, completionHandler: nil)
        //
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        //  statusBackground.roundCorners([.bottomLeft,.bottomRight], radius: 5)
        
    }
    
    func setFootballInfo(_ match:FootBallMatchList)  {
        
        
        firstTeamName.text = match.teams.item(at: 0).code?.uppercased() ?? ""
        secondTeamName.text = match.teams.item(at: 1).code?.uppercased() ?? ""
        tournamentName.text = String.init(format: "%@",match.tournamentName ?? "" )
        //        statusLabel.text = String.init(format: "JOIN ENDS:\n %@",match.joiningLastTime ?? "" )
        
        contestMessageHeightConstraint.constant = 0
        
        if Language.language == Language.english{
            
            contestLabel.text = String.init(format: "%d", match.totalJoinedContests ?? 0)
            
        }else{
            
            contestLabel.text = String.init(format: "%@",formatter.string(from: NSNumber(value: match.totalJoinedContests!))!)
        }
        
        
        //  let urlStr = "\(API_K.BaseUrlStr)public/images/blog/\(blog.image ?? "")"
        
        if match.teams.item(at: 0).logo != nil{
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(match.teams.item(at: 0).logo ?? "")")
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
        
        //        firstTeamFlag?.kf.setImage(with: url1, placeholder: UIImage.init(named: "BDFlag"), options: nil, progressBlock: nil, completionHandler: nil)
        //
        //        secondTeamFlag?.kf.setImage(with: url2, placeholder: UIImage.init(named: "IndiaFlag"), options: nil, progressBlock: nil, completionHandler: nil)
        //
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        //  statusBackground.roundCorners([.bottomLeft,.bottomRight], radius: 5)
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
