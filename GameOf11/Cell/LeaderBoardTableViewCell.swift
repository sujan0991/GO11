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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setInfo(_ leaderBoard:LeaderBoardUserListData)  {
        
        self.userNameLabel.text = leaderBoard.username
        self.teamNameLabel.text = leaderBoard.team_name
        self.pointLabel.text = "\(leaderBoard.team_earning_point ?? 0.0)"
        self.rankLabel.text = "\(leaderBoard.rank ?? 0)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
