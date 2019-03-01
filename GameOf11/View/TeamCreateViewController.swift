//
//  TeamCreateViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class TeamCreateViewController: BaseViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource {
    
    var squadData:MatchSquadData!
    var batsmanList:[Player] = []
    var bowlerList:[Player] = []
    var keeperList:[Player] = []
    var allRounderList:[Player] = []
    
    var firstTeamPlayerCount = 0
    var secondTeamPlayerCount = 0
    var totalCreditPoint = 0.0
    
    var selectedIndex = 0
    
    var selectedBatsmanList:[Player] = []
    var selectedBowlerList:[Player] = []
    var selectedKeeperList:[Player] = []
    var selectedAllRounderList:[Player] = []
    
    var userTeam : UsersFantasyTeam!
    
    
    @IBOutlet weak var positionSelectorCollectionView: UICollectionView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    @IBOutlet weak var firstTeamCount: UIButton!
    @IBOutlet weak var firstTeamCode: UILabel!
    
    @IBOutlet weak var secondTeamCount: UIButton!
    @IBOutlet weak var secondTeamCode: UILabel!
    
    @IBOutlet weak var totalPlayersCountLabel: UILabel!
    
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var playerListView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeNavBar(withTitle: "Create Your Team", isBackBtnVisible: true)
        
        if squadData != nil
        {
            for player in squadData.playersList
            {
                self.updateSummary()
                
                switch (player.role) {
                case "batsman":
                    batsmanList.append(player)
                    break;
                case "bowler":
                    bowlerList.append(player)
                    break;
                case "keeper":
                    keeperList.append(player)
                    break;
                case "allrounder":
                    allRounderList.append(player)
                    break;
                    
                default:
                    break;
                }
                
            }
        }
        
        positionSelectorCollectionView?.delegate = self
        positionSelectorCollectionView?.dataSource = self
        
        playerListView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "playerCell")
        
        playerListView.delegate = self
        playerListView.dataSource = self
        playerListView.removeEmptyCells()
        
        nextButton.makeRound(5, borderWidth: 0, borderColor: .clear)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        positionSelectorCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)

    }
    
    func updateSummary()
    {
        firstTeamCode.text = squadData.teams?.firstTeam?.teamKey
        secondTeamCode.text = squadData.teams?.secondTeam?.teamKey
        firstTeamCount.setTitle("\(firstTeamPlayerCount)", for: .normal)
        secondTeamCount.setTitle("\(secondTeamPlayerCount)", for: .normal)
        
        totalPlayersCountLabel.text = "\(firstTeamPlayerCount + secondTeamPlayerCount)/11"
        totalPointsLabel.text = "\(totalCreditPoint)/100"
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
    }
    
    @IBAction func previewAction(_ sender: Any) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:PositionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "positionCell", for: indexPath) as! PositionCollectionViewCell
        
        if indexPath.item == 0
        {
            cell.positionTitle.text = "WK"
            cell.positionIcon.image = UIImage.init(named: "wicketKeeperIcon")
            cell.playerCount.backgroundColor = UIColor.init(named: "TabOrangeColor")
            cell.playerCount.text = "0"
            
            cell.isSelected = true
           
        }
        else if indexPath.item == 1
        {
            cell.positionTitle.text = "BAT"
            cell.positionIcon.image = UIImage.init(named: "battingIcon")
            cell.playerCount.backgroundColor = UIColor.init(named: "TabOrangeColor")
            cell.playerCount.text = "0"
        }
        else if indexPath.item == 2
        {
            cell.positionTitle.text = "ALL"
            cell.positionIcon.image = UIImage.init(named: "allrounderIcon")
            cell.playerCount.backgroundColor = UIColor.init(named: "TabOrangeColor")
            cell.playerCount.text = "0"
        }
        else
        {
            cell.positionTitle.text = "BOWL"
            cell.positionIcon.image = UIImage.init(named: "bowlingIcon")
            cell.playerCount.backgroundColor = UIColor.init(named: "TabOrangeColor")
            cell.playerCount.text = "0"
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        print("insetForSectionAt")
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = collectionView.frame.size.height //some width
        
        let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: section))
        
        let combinedItemWidth = (numberOfItems * width) + ((numberOfItems - 1)  * flowLayout.minimumInteritemSpacing)
        let padding = (collectionView.frame.width - combinedItemWidth) / 2
        
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        _ = (collectionView.frame.size.width - 3 * 10) / 4
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.item
        
        if indexPath.item == 0
        {
            suggestionLabel.text = "PICK 1 WICKET-KEEPER"
        }
        else if indexPath.item == 1
        {
            suggestionLabel.text = "PICK 3-5 BATSMAN"
            
        }
        else if indexPath.item == 2
        {
            
            suggestionLabel.text = "PICK 1-3 ALL-ROUNDERS"
        }
        else
        {
            
            suggestionLabel.text = "PICK 3-5 BOWLERS"
        }
        
        playerListView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if selectedIndex == 0
        {
            return keeperList.count
        }
        else if selectedIndex == 1
        {
            return batsmanList.count
        }
        else if selectedIndex == 2
        {
            return allRounderList.count
        }
        else
        {
            return bowlerList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"playerCell") as! PlayerTableViewCell
        
        var player: Player!
       
        if selectedIndex == 0
        {
             player = keeperList[indexPath.section]
        }
        else if selectedIndex == 1
        {
             player = batsmanList[indexPath.section]
        }
        else if selectedIndex == 2
        {
             player = allRounderList[indexPath.section]
        }
        else
        {
             player = bowlerList[indexPath.section]
        }
        
        cell.setInfo(player: player,squad: squadData.teams!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        let currentCell = tableView.cellForRow(at: indexPath) as! PlayerTableViewCell

        var player: Player!
        //var fantasyPlayer: UserFantasyPlayer!
        
        
        if selectedIndex == 0
        {
            player = keeperList[indexPath.section]
           // fantasyPlayer?.player = player
            player.playerSelected = !player.playerSelected
            keeperList[indexPath.section] = player
            
            if player.playerSelected
            {
               // userTeam.keeper.append(fantasyPlayer!)
            }
            else
            {
             //   userTeam.keeper = userTeam.keeper.filter{$0 != fantasyPlayer}
            }
            
        }
        else if selectedIndex == 1
        {
            player = batsmanList[indexPath.section]
           // fantasyPlayer.player = player
            
            player.playerSelected = !player.playerSelected
            batsmanList[indexPath.section] = player
        }
        else if selectedIndex == 2
        {
            player = allRounderList[indexPath.section]
          //  fantasyPlayer.player = player
            
            player.playerSelected = !player.playerSelected
            allRounderList[indexPath.section] = player
        }
        else
        {
            player = bowlerList[indexPath.section]
        //    fantasyPlayer.player = player
            
            player.playerSelected = !player.playerSelected
            bowlerList[indexPath.section] = player
        }
        var multiplyer = 1.0
        
        if !player.playerSelected
        {
            multiplyer = -1.0
        }
        
        totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
        
        if player.teamBelong == 1
        {
            firstTeamPlayerCount = firstTeamPlayerCount + Int(1 * multiplyer)
        }
        else
        {
            secondTeamPlayerCount = secondTeamPlayerCount + Int(1 * multiplyer)
        }
      
        self.updateSummary()
        tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
