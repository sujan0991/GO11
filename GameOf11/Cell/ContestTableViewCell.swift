//
//  ContestTableViewCell.swift
//  GameOf11
//
//  Created by Tanvir Palash on 5/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class ContestTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
   
    @IBOutlet weak var trophyImage: UIImageView!
    
    @IBOutlet weak var winingButton: UIButton!
    @IBOutlet weak var entryButton: UIButton!
  
    @IBOutlet weak var contestName: UILabel!
    @IBOutlet weak var contestDetails: UILabel!
    @IBOutlet weak var joinedButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        joinedButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.applySketchShadow(
            color: UIColor.init(named: "ShadowColor")!,
            alpha: 1.0,
            x: 0,
            y: 0,
            blur: 28,
            spread: 0)
    }
    
    
    func setInfo(_ contest:ContestData)  {
        
        contestName.text = contest.name
        contestDetails.text = contest.subtitle
        
        if contest.contestType == "paid"
        {
            trophyImage.image = UIImage.init(named: "paidTrophy")
        }
        else
        {
            trophyImage.image = UIImage.init(named: "freeTrophy")
        }
        
        winingButton.setTitle("\(contest.winningAmount ?? 0)", for: UIControl.State.normal)
        entryButton.setTitle("\(contest.entryAmount ?? 0)", for: UIControl.State.normal)
        
        if (contest.isJoined != 0)
        {
            joinedButton.setTitle("Joined", for: UIControl.State.normal)
            joinedButton.isEnabled = false
        }
        else
        {
            
            joinedButton.setTitle("Join", for: UIControl.State.normal)
            joinedButton.isEnabled = true
        }
       
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
