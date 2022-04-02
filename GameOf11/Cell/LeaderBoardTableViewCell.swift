//
//  LeaderBoardTableViewCell.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 13/3/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class LeaderBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var pointLabel: UILabel!
    
    let formatter = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImageView.layer.cornerRadius = 20
        userImageView.clipsToBounds = true
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
    }
    
    func setInfo(_ leaderBoard:LeaderBoardUserListData)  {
        
        let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(leaderBoard.avatar ?? "")")
        
        self.userImageView.kf.setImage(with: url2)
        
        if Language.language == Language.english{
        self.userNameLabel.text = String.init(format: "%d",leaderBoard.rank ?? 0)
        self.teamNameLabel.text = leaderBoard.username
        self.pointLabel.text = "\(leaderBoard.team_earning_point ?? 0.0)"
     //   self.rankLabel.text = "\(leaderBoard.rank ?? 0)"
        }else{
            
            self.userNameLabel.text = String.init(format: "%@",formatter.string(from: leaderBoard.rank! as NSNumber) ?? 0)
            self.teamNameLabel.text = leaderBoard.username
            self.pointLabel.text = formatter.string(from: leaderBoard.team_earning_point! as NSNumber) ?? "০.০"
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
