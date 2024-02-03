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
    
    @IBOutlet weak var bottomView: UIView!
    
   
    @IBOutlet weak var trophyImage: UIImageView!
    
    @IBOutlet weak var totalPrizeLabel: UILabel!
    @IBOutlet weak var winingLabel: UILabel!
    @IBOutlet weak var entryAmountLabel: UILabel!
  
    @IBOutlet weak var contestName: UILabel!
    @IBOutlet weak var contestDetails: UILabel!
    @IBOutlet weak var joinedButton: UIButton!
    @IBOutlet weak var joinedShadowButton: UIButton!
    
    
    @IBOutlet weak var progressContainerView: UIView!
    
    @IBOutlet weak var progressContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var joinedTeamLabel: UILabel!
    
    @IBOutlet weak var spotLeftLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var progressView: GradientProgressBar!
    
    @IBOutlet weak var totalWinnerButton: UIButton!
    
    @IBOutlet weak var tkIcon: UIImageView!
    
    @IBOutlet weak var entryCoinIcon: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//         bottomView.roundCorners([.bottomLeft,.bottomRight], radius: 5)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        joinedButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        totalPrizeLabel.text = "Total Prize".localized
        
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.applySketchShadow(
            color: UIColor.init(named: "ShadowColor")!,
            alpha: 1.0,
            x: 0,
            y: 2,
            blur: 6,
            spread: 0)
        
        bottomView.layer.cornerRadius = 5
       
    }
    
    
    func setInfo(_ contest:ContestData)  {
        
        contestName.text = contest.name?.uppercased()
        contestDetails.text = contest.subtitle
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        
        if contest.contestType == "paid"
        {
            trophyImage.image = UIImage.init(named: "paidTrophy")
            tkIcon.image = UIImage.init(named: "tk_icon")
        }
        else
        {
            trophyImage.image = UIImage.init(named: "freeTrophy")
            tkIcon.image = UIImage.init(named: "coinIcon")
        }
        
        if Language.language == Language.english{
            winingLabel.text = String(describing: contest.winningAmount ?? 0)
        }else{
            let bnNumberString = formatter.string(for: contest.winningAmount ?? 0 )
            winingLabel.text = String(describing: bnNumberString!)
        }
        if contest.contestType == "free"{
            
             entryAmountLabel.text = "Entry Free".localized
             entryAmountLabel.textColor = UIColor.lightGray
             entryCoinIcon.isHidden = true
        }else{
            
            let bnNumberString = formatter.string(for: contest.entryAmount ?? 0 )
            if Language.language == Language.english{
            entryAmountLabel.text = String.init(format:"Entry %d".localized,contest.entryAmount ?? 0)
            }else{
               
                entryAmountLabel.text = String.init(format:"Entry %@".localized,bnNumberString!)
            }
            
         //   entryAmountLabel.textColor = UIColor.init(named: "GreenHighlight")!
            entryCoinIcon.isHidden = false
        }
       
        let numSt = String(contest.prizes.count)
        let bnNumberString = formatter.string(for: contest.prizes.count )
        
        if Language.language == Language.english{
            
            totalWinnerButton.setTitle(String.init(format:"Total %@ Winners".localized,numSt), for: UIControl.State.normal)
        }else{
            totalWinnerButton.setTitle(String.init(format:"Total %@ Winners".localized,bnNumberString!), for: UIControl.State.normal)
        }
        
        
        
        progressView.gradientColors = [UIColor.init(named: "brand_orange")!.cgColor, UIColor.init(named: "brand_orange")!.cgColor]
        
        if contest.is_league == 1{
            
            progressContainerView.isHidden = false
            progressContainerHeight.constant = 40
            let joined = contest.total_user_joined!
            let total = contest.teamsCapacity!
            let left = total - joined
            let bnNumberString = formatter.string(for: joined)
            let bnNumberString2 = formatter.string(for: left)
            
            if Language.language == Language.english{
                
                joinedTeamLabel.text = String.init(format:"%@ Team Joined",String(joined))
                spotLeftLabel.text = String.init(format:"%@ Spots Left",String(left))
                
            }else{
                joinedTeamLabel.text = String.init(format:"%@ Team Joined".localized,String(bnNumberString!))
                spotLeftLabel.text = String.init(format:"%@ Spots Left".localized,String(bnNumberString2!))

            }

            
            let progress:Float = Float(joined) / Float(total)
            
            progressView.progress = progress
        }else{
            
            progressContainerView.isHidden = true
            progressContainerHeight.constant = 0
        }
        
       
        self.needsUpdateConstraints()
        self.setNeedsLayout()
        

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

