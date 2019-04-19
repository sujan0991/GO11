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
    @IBOutlet weak var viceCaptainName: UILabel!
    @IBOutlet weak var captainName: UILabel!
    @IBOutlet weak var keeperCountLabel: UILabel!
    @IBOutlet weak var batsmanCountLabel: UILabel!
    @IBOutlet weak var allrounderCountLabel: UILabel!
    @IBOutlet weak var bowlerCountLabel: UILabel!

    @IBOutlet weak var selectView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    
    @IBOutlet weak var selectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        self.containerView.layer.cornerRadius = 5
        previewButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        editButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        confirmButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        self.containerView.layer.applySketchShadow(
            color: UIColor.init(named: "ShadowColor")!,
            alpha: 1.0,
            x: 0,
            y: 0,
            blur: 28,
            spread: 0)
    }
    
    func setInfo(_ team:CreatedTeam)  {
        
        self.teamName.text = team.teamName
        self.captainName.text = team.captainName
        self.viceCaptainName.text = team.viceCaptainName
        
        self.keeperCountLabel.text = String.init(format: "%d", team.keeperCount ?? 0)
        self.allrounderCountLabel.text = String.init(format: "%d", team.allrounderCount ?? 0)
        self.batsmanCountLabel.text = String.init(format: "%d", team.batsmanCount ?? 0)
        self.bowlerCountLabel.text = String.init(format: "%d", team.bowlerCount ?? 0)
        
        
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
