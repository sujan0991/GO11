//
//  EditTeamViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 11/7/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit


//struct Team_Rules {
//
//    static let MaxPlayer = 11
//    static let Team1MaxPlayer = 7
//    static let Team2MaxPlayer = 7
//    static let MaxCredit = 100
//}


class EditTeamViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource {
    
    var squadData:MatchSquadData!
    var batsmanList:[Player] = []
    var bowlerList:[Player] = []
    var keeperList:[Player] = []
    var allRounderList:[Player] = []
    
    var sortedbatsmanList:[Player] = []
    var sortedbowlerList:[Player] = []
    var sortedkeeperList:[Player] = []
    var sortedallRounderList:[Player] = []
    
    
    var userTeamId = 0
    
    var firstTeamPlayerCount = 0
    var secondTeamPlayerCount = 0
    var totalCreditPoint = 0.0
    
    var selectedIndex = 0
    var isGreen = false
    
    var userOldTeam: FantasySquadData!
    var userTeam : UsersFantasyTeam!
    
    var timeLeft : String!
    
    let formatter = NumberFormatter()
    
    var isLineUpOut = 0
    
    @IBOutlet weak var maxPlayerLabel: UILabel!
    
    @IBOutlet weak var positionSelectorCollectionView: UICollectionView!
    @IBOutlet weak var playerListView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var progressView: GradientProgressBar!
    
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    @IBOutlet weak var firstTeamCount: UIButton!
    @IBOutlet weak var firstTeamCode: UILabel!
    @IBOutlet weak var firstTeamFlag: UIImageView!
    
    
    @IBOutlet weak var secondTeamCount: UIButton!
    @IBOutlet weak var secondTeamCode: UILabel!
    @IBOutlet weak var secondTeamFlag: UIImageView!
    
    @IBOutlet weak var playersTopLabel: UILabel!
    @IBOutlet weak var creditLeftLabel: UILabel!
    @IBOutlet weak var totalPlayersCountLabel: UILabel!
    @IBOutlet weak var selectedPlayerCountLabel: UIButton!
    
    
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
   
    
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertMsgLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        placeNavBar(withTitle: "EDIT TEAM", isBackBtnVisible: true)
//
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        
        navTitle.text = String.init(format: "%@ Left".localized,timeLeft ?? "" )
        
        playerListView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "playerCell")
        
        progressView.gradientColors = [UIColor.init(named: "on_green")!.cgColor, UIColor.init(named: "on_green")!.cgColor]

        previewButton.setTitle("Preview Team".localized, for: .normal)
        nextButton.setTitle("Continue".localized, for: .normal)
        
        maxPlayerLabel.text = "Max 7 Players From a Team".localized
        playersTopLabel.text = "Players".localized
        playersLabel.text = "PLAYERS".localized
        creditsLabel.text = "CREDITS".localized
//        selectedPerLabel.text = "SEL by %".localized
//
        creditLeftLabel.text = "Credits Left".localized
        suggestionLabel.text = "Pick 1-4 Wicket-Keepers".localized
        
        alertMsgLabel.text = "Do you really want to exit? Your fantasy team changes will be discarded.".localized
        cancelButton.setTitle("Cancel".localized, for: .normal)
        
        let teamJson = [
            "match_id" : "0",
            "team_name": "",
            "batsman":[],
            "bowler":[],
            "allrounder":[],
            "keeper":[]
            ] as [String : Any]
        
        userTeam = UsersFantasyTeam(json: teamJson)

        
        print("squad data.........",squadData.playersList.count)
        
        APIManager.manager.getUsersSquad(teamId: String(describing: userTeamId)) { (status, data, msg) in
                
                if status{
                    
                    self.userOldTeam = data!
                    
//                    else{
//                        print("remove from batsman list")
//                        let index = userTeam.batsman.index(where: { $0.id == userPlayer.id })
//
//                        if let index = index {
//                          userTeam.batsman.remove(at: index)
//                        }
//                    }
                    for player in self.squadData.playersList{
                        
                       switch (player.role) {
                       case "batsman":
                                    //add batsman to userteam
                                    
                                    for singlePlayer in data!.batsman{
                                        
                                       if player.playerId == singlePlayer.playerId{ // checking if squad is updated
                                       
                                         let userFantasyPlayer = UserFantasyPlayer.init(json: ["id":singlePlayer.playerId ?? 0,"is_captain": singlePlayer.isCaptain!, "is_vice_captain" : singlePlayer.isViceCaptain! ])
                                        
                                         self.userTeam.batsman.append(userFantasyPlayer!)
                                        }
                                    }

                        break;
                        case "bowler":
                                       //add bowler to userteam
                                         
                                       for singlePlayer in data!.bowler{
                                        
                                          if player.playerId == singlePlayer.playerId{ // checking if squad is updated
                                            
                                             let userFantasyPlayer = UserFantasyPlayer.init(json: ["id":singlePlayer.playerId ?? 0,"is_captain": singlePlayer.isCaptain!, "is_vice_captain" : singlePlayer.isViceCaptain! ])
                                            
                                             self.userTeam.bowler.append(userFantasyPlayer!)
                                           }
                                         }
                        break;
                        case "keeper":
                                    //add keeper to userTeam
                                    for singlePlayer in data!.keeper{
                                     
                                        if player.playerId == singlePlayer.playerId{ // checking if squad is updated
                                                                    
                                           let userFantasyPlayer = UserFantasyPlayer.init(json: ["id":singlePlayer.playerId ?? 0,"is_captain": singlePlayer.isCaptain!, "is_vice_captain" : singlePlayer.isViceCaptain! ])
                                                                    
                                            self.userTeam.keeper.append(userFantasyPlayer!)
                                                                
                                         }
                                    }

                        break;
                        case "allrounder":
                            //add allrounder to userteam
                            
                          for singlePlayer in data!.allrounder{
                             if player.playerId == singlePlayer.playerId{ // checking if squad is updated

                                let userFantasyPlayer = UserFantasyPlayer.init(json: ["id":singlePlayer.playerId ?? 0,"is_captain": singlePlayer.isCaptain!, "is_vice_captain" : singlePlayer.isViceCaptain! ])
                                self.userTeam.allrounder.append(userFantasyPlayer!)
                             }
                           }
                            
                        break;
                                        
                        default:
                        break;
                    }

                    }
                    }
                   
                 
                    self.setSelectedPlayer()
                    
                    
                    self.calculatePoint()
                    
                    self.positionSelectorCollectionView.reloadData()
                    self.playerListView.reloadData()

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
    func setSelectedPlayer(){
        
        if self.squadData != nil
        {
            self.userTeam.matchId = self.squadData.matchId
            
            for player in self.squadData.playersList
            {
               
                
                switch (player.role) {
                case "batsman":
                    
                    for userPlayer in userTeam.batsman{
                        
                        if player.playerId == userPlayer.id{
                            
                            player.playerSelected = true
                            
                            if userPlayer.isCaptain == 1{
                                player.isCaptain = true
                            }
                            if userPlayer.isViceCaptain == 1{
                                player.isViceCaptain = true
                            }

                        }

                    }
                  self.batsmanList.append(player)
                    break;
                case "bowler":
                    for userPlayer in userTeam.bowler{
                        
                        if player.playerId == userPlayer.id{
                            
                            player.playerSelected = true
                            
                            if userPlayer.isCaptain == 1{
                                player.isCaptain = true
                            }
                            if userPlayer.isViceCaptain == 1{
                                player.isViceCaptain = true
                            }

                        }
                    
                    }
                    self.bowlerList.append(player)
                    break;
                case "keeper":
                    for userPlayer in userTeam.keeper{
                        
                        if player.playerId == userPlayer.id{
                            
                            player.playerSelected = true
                            
                            if userPlayer.isCaptain == 1{
                                player.isCaptain = true
                            }
                            if userPlayer.isViceCaptain == 1{
                                player.isViceCaptain = true
                            }
                        }
                        
                    
                    }
                    self.keeperList.append(player)
                    break;
                case "allrounder":
                    for userPlayer in userTeam.allrounder{
                        
                        if player.playerId == userPlayer.id{
                            
                            player.playerSelected = true
                            
                            if userPlayer.isCaptain == 1{
                                player.isCaptain = true
                            }
                            if userPlayer.isViceCaptain == 1{
                                player.isViceCaptain = true
                            }

                        }
                    }
                    self.allRounderList.append(player)
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
            
            
        }

        
    }
    
    func calculatePoint(){
        
        let multiplyer = 1.0
        
        for player in keeperList{
            for usersPlayer in userTeam.keeper{
                
                if usersPlayer.id == player.playerId{
                    
                    totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                    
                    if player.teamBelong == 1
                    {
                        firstTeamPlayerCount = firstTeamPlayerCount + Int(1 * multiplyer)
                    }
                    else
                    {
                        secondTeamPlayerCount = secondTeamPlayerCount + Int(1 * multiplyer)
                    }
                }
            }
        }
        for player in batsmanList{
            for usersPlayer in userTeam.batsman{
                
                if usersPlayer.id == player.playerId{
                    
                    totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                    
                    if player.teamBelong == 1
                    {
                        firstTeamPlayerCount = firstTeamPlayerCount + Int(1 * multiplyer)
                    }
                    else
                    {
                        secondTeamPlayerCount = secondTeamPlayerCount + Int(1 * multiplyer)
                    }
                }
            }
        }
        
        for player in allRounderList{
            for usersPlayer in userTeam.allrounder{
                
                if usersPlayer.id == player.playerId{
                    
                    totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                    
                    if player.teamBelong == 1
                    {
                        firstTeamPlayerCount = firstTeamPlayerCount + Int(1 * multiplyer)
                    }
                    else
                    {
                        secondTeamPlayerCount = secondTeamPlayerCount + Int(1 * multiplyer)
                    }
                }
            }
        }
        
        for player in bowlerList{
            for usersPlayer in userTeam.bowler{
                
                if usersPlayer.id == player.playerId{
                    
                    totalCreditPoint = totalCreditPoint +  player.creditPoints! * multiplyer
                    
                    if player.teamBelong == 1
                    {
                        firstTeamPlayerCount = firstTeamPlayerCount + Int(1 * multiplyer)
                    }
                    else
                    {
                        secondTeamPlayerCount = secondTeamPlayerCount + Int(1 * multiplyer)
                    }
                }
            }
        }
        
        if firstTeamPlayerCount + secondTeamPlayerCount == Team_Rules.MaxPlayer
        {
            print("isGreen true.....................")
            isGreen = true
        }
        
        updateSummary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        positionSelectorCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .top)
        
        positionSelectorCollectionView.reloadData()
        
        
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        print("isGreen in nextButtonAction",isGreen,squadData.playersList.count)
        
        if (isGreen)
        {
            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CaptainSelectorViewController") as? CaptainSelectorViewController
            
            popupVC?.userTeam = userTeam
            popupVC?.nextsquadData = squadData
            popupVC?.isFromEdit = true
            popupVC?.userTeamId = userTeamId
            popupVC?.userTeamName = userOldTeam.teamName!
            popupVC?.timeLeft = timeLeft
                
            self.navigationController?.pushViewController(popupVC ?? self, animated: true)
           // self.present(popupVC!, animated: true, completion: nil)
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
        
        //        self.present(popupVC!, animated: true) {
        //            print("")
        //        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("cellForItemAt..............")
        
        let cell:PositionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "positionCell", for: indexPath) as! PositionCollectionViewCell
        
        
      //  cell.playerCount.text = String.init(format: "0")
        
        if indexPath.item == 0
        {
            cell.positionTitle.text = "WK"
         //   cell.positionIcon.image = UIImage.init(named: "wicketKeeperIcon")
            cell.playerCount.text = String.init(format: "(%d)".localized, userTeam.keeper.count)

            cell.isSelected = true
            
        }
        else if indexPath.item == 1
        {
            cell.positionTitle.text = "BAT"
          //  cell.positionIcon.image = UIImage.init(named: "battingIcon")
            cell.playerCount.text = String.init(format: "(%d)".localized, userTeam.batsman.count)
                
        
            
            
        }
        else if indexPath.item == 2
        {
            cell.positionTitle.text = "ALL"
           // cell.positionIcon.image = UIImage.init(named: "allrounderIcon")
            cell.playerCount.text = String.init(format: "(%d)".localized, userTeam.allrounder.count)
            
        }
        else
        {
            cell.positionTitle.text = "BOWL"
           // cell.positionIcon.image = UIImage.init(named: "bowlingIcon")
            cell.playerCount.text = String.init(format: "(%d)".localized, userTeam.bowler.count)
     
            
        }
        cell.isSelected = selectedIndex == indexPath.item
        
        if cell.isSelected {
            
            cell.positionIcon.backgroundColor = UIColor.init(named: "green_to_orange")
            
        }else{
            
            cell.positionIcon.backgroundColor = UIColor.clear
        }
        
//        if isGreen {
//
//            cell.playerCount.backgroundColor = UIColor.init(named: "GreenHighlight")
//
//        }
//        else
//        {
//            cell.playerCount.backgroundColor = UIColor.init(named: "TabOrangeColor")
//
//        }
        
        return cell
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        // print("insetForSectionAt")
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
            
//                var userFantasyPlayer: UserFantasyPlayer!
//
//
//                for tempPlayer in userTeam.keeper{
//
//                  if tempPlayer.id == player.playerId{
//
//
//                    player.playerSelected = true
//
//                 }
//            }
            
            
            
        }
        else if selectedIndex == 1
        {
            player = sortedbatsmanList[indexPath.section]
  
//                var userFantasyPlayer: UserFantasyPlayer!
//
//                for tempPlayer in userTeam.batsman{
//
//                    if tempPlayer.id == player.playerId{
//
//                        print("player selected")
//
//                        player.playerSelected = true
//
//                    }
//
//                }
            
            
            
        }
        else if selectedIndex == 2
        {
            player = sortedallRounderList[indexPath.section]
   
//                var userFantasyPlayer: UserFantasyPlayer!
//
//                for tempPlayer in userTeam.allrounder{
//
//                    if tempPlayer.id == player.playerId{
//                        print("player selected")
//                        player.playerSelected = true
//
//
//
//                    }
//
//                }
            
            
            
        }
        else
        {
            player = sortedbowlerList[indexPath.section]
            
    
//                var userFantasyPlayer: UserFantasyPlayer!
//
//                for tempPlayer in userTeam.bowler{
//
//                    if tempPlayer.id == player.playerId{
//                        print("player selected")
//
//                        player.playerSelected = true
//
//                    }
//
//                }
            
            
            
        }
        
        cell.setInfo(player: player,squad: squadData.teams!, isLineUpOut: self.isLineUpOut)
        
        
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
            print("isGreen true.....................")
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

        firstTeamCode.text = squadData.teams?.firstTeam?.teamKey!.uppercased()
        secondTeamCode.text = squadData.teams?.secondTeam?.teamKey!.uppercased()
        firstTeamCount.setTitle("\(firstTeamPlayerCount)".localized, for: .normal)
        secondTeamCount.setTitle("\(secondTeamPlayerCount)".localized, for: .normal)
        
        if squadData.teams?.firstTeam?.logo != nil{
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(squadData.teams?.firstTeam?.logo ?? "")")
            firstTeamFlag.kf.setImage(with: url1)
        }
        
        if squadData.teams?.secondTeam?.logo != nil{
            
            let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(squadData.teams?.secondTeam?.logo ?? "")")
            
            secondTeamFlag.kf.setImage(with: url2)
        }

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
           
            totalPointsLabel.text = bnPointLeft
            
            
        }
        
//        totalPlayersCountLabel.text = "\(firstTeamPlayerCount + secondTeamPlayerCount)/11"
//
//        selectedPlayerCountLabel.setTitle("\(firstTeamPlayerCount + secondTeamPlayerCount)", for: .normal)
//
//        let pointLeft = Double(Team_Rules.MaxCredit) - totalCreditPoint
//        totalPointsLabel.text = "\(pointLeft)"
        
        if (firstTeamPlayerCount + secondTeamPlayerCount) == 11 {
            
            nextButton.setBackgroundColor(UIColor.init(named: "on_green")!, for: UIControl.State.normal)
            nextButton.isUserInteractionEnabled = true
            
        }else{
            
            nextButton.setBackgroundColor(UIColor.init(named: "brand_txt_color_gray")!, for: UIControl.State.normal)
            nextButton.isUserInteractionEnabled = false
            
        }
        print("count.........",(firstTeamPlayerCount + secondTeamPlayerCount))
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
    
    
    @IBAction func backButtonACtion(_ sender: Any) {
        
        shadowView.isHidden = false
        alertView.isHidden = false
        
    }
    
    @IBAction func cancelbuttonAction(_ sender: Any) {
        
        shadowView.isHidden = true
        alertView.isHidden = true
    }
    
    @IBAction func exitButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
