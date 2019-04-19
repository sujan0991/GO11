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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
        self.containerView.layer.cornerRadius = 5
        
        self.contestNumberView.layer.cornerRadius = 5
        
        self.containerView.layer.applySketchShadow(
            color: UIColor.init(named: "ShadowColor")!,
            alpha: 1.0,
            x: 0,
            y: 0,
            blur: 28,
            spread: 0)
    }
    func setInfo(_ match:MatchList)  {
        
        firstTeamName.text = match.teams.item(at: 0).teamKey ?? ""
        secondTeamName.text = match.teams.item(at: 1).teamKey ?? ""
        tournamentName.text = match.tournamentName ?? ""
        statusLabel.text = String.init(format: "Ends: %@",match.joiningLastTime ?? "" )
        
        contestMessageHeightConstraint.constant = 0
        contestLabel.text = String.init(format: "Contest Joined : %d", match.totalJoinedContests ?? 0)
        
      //  let urlStr = "\(API_K.BaseUrlStr)public/images/blog/\(blog.image ?? "")"
        
        let url1 = URL(string: "\(API_K.BaseUrlStr)\(match.teams.item(at: 0).logo ?? "")")
        let url2 = URL(string: "\(API_K.BaseUrlStr)\(match.teams.item(at: 1).logo ?? "")")
        firstTeamFlag.kf.setImage(with: url1)
        secondTeamFlag.kf.setImage(with: url2)

        //        firstTeamFlag?.kf.setImage(with: url1, placeholder: UIImage.init(named: "BDFlag"), options: nil, progressBlock: nil, completionHandler: nil)
//
//        secondTeamFlag?.kf.setImage(with: url2, placeholder: UIImage.init(named: "IndiaFlag"), options: nil, progressBlock: nil, completionHandler: nil)
//
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        statusBackground.roundCorners([.bottomLeft,.bottomRight], radius: 5)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
