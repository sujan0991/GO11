//
//  TeamCreateViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

struct Team_Rules {
    
    static let MaxPlayer = 11
    static let Team1MaxPlayer = 7
    static let Team2MaxPlayer = 7
    static let MaxCredit = 100
}


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
    var isGreen = false
    
    var userTeam : UsersFantasyTeam!
    
    
    @IBOutlet weak var positionSelectorCollectionView: UICollectionView!
    @IBOutlet weak var playerListView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    @IBOutlet weak var firstTeamCount: UIButton!
    @IBOutlet weak var firstTeamCode: UILabel!
    
    @IBOutlet weak var secondTeamCount: UIButton!
    @IBOutlet weak var secondTeamCode: UILabel!
    
    @IBOutlet weak var totalPlayersCountLabel: UILabel!
    
    @IBOutlet weak var suggestionLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeNavBar(withTitle: "Create Your Team", isBackBtnVisible: true)
        
        let teamJson = [
            "match_id" : "0",
            "team_name": ""
            ] as [String : Any]
        
        userTeam = UsersFantasyTeam(json: teamJson)
        
        if squadData != nil
        {
            userTeam.matchId = squadData.matchId
            
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
    
   
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CaptainSelectorViewController") as? CaptainSelectorViewController
        
        popupVC?.modalPresentationStyle = .overCurrentContext
        popupVC?.modalTransitionStyle = .crossDissolve
        popupVC?.userTeam = userTeam
        popupVC?.squadData = squadData
        
        self.navigationController?.pushViewController(popupVC ?? self, animated: true)
        
//        self.present(popupVC!, animated: true) {
//            print("")
//        }
        
    }
    
    @IBAction func previewAction(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamPreviewViewController") as? TeamPreviewViewController
        
        popupVC?.modalPresentationStyle = .overCurrentContext
        popupVC?.modalTransitionStyle = .crossDissolve
        
        self.navigationController?.pushViewController(popupVC ?? self, animated: true)
        
        //        self.present(popupVC!, animated: true) {
        //            print("")
        //        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:PositionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "positionCell", for: indexPath) as! PositionCollectionViewCell
        
        
        cell.playerCount.text = String.init(format: "0")
        
        if indexPath.item == 0
        {
            cell.positionTitle.text = "WK"
            cell.positionIcon.image = UIImage.init(named: "wicketKeeperIcon")
            if userTeam != nil
            {
                cell.playerCount.text = String.init(format: "%d", userTeam.keeper.count)
            }
            cell.isSelected = true
           
        }
        else if indexPath.item == 1
        {
            cell.positionTitle.text = "BAT"
            cell.positionIcon.image = UIImage.init(named: "battingIcon")
            
            if userTeam != nil
            {
                cell.playerCount.text = String.init(format: "%d", userTeam.batsman.count)
            }
            
        }
        else if indexPath.item == 2
        {
            cell.positionTitle.text = "ALL"
            cell.positionIcon.image = UIImage.init(named: "allrounderIcon")
            if userTeam != nil
            {
                cell.playerCount.text = String.init(format: "%d", userTeam.allrounder.count)
            }
        }
        else
        {
            cell.positionTitle.text = "BOWL"
            cell.positionIcon.image = UIImage.init(named: "bowlingIcon")
            
            if userTeam != nil
            {
                cell.playerCount.text = String.init(format: "%d", userTeam.bowler.count)
            }
        }
        cell.isSelected = selectedIndex == indexPath.item
        
        if isGreen {
            cell.playerCount.backgroundColor = UIColor.init(named: "GreenHighlight")
            
        }
        else
        {
            cell.playerCount.backgroundColor = UIColor.init(named: "TabOrangeColor")
            
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
       // print("insetForSectionAt")
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
        
        positionSelectorCollectionView.reloadData()
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
        

    //    let currentCell = tableView.cellForRow(at: indexPath) as! PlayerTableViewCell

        var player: Player!
        
        var userFantasyPlayer: UserFantasyPlayer!
       
        if selectedIndex == 0
        {
            player = keeperList[indexPath.section]
            player.playerSelected = !player.playerSelected
            
            userFantasyPlayer = UserFantasyPlayer.init(json: ["id":player.playerId ?? 0,"is_captain": 0, "is_vice_captain" : 0 ])
            
            if player.playerSelected
            {
                if self.verify(player)
                {
                    userTeam.keeper.append(userFantasyPlayer)
                }
                else
                {
                    player.playerSelected = !player.playerSelected
                    tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                    return
                }
                
            }
            else
            {
                userTeam.keeper = userTeam.keeper.filter{$0.id != userFantasyPlayer.id}
                isGreen = false
            }
            
        }
        else if selectedIndex == 1
        {
            player = batsmanList[indexPath.section]
            player.playerSelected = !player.playerSelected
            
            
            userFantasyPlayer = UserFantasyPlayer.init(json: ["id":player.playerId ?? 0,"is_captain": 0, "is_vice_captain" : 0 ])
            
            if player.playerSelected
            {
                if self.verify(player)
                {
                    userTeam.batsman.append(userFantasyPlayer)
                    
                }
                else
                {
                    player.playerSelected = !player.playerSelected
                    tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                    return
                }
                
            }
            else
            {
                userTeam.batsman = userTeam.batsman.filter{$0.id != userFantasyPlayer.id}
                isGreen = false
                
            }
            
            print(userTeam.batsman.count)
        }
        else if selectedIndex == 2
        {
            player = allRounderList[indexPath.section]
            player.playerSelected = !player.playerSelected
            
            userFantasyPlayer = UserFantasyPlayer.init(json: ["id":player.playerId ?? 0,"is_captain": 0, "is_vice_captain" : 0 ])
            
            if player.playerSelected
            {
                if self.verify(player)
                {
                    userTeam.allrounder.append(userFantasyPlayer)
                }else
                {
                    player.playerSelected = !player.playerSelected
                    tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                    return
                    
                }
            }
            else
            {
                userTeam.allrounder = userTeam.allrounder.filter{$0.id != userFantasyPlayer.id}
                isGreen = false
            }
        }
        else
        {
            player = bowlerList[indexPath.section]
            player.playerSelected = !player.playerSelected
            
            userFantasyPlayer = UserFantasyPlayer.init(json: ["id":player.playerId ?? 0,"is_captain": 0, "is_vice_captain" : 0 ])
            
            if player.playerSelected
            {
                if self.verify(player)
                {
                    userTeam.bowler.append(userFantasyPlayer)
                }
                else
                {
                    player.playerSelected = !player.playerSelected
                    tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                    return
                    
                }
            }
            else
            {
                userTeam.bowler = userTeam.bowler.filter{$0.id != userFantasyPlayer.id}
                isGreen = false
            }
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
        
        if firstTeamPlayerCount + secondTeamPlayerCount == Team_Rules.MaxPlayer
        {
            isGreen = true
        }
      
        self.updateSummary()
        tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
        
       // positionSelectorCollectionView.reloadItems(at: [IndexPath.init(item: selectedIndex, section: 0) as IndexPath])
        positionSelectorCollectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func updateSummary()
    {
        firstTeamCode.text = squadData.teams?.firstTeam?.teamKey
        secondTeamCode.text = squadData.teams?.secondTeam?.teamKey
        firstTeamCount.setTitle("\(firstTeamPlayerCount)", for: .normal)
        secondTeamCount.setTitle("\(secondTeamPlayerCount)", for: .normal)
        
        totalPlayersCountLabel.text = "\(firstTeamPlayerCount + secondTeamPlayerCount)/11"
        totalPointsLabel.text = "\(totalCreditPoint)/\(Team_Rules.MaxCredit)"
    }
    
    func verify(_ singlePlayer: Player) -> Bool
    {
        if firstTeamPlayerCount+secondTeamPlayerCount < Team_Rules.MaxPlayer
        {
            let totalCredit = firstTeamPlayerCount + secondTeamPlayerCount
            switch (singlePlayer.role) {
            case "batsman":
                if userTeam.batsman.count >= squadData.team_rules?.batsman?.maxPerMatch ?? 0
                {
                    
                    self.showStatus(false, msg: String.init(format: "You can select maximum %d batsman",squadData.team_rules?.batsman?.maxPerMatch ?? 0 ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (2 + userTeam.batsman.count + userTeam.bowler.count) < squadData.team_rules?.allrounder?.minPerMatch ?? 0
                {
                    self.showStatus(false, msg: String.init(format: "Your minimum allrounder is %d",squadData.team_rules?.allrounder?.minPerMatch ?? 0 ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (2 + userTeam.batsman.count + userTeam.allrounder.count) < squadData.team_rules?.bowler?.minPerMatch ?? 0
                {
                    self.showStatus(false, msg: String.init(format: "Your minimum bowler is %d",squadData.team_rules?.bowler?.minPerMatch ?? 0 ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1+userTeam.bowler.count + userTeam.allrounder.count + userTeam.batsman.count) < squadData.team_rules?.keeper?.minPerMatch ?? 0
                {
                    self.showStatus(false, msg: String.init(format: "Your minimum keeper is %d",squadData.team_rules?.keeper?.minPerMatch ?? 0 ))
                    return false
                }
                break;
            case "bowler":
                if userTeam.bowler.count >= squadData.team_rules?.bowler?.maxPerMatch ?? 0
                {
                    self.showStatus(false, msg: String.init(format: "You can select maximum %d bowler",squadData.team_rules?.bowler?.maxPerMatch ?? 0 ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (2 + userTeam.batsman.count + userTeam.bowler.count) < squadData.team_rules?.allrounder?.minPerMatch ?? 0
                {
                    self.showStatus(false, msg: String.init(format: "Your minimum allrounder is %d",squadData.team_rules?.allrounder?.minPerMatch ?? 0 ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (2 + userTeam.bowler.count + userTeam.allrounder.count) < squadData.team_rules?.batsman?.minPerMatch ?? 0
                {
                     self.showStatus(false, msg: String.init(format: "Your minimum batsman is %d",squadData.team_rules?.batsman?.minPerMatch ?? 0 ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1+userTeam.bowler.count + userTeam.allrounder.count + userTeam.batsman.count) < squadData.team_rules?.keeper?.minPerMatch ?? 0
                {
                    self.showStatus(false, msg: String.init(format: "Your minimum keeper is %d",squadData.team_rules?.keeper?.minPerMatch ?? 0 ))
                    return false
                }
                break;
            case "keeper":
                
                if userTeam.keeper.count >= squadData.team_rules?.keeper?.maxPerMatch ?? 0
                {
                    self.showStatus(false, msg: String.init(format: "You can select maximum %d keeper",squadData.team_rules?.keeper?.maxPerMatch ?? 0 ))
                    return false
                }
                break;
            case "allrounder":
                if userTeam.allrounder.count >= squadData.team_rules?.allrounder?.maxPerMatch ?? 0
                {
                    self.showStatus(false, msg: String.init(format: "You can select maximum %d allrounder",squadData.team_rules?.allrounder?.maxPerMatch ?? 0 ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (2 + userTeam.batsman.count + userTeam.allrounder.count) < squadData.team_rules?.bowler?.minPerMatch ?? 0
                {
                     self.showStatus(false, msg: String.init(format: "Your minimum bowler is %d",squadData.team_rules?.bowler?.minPerMatch ?? 0 ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (2 + userTeam.bowler.count + userTeam.allrounder.count) < squadData.team_rules?.batsman?.minPerMatch ?? 0
                {
                     self.showStatus(false, msg: String.init(format: "Your minimum batsman is %d",squadData.team_rules?.batsman?.minPerMatch ?? 0 ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1+userTeam.bowler.count + userTeam.allrounder.count + userTeam.batsman.count) < squadData.team_rules?.keeper?.minPerMatch ?? 0
                {
                    self.showStatus(false, msg: String.init(format: "Your minimum keeper is %d",squadData.team_rules?.keeper?.minPerMatch ?? 0 ))
                    return false
                }
                break;
                
            default:
                break;
            }
            
            //credit
            if totalCredit >= Team_Rules.MaxCredit
            {
                self.showStatus(false, msg: String.init(format: "Credit Limit is maximum %d",Team_Rules.MaxCredit ))
                
                return false
            }
            //Team
            if singlePlayer.teamBelong == 1
            {
                if firstTeamPlayerCount >= Team_Rules.Team1MaxPlayer
                {
                    self.showStatus(false, msg: String.init(format: "You can select maximum %d players from %@",Team_Rules.Team1MaxPlayer, squadData.teams?.firstTeam?.name ?? "Team 1" ))
                    return false
                }
            }
            else
            {
                if secondTeamPlayerCount >= Team_Rules.Team2MaxPlayer
                {
                    self.showStatus(false, msg: String.init(format: "You can select maximum %d players from %@",Team_Rules.Team2MaxPlayer,squadData.teams?.secondTeam?.name ?? "Team 2" ))
                    
                    return false
                }
            }
        }
        else
        {
            self.showStatus(false, msg: String.init(format: "Maximum team member is %d",Team_Rules.MaxPlayer ))
            return false
        }
        
        
        
        return true
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
