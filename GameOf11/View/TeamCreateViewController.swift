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
    static let MaxCredit = 100.0
}


class TeamCreateViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource {
    
    var squadData:MatchSquadData!
    var batsmanList:[Player] = []
    var bowlerList:[Player] = []
    var keeperList:[Player] = []
    var allRounderList:[Player] = []
    
    var sortedbatsmanList:[Player] = []
    var sortedbowlerList:[Player] = []
    var sortedkeeperList:[Player] = []
    var sortedallRounderList:[Player] = []
    //
    
    var firstTeamPlayerCount = 0
    var secondTeamPlayerCount = 0
    var totalCreditPoint = 0.0
    
    var selectedIndex = 0
    var isGreen = false
    
    var userTeam : UsersFantasyTeam!
    
    var timeLeft : String!
    
    let formatter = NumberFormatter()
    
    @IBOutlet weak var maxPlayerLabel: UILabel!
    
    @IBOutlet weak var firstTeamCount: UIButton!
    @IBOutlet weak var firstTeamCode: UILabel!
    @IBOutlet weak var firstTeamFlag: UIImageView!
    
    @IBOutlet weak var secondTeamCount: UIButton!
    @IBOutlet weak var secondTeamCode: UILabel!
    @IBOutlet weak var secondTeamFlag: UIImageView!
    
    @IBOutlet weak var positionSelectorCollectionView: UICollectionView!
    @IBOutlet weak var playerListView: UITableView!
    
    @IBOutlet weak var progressView: GradientProgressBar!
    
    
    @IBOutlet weak var playersTopLabel: UILabel!
    @IBOutlet weak var creditLeftLabel: UILabel!
    
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var totalPlayersCountLabel: UILabel!
    @IBOutlet weak var selectedPlayerCountLabel: UIButton!
    
    @IBOutlet weak var suggestionLabel: UILabel!
    
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var selectedPerLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    
    @IBOutlet weak var navTitle: UILabel!
    
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var alartView: UIView!
    @IBOutlet weak var alertmsgLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        placeNavBar(withTitle: "Create Your Team", isBackBtnVisible: true)
        //
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        navTitle.text = String.init(format: "%@ Left".localized,timeLeft ?? "" )
        
        progressView.gradientColors = [UIColor.init(named: "GreenHighlight")!.cgColor, UIColor.init(named: "GreenHighlight")!.cgColor]
        
        
        nextButton.setBackgroundColor(UIColor.init(named: "on_green")!, for: UIControl.State.normal)
        nextButton.isUserInteractionEnabled = false
        
        previewButton.setTitle("Preview Team".localized, for: .normal)
        nextButton.setTitle("Continue".localized, for: .normal)
        
        maxPlayerLabel.text = "Max 7 Players From a Team".localized
        playersTopLabel.text = "Players".localized
        playersLabel.text = "PLAYERS".localized
        creditsLabel.text = "CREDITS".localized
        selectedPerLabel.text = "SEL by %".localized
        
        creditLeftLabel.text = "Credits Left".localized
        suggestionLabel.text = "Pick 1-4 Wicket-Keepers".localized
        
        alertmsgLabel.text = "Do you really want to exit? Your fantasy team changes will be discarded.".localized
        cancelButton.setTitle("Cancel".localized, for: .normal)
        
        let teamJson = [
            "match_id" : "0",
            "team_name": ""
            ] as [String : Any]
        
        userTeam = UsersFantasyTeam(json: teamJson)
        
        if squadData != nil
        {
            userTeam.matchId = squadData.matchId
            
            print("squadData.team_rules?.keeper ",squadData.team_rules?.keeper?.maxPerMatch)
            
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
            
            sortedkeeperList = keeperList.sorted(by: {
                (player1: Player, player2: Player) -> Bool in
                
                if let point1 = player1.creditPoints,
                    let point2 = player2.creditPoints{
                    
                    return point1 > point2
                }
                
                
                return true
            })
            
            sortedbatsmanList = batsmanList.sorted(by: {
                (player1: Player, player2: Player) -> Bool in
                
                if let point1 = player1.creditPoints,
                    let point2 = player2.creditPoints{
                    
                    return point1 > point2
                }
                
                
                return true
            })
            
            sortedbowlerList = bowlerList.sorted(by: {
                (player1: Player, player2: Player) -> Bool in
                
                if let point1 = player1.creditPoints,
                    let point2 = player2.creditPoints{
                    
                    return point1 > point2
                }
                
                
                return true
            })
            
            sortedallRounderList = allRounderList.sorted(by: {
                (player1: Player, player2: Player) -> Bool in
                
                if let point1 = player1.creditPoints,
                    let point2 = player2.creditPoints{
                    
                    return point1 > point2
                }
                
                
                return true
            })
            
            
            print("................................",keeperList.count,sortedkeeperList.count)
        }
        
        positionSelectorCollectionView?.delegate = self
        positionSelectorCollectionView?.dataSource = self
        
        playerListView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "playerCell")
        
        playerListView.delegate = self
        playerListView.dataSource = self
        playerListView.removeEmptyCells()
        
        
        previewButton.layer.shadowColor = UIColor.gray.cgColor
        previewButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        previewButton.layer.shadowRadius = 2
        previewButton.layer.shadowOpacity = 0.5
        previewButton.layer.masksToBounds = false
        
        nextButton.layer.shadowColor = UIColor.gray.cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        nextButton.layer.shadowRadius = 2
        nextButton.layer.shadowOpacity = 0.5
        nextButton.layer.masksToBounds = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if #available(iOS 13, *) {
                  if UserDefaults.standard.bool(forKey: "DarkMode"){
                      
                      overrideUserInterfaceStyle = .dark
                      
                  }else{
                      overrideUserInterfaceStyle = .light
                  }
              
              }else{
                  
              }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        positionSelectorCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
        
        positionSelectorCollectionView.reloadData()
        
        if userTeam.batsman.count != 0{
            
            print("userTeam in viewwill appear??????????",userTeam.batsman.count)
            
        }
        
        if squadData != nil{
            
            for player in squadData.playersList
            {
                
                print("player.isCaptain in viewDidAppear",player.isCaptain)
            }
            
        }
        
        
        
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        if (isGreen)
        {
            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CaptainSelectorViewController") as? CaptainSelectorViewController
            
            print("nextButtonAction...........squad count",squadData.playersList.count)
            
            popupVC?.userTeam = userTeam
            popupVC?.nextsquadData = squadData
            popupVC?.timeLeft = timeLeft
            
            
            self.navigationController?.pushViewController(popupVC ?? self, animated: true)
        }
        else
        {
            self.view.makeToast("Please complete the team first".localized)
        }
        
        
        //        self.present(popupVC!, animated: true) {
        //            print("")
        //        }
        
    }
    
    @IBAction func previewAction(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamPreviewViewController") as? TeamPreviewViewController
        
        popupVC?.pvSquadData = squadData
        popupVC?.userTeam = userTeam
        self.navigationController?.pushViewController(popupVC ?? self, animated: true)
        
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
            //  cell.positionIcon.image = UIImage.init(named: "wicketKeeperIcon")
            
            
            if userTeam != nil
            {
                cell.playerCount.text = String.init(format: "(%d)".localized, userTeam.keeper.count)
            }
            
            cell.isSelected = true
            
        }
        else if indexPath.item == 1
        {
            cell.positionTitle.text = "BAT"
            //  cell.positionIcon.image = UIImage.init(named: "battingIcon")
            
            if userTeam != nil
            {
                cell.playerCount.text = String.init(format: "(%d)".localized, userTeam.batsman.count)
            }
            
            
            
        }
        else if indexPath.item == 2
        {
            cell.positionTitle.text = "ALL"
            // cell.positionIcon.image = UIImage.init(named: "allrounderIcon")
            
            
            if userTeam != nil
            {
                cell.playerCount.text = String.init(format: "(%d)".localized, userTeam.allrounder.count)
            }
            
            
        }
        else
        {
            cell.positionTitle.text = "BOWL"
            // cell.positionIcon.image = UIImage.init(named: "bowlingIcon")
            
            
            if userTeam != nil
            {
                cell.playerCount.text = String.init(format: "(%d)".localized, userTeam.bowler.count)
            }
            
            
        }
        cell.isSelected = selectedIndex == indexPath.item
        
        if cell.isSelected {
            
            cell.positionIcon.backgroundColor = UIColor.init(named: "orange_to_blue")
           
        }else{
            
            cell.positionIcon.backgroundColor = UIColor.clear
            
        }
        
        
        
        return cell
        
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //
    //       // print("insetForSectionAt")
    //        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    //        let width = collectionView.frame.size.height //some width
    //
    //        let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: section))
    //
    //        let combinedItemWidth = (numberOfItems * width) + ((numberOfItems - 1)  * flowLayout.minimumInteritemSpacing)
    //        let padding = (collectionView.frame.width - combinedItemWidth) / 2
    //
    //        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    //
    //
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        _ = (collectionView.frame.size.width - 3 * 10) / 4
        
        return CGSize(width: collectionView.frame.size.width/4, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.item
        
//        let selectedCell: PositionCollectionViewCell = collectionView.cellForItem(at: indexPath) as! PositionCollectionViewCell
//        selectedCell.positionTitle.textColor = UIColor.init(named: "dark_to_white")
//        selectedCell.playerCount.textColor = UIColor.init(named: "dark_to_white")
                   
        let indexPth = IndexPath(row: 0, section: 0)
        self.playerListView.scrollToRow(at: indexPth, at: .top, animated: true)
        
        if indexPath.item == 0
        {
            suggestionLabel.text = "Pick 1-4 Wicket-Keepers".localized
        }
        else if indexPath.item == 1
        {
            suggestionLabel.text = "Pick 3-6 Batsmen".localized
            
        }
        else if indexPath.item == 2
        {
            
            suggestionLabel.text = "Pick 1-4 All-Rounders".localized
        }
        else
        {
            
            suggestionLabel.text = "Pick 3-6 Bowlers".localized
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
            player = sortedkeeperList[indexPath.section]
            
            
        }
        else if selectedIndex == 1
        {
            player = sortedbatsmanList[indexPath.section]
            
            
        }
        else if selectedIndex == 2
        {
            player = sortedallRounderList[indexPath.section]
            
            
        }
        else
        {
            
            
            player = sortedbowlerList[indexPath.section]
            
            
        }
        
        
        cell.setInfo(player: player,squad: squadData.teams!)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if let cell = cell as? PlayerTableViewCell{
            
            
            var player: Player!
            
            if selectedIndex == 0
            {
                player = sortedkeeperList[indexPath.section]
                
                
            }
            else if selectedIndex == 1
            {
                player = sortedbatsmanList[indexPath.section]
                
                
            }
            else if selectedIndex == 2
            {
                player = sortedallRounderList[indexPath.section]
                
                
            }
            else
            {
                player = sortedbowlerList[indexPath.section]
                
                
            }
            
            if player.teamBelong == 1
            {
                
                cell.teamCode.textColor = UIColor.init(named: "on_green")!
            }
            else
            {
                
                cell.teamCode.textColor = UIColor.init(named: "brand_orange")!
            }
        }
        
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let cell = tableView.dequeueReusableCell(withIdentifier:"headerCell")
    //
    //        return cell
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //
    //        return 50
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //    let currentCell = tableView.cellForRow(at: indexPath) as! PlayerTableViewCell
        
        var player: Player!
        
        var userFantasyPlayer: UserFantasyPlayer!
        
        if selectedIndex == 0
        {
            
            player = sortedkeeperList[indexPath.section]
            player.playerSelected = !player.playerSelected
            
            userFantasyPlayer = UserFantasyPlayer.init(json: ["id":player.playerId ?? 0,"is_captain": 0, "is_vice_captain" : 0 ])
            
            var multiplyer = 1.0
            
            if !player.playerSelected
            {
                multiplyer = -1.0
                
                
            }
            //remove as captain and vice captain
            if player.isCaptain{
                
                player.isCaptain = false
            }
            if player.isViceCaptain{
                
                player.isViceCaptain = false
            }
            
            if player.playerSelected
            {
                print("......... playerSelected")
                
                totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                
                print("totalCreditPoint in did select",totalCreditPoint)
                
                
                
                if self.verify(player)
                {
                    userTeam.keeper.append(userFantasyPlayer)
                }
                else
                {
                    player.playerSelected = !player.playerSelected
                    tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                    
                    totalCreditPoint = totalCreditPoint -  player.creditPoints!
                    
                    return
                }
                
            }
            else
            {
                print("..........not playerSelected")
                totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                
                print("totalCreditPoint in did select",totalCreditPoint)
                
                userTeam.keeper = userTeam.keeper.filter{$0.id != userFantasyPlayer.id}
                isGreen = false
                
            }
            
        }
        else if selectedIndex == 1
        {
            player = sortedbatsmanList[indexPath.section]
            player.playerSelected = !player.playerSelected
            
            
            userFantasyPlayer = UserFantasyPlayer.init(json: ["id":player.playerId ?? 0,"is_captain": 0, "is_vice_captain" : 0 ])
            
            var multiplyer = 1.0
            
            if !player.playerSelected
            {
                multiplyer = -1.0
            }
            
            //remove as captain and vice captain
            if player.isCaptain{
                
                player.isCaptain = false
            }
            if player.isViceCaptain{
                
                player.isViceCaptain = false
            }
            
            
            if player.playerSelected
            {
                
                totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                
                print("totalCreditPoint in did select",totalCreditPoint)
                
                
                if self.verify(player)
                {
                    userTeam.batsman.append(userFantasyPlayer)
                }
                else
                {
                    player.playerSelected = !player.playerSelected
                    tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                    
                    totalCreditPoint = totalCreditPoint -  player.creditPoints!
                    
                    return
                }
                
            }
            else
            {
                totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                
                print("totalCreditPoint in did select",totalCreditPoint)
                
                
                userTeam.batsman = userTeam.batsman.filter{$0.id != userFantasyPlayer.id}
                isGreen = false
                
            }
            
            print(userTeam.batsman.count)
        }
        else if selectedIndex == 2
        {
            player = sortedallRounderList[indexPath.section]
            player.playerSelected = !player.playerSelected
            
            userFantasyPlayer = UserFantasyPlayer.init(json: ["id":player.playerId ?? 0,"is_captain": 0, "is_vice_captain" : 0 ])
            
            var multiplyer = 1.0
            
            if !player.playerSelected
            {
                multiplyer = -1.0
            }
            
            //remove as captain and vice captain
            if player.isCaptain{
                
                player.isCaptain = false
            }
            if player.isViceCaptain{
                
                player.isViceCaptain = false
            }
            
            
            if player.playerSelected
            {
                totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                
                print("totalCreditPoint in did select",totalCreditPoint)
                
                
                if self.verify(player)
                {
                    userTeam.allrounder.append(userFantasyPlayer)
                }else
                {
                    player.playerSelected = !player.playerSelected
                    tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                    
                    totalCreditPoint = totalCreditPoint -  player.creditPoints!
                    
                    return
                    
                }
            }
            else
            {
                totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                
                print("totalCreditPoint in did select",totalCreditPoint)
                
                userTeam.allrounder = userTeam.allrounder.filter{$0.id != userFantasyPlayer.id}
                isGreen = false
                
                
            }
        }
        else
        {
            player = sortedbowlerList[indexPath.section]
            player.playerSelected = !player.playerSelected
            
            userFantasyPlayer = UserFantasyPlayer.init(json: ["id":player.playerId ?? 0,"is_captain": 0, "is_vice_captain" : 0 ])
            
            var multiplyer = 1.0
            
            if !player.playerSelected
            {
                multiplyer = -1.0
            }
            
            //remove as captain and vice captain
            if player.isCaptain{
                
                player.isCaptain = false
            }
            if player.isViceCaptain{
                
                player.isViceCaptain = false
            }
            
            
            if player.playerSelected
            {
                totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                
                print("totalCreditPoint in did select",totalCreditPoint)
                
                
                if self.verify(player)
                {
                    userTeam.bowler.append(userFantasyPlayer)
                }
                else
                {
                    player.playerSelected = !player.playerSelected
                    tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                    
                    totalCreditPoint = totalCreditPoint -  player.creditPoints! 
                    
                    return
                    
                }
            }
            else
            {
                totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                
                print("totalCreditPoint in did select",totalCreditPoint)
                
                userTeam.bowler = userTeam.bowler.filter{$0.id != userFantasyPlayer.id}
                isGreen = false
                
                
            }
        }
        
        
        
        var multiplyer = 1.0
        
        if !player.playerSelected
        {
            multiplyer = -1.0
        }
        
        
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
        let selectedCount = (firstTeamPlayerCount + secondTeamPlayerCount)
        let total = 11
        let progress:Float = Float(selectedCount) / Float(total)
        progressView.progress = progress
        
        
        firstTeamCode.text = squadData.teams?.firstTeam?.teamKey?.uppercased()
        secondTeamCode.text = squadData.teams?.secondTeam?.teamKey?.uppercased()
        firstTeamCount.setTitle("\(firstTeamPlayerCount)".localized, for: .normal)
        secondTeamCount.setTitle("\(secondTeamPlayerCount)".localized, for: .normal)
        
        if Language.language == Language.english{
            
            totalPlayersCountLabel.text = "\(firstTeamPlayerCount + secondTeamPlayerCount)/11".localized
            
            selectedPlayerCountLabel.setTitle("\(firstTeamPlayerCount + secondTeamPlayerCount)".localized, for: .normal)
            
            let pointLeft = Double(Team_Rules.MaxCredit) - totalCreditPoint
            totalPointsLabel.text = "\(pointLeft)".localized
            
        }else{
            
            
            let bnSelectedCount = formatter.string(for: (firstTeamPlayerCount + secondTeamPlayerCount))
            totalPlayersCountLabel.text = "\(String(describing: bnSelectedCount!))/১১"
            
            
            selectedPlayerCountLabel.setTitle(bnSelectedCount, for: .normal)
            
            let pointLeft = Double(Team_Rules.MaxCredit) - totalCreditPoint
            let bnPointLeft = formatter.string(from: NSNumber(value: pointLeft))
            print("???????????????????????",pointLeft,bnPointLeft)
            totalPointsLabel.text = bnPointLeft
            
            
        }
        
        
        
        if squadData.teams?.firstTeam?.logo != nil{
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(squadData.teams?.firstTeam?.logo ?? "")")
            firstTeamFlag.kf.setImage(with: url1)
        }
        
        if squadData.teams?.secondTeam?.logo != nil{
            
            let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(squadData.teams?.secondTeam?.logo ?? "")")
            
            secondTeamFlag.kf.setImage(with: url2)
        }
        
        if (firstTeamPlayerCount + secondTeamPlayerCount) == 11 {
            
            nextButton.setBackgroundColor(UIColor.init(named: "on_green")!, for: UIControl.State.normal)
            nextButton.isUserInteractionEnabled = true
            
            nextButton.layer.shadowColor = UIColor.gray.cgColor
            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            nextButton.layer.shadowRadius = 2
            nextButton.layer.shadowOpacity = 0.5
            nextButton.layer.masksToBounds = false
            
        }else{
            
            nextButton.setBackgroundColor(UIColor.init(named: "HighlightGrey")!, for: UIControl.State.normal)
            nextButton.isUserInteractionEnabled = false
            
            nextButton.layer.shadowColor = UIColor.gray.cgColor
            nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            nextButton.layer.shadowRadius = 2
            nextButton.layer.shadowOpacity = 0.5
            nextButton.layer.masksToBounds = false
            
            
        }
        
        // print("count.........",(firstTeamPlayerCount + secondTeamPlayerCount))
    }
    
    func verify(_ singlePlayer: Player) -> Bool
    {
        if firstTeamPlayerCount+secondTeamPlayerCount < Team_Rules.MaxPlayer
        {
            let totalCredit = firstTeamPlayerCount + secondTeamPlayerCount
            
            switch (singlePlayer.role) {
            case "batsman":
                //                if userTeam.batsman.count >= squadData.team_rules?.batsman?.maxPerMatch ?? 0
                //                {
                if userTeam.batsman.count >= 6
                {
                    
                    self.view.makeToast(String.init(format: "Not more than 6 Batsmen".localized))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1 + userTeam.batsman.count + userTeam.bowler.count + userTeam.keeper.count) < 1 //squadData.team_rules?.allrounder?.minPerMatch ?? 0
                {
                    self.view.makeToast(String.init(format: "Minimum 1 All Rounder".localized))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1 + userTeam.batsman.count + userTeam.allrounder.count + userTeam.keeper.count) < 3 //squadData.team_rules?.bowler?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 3 Bowlers".localized ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1+userTeam.bowler.count + userTeam.allrounder.count + userTeam.batsman.count) < 1 //squadData.team_rules?.keeper?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 1 Wicket Keeper".localized ))
                    return false
                }
                break;
            case "bowler":
                //                if userTeam.bowler.count >= squadData.team_rules?.bowler?.maxPerMatch ?? 0
                //                {
                if userTeam.bowler.count >= 6
                {
                    
                    self.view.makeToast( String.init(format: "Not more than 6 Bowlers".localized))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1 + userTeam.batsman.count + userTeam.bowler.count + userTeam.keeper.count) < 1 //squadData.team_rules?.allrounder?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 1 All Rounder".localized))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1 + userTeam.keeper.count + userTeam.bowler.count + userTeam.allrounder.count) < 3 //squadData.team_rules?.batsman?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 3 Batsmen".localized))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1+userTeam.bowler.count + userTeam.allrounder.count + userTeam.batsman.count) < 1 //squadData.team_rules?.keeper?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 1 Wicket Keeper".localized))
                    return false
                }
                break;
            case "keeper":
                
                //                if userTeam.keeper.count >= squadData.team_rules?.keeper?.maxPerMatch ?? 0
                //                {
                if userTeam.keeper.count >= 4
                {
                    self.view.makeToast( String.init(format: "Not more than 4 Wicket Keeper".localized))
                    return false
                }else if  Team_Rules.MaxPlayer - (1 + userTeam.batsman.count + userTeam.allrounder.count + userTeam.keeper.count) < 3 //squadData.team_rules?.bowler?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 3 Bowlers".localized ))
                    return false
                }else if  Team_Rules.MaxPlayer - (1 + userTeam.batsman.count + userTeam.bowler.count + userTeam.keeper.count) < 1 //squadData.team_rules?.allrounder?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 1 All Rounder".localized))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1 + userTeam.keeper.count + userTeam.bowler.count + userTeam.allrounder.count) < 3 //squadData.team_rules?.batsman?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 3 Batsmen".localized))
                    return false
                }
                
                break;
            case "allrounder":
                if userTeam.allrounder.count >= 4 //squadData.team_rules?.allrounder?.maxPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Not more than 4 All Rounders".localized))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1 + userTeam.batsman.count + userTeam.allrounder.count + userTeam.keeper.count) < 3 //squadData.team_rules?.bowler?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 3 Bowlers".localized ))
                    return false
                }
                else if  Team_Rules.MaxPlayer - (1 + userTeam.keeper.count + userTeam.bowler.count + userTeam.allrounder.count) < 3 //squadData.team_rules?.batsman?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 3 Batsmen".localized))
                    return false
                }
                    
                else if  Team_Rules.MaxPlayer - (1+userTeam.bowler.count + userTeam.allrounder.count + userTeam.batsman.count) < 1 //squadData.team_rules?.keeper?.minPerMatch ?? 0
                {
                    self.view.makeToast( String.init(format: "Minimum 1 Wicket Keeper".localized ))
                    return false
                }
                break;
                
            default:
                break;
            }
            
            
            //credit
            print("totalCreditPoint in verify.........",totalCreditPoint)
            
            if totalCreditPoint > Team_Rules.MaxCredit
            {
                
                self.view.makeToast( String.init(format: "Total credit value can not be greater than 100".localized))
                
                return false
            }
            
            
            //Team
            if singlePlayer.teamBelong == 1
            {
                // if firstTeamPlayerCount >= Team_Rules.Team1MaxPlayer
                if firstTeamPlayerCount >= 7
                {
                    self.view.makeToast( String.init(format: "Not more than 7 players from any team".localized ))
                    return false
                }
            }
            else
            {
                if secondTeamPlayerCount >= 7
                {
                    self.view.makeToast( String.init(format: "Not more than 7 players from any team".localized ))
                    
                    return false
                }
            }
        }
        else
        {
            self.view.makeToast( String.init(format: "Your squad can not cross 11 players".localized))
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
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        shadowView.isHidden = false
        alartView.isHidden = false
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        shadowView.isHidden = true
        alartView.isHidden = true
    }
    
    @IBAction func exitButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
