//
//  PreviewTableViewCell.swift
//  GameOf11
//
//  Created by Tanvir Palash on 24/4/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class PreviewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var firstPlayer: UIView!
    @IBOutlet weak var secondPlayer: UIView!
    @IBOutlet weak var thirdPlayer: UIView!
    
    @IBOutlet weak var fourthPlayer: UIView!
    @IBOutlet weak var fifthPlayer: UIView!
    
    @IBOutlet weak var firstPlayerImage: UIImageView!
    @IBOutlet weak var secondPlayerImage: UIImageView!
    @IBOutlet weak var thirdPlayerImage: UIImageView!
    @IBOutlet weak var fourthPlayerImage: UIImageView!
    @IBOutlet weak var fifthPlayerImage: UIImageView!
    
    @IBOutlet weak var firstPlayerName: UILabel!
    @IBOutlet weak var secondPlayerName: UILabel!
    @IBOutlet weak var thirdPlayerName: UILabel!
    @IBOutlet weak var fourthPlayerName: UILabel!
    @IBOutlet weak var fifthPlayerName: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        secondPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        thirdPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        fourthPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)
        fifthPlayerImage.makeCircular(borderWidth: 0, borderColor: .clear)

    }



func setInfo( players:[Player] ,  squad : PlayingTeamsData)  {
    
    print(players.count)
    //[self.stackView.arrangedSubviews[_expandedViewIndex] setHidden: YES];
    // print(player.toJSON())
    
    firstPlayer.isHidden = true
    secondPlayer.isHidden = true
    thirdPlayer.isHidden = true
    fourthPlayer.isHidden = true
    fifthPlayer.isHidden = true
    
    var player: Player!
    
    for index in 0..<players.count
    {
        let firstView = stackView.arrangedSubviews[index]
        firstView.isHidden = false
        
        player = players.item(at: index)
        
        if index == 0
        {
            firstPlayerName.text = player.lastName()
        }
        else if index == 1
        {
            secondPlayerName.text = player.name
        }
        else if index == 2
        {
            thirdPlayerName.text = player.name
        }
        else if index == 3
        {
            fourthPlayerName.text = player.name
        }
        else if index == 4
        {
            fifthPlayerName.text = player.name
        }
        
    }
    
   
//
//    self.viceCaptainButton.isSelected = player.isViceCaptain
//    self.captainButton.isSelected = player.isCaptain
//
//    if(player.isCaptain == true)
//    {
//        offerImage.isHidden = false
//        offerImage.image = UIImage.init(named: "2xPointImage")
//    }
//    else if(player.isViceCaptain)
//    {
//        offerImage.isHidden = false
//        offerImage.image = UIImage.init(named: "1.5xPointImage")
//    }
//    else
//    {
//        offerImage.isHidden = true
//    }
//
//
//    if player.teamBelong == 1
//    {
//        playerDetails.text = " \(squad.firstTeam?.name ?? "") | \(player.creditPoints ?? 0)"
//
//    }
//    else
//    {
//        playerDetails.text = " \(squad.secondTeam?.name ?? "") | \(player.creditPoints ?? 0)"
//    }
//
//    let url1 = URL(string: "\(API_K.BaseUrlStr)\(player.playerImage ?? "")")
//
//    playerImage.kf.setImage(with: url1)
    self.needsUpdateConstraints()
    self.setNeedsLayout()
    
}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
