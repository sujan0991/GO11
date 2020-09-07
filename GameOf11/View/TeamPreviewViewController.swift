//
//  TeamPreviewViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 27/2/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class TeamPreviewViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource {
    
    var pvSquadData : MatchSquadData!
    var userTeamId = 0
    
    var isAlreadyCreatedTeam = false
    var alreadyCreatedTeam:FantasySquadData!
    var userTeam : UsersFantasyTeam!
    
    
    var batsmanList:[Player] = []
    var bowlerList:[Player] = []
    var keeperList:[Player] = []
    var allRounderList:[Player] = []
    
    @IBOutlet weak var teamTableView: UITableView!
    
    
    @IBOutlet weak var previewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "TEAM PREVIEW".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        //        print("userTeam.batsman.count",userTeam.batsman.count)
        
        if isAlreadyCreatedTeam{
            
            APIManager.manager.getUsersSquad(teamId: String(describing: userTeamId)) { (status, data, msg) in
                
                if status{
                    
                    self.alreadyCreatedTeam = data
                    
                    self.setSelectedPlayer()
                    
                    self.teamTableView.delegate = self
                    self.teamTableView.dataSource = self
                    self.teamTableView.removeEmptyCells()
                    
                }
            }
            
        }else{
            
            print("pvSquadData.playersList.count.......",pvSquadData.playersList.count,userTeam.batsman.count)
            
            if pvSquadData != nil
            {
                for player in pvSquadData.playersList
                {
                    
                    switch (player.role) {
                        
                    case "batsman":
                        for userPlayer in userTeam.batsman{
                            
                            print("pvSquadData.batsman id.....",player.isCaptain)
                            print("userTeam.batsman id.......",userPlayer.isCaptain)
                            
                            
                            if player.playerId == userPlayer.id{
                                
                                print("userTeam.batsman id",userPlayer.id!)
                                
                                player.playerSelected = true
                                if userPlayer.isCaptain == 1{
                                    
                                    player.isCaptain = true
                                }
                                if userPlayer.isViceCaptain == 1{
                                    
                                    player.isViceCaptain = true
                                    
                                }
                                
                                self.batsmanList.append(player)
                            }
                            
                        }
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
                                
                                self.bowlerList.append(player)
                            }
                            
                        }
                        
                        break;
                    case "keeper":
                        for userPlayer in userTeam.keeper{
                            
                            print("pvSquadData.batsman id.....??",player.isCaptain)
                            print("userTeam.batsman id.......??",userPlayer.isCaptain)
                            
                            if player.playerId == userPlayer.id{
                                
                                player.playerSelected = true
                                
                                if userPlayer.isCaptain == 1{
                                    
                                    player.isCaptain = true
                                }
                                if userPlayer.isViceCaptain == 1{
                                    
                                    player.isViceCaptain = true
                                }
                                
                                self.keeperList.append(player)
                            }
                            
                            
                        }
                        
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
                                self.allRounderList.append(player)
                            }
                        }
                        
                        break;
                        
                    default:
                        break;
                    }
                    
                }
                
                teamTableView.delegate = self
                teamTableView.dataSource = self
                teamTableView.removeEmptyCells()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        print("isAlreadyCreatedTeam......",isAlreadyCreatedTeam)
   
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
        
        print("alreadyCreatedTeam......",alreadyCreatedTeam.keeper.count,alreadyCreatedTeam.batsman.count,alreadyCreatedTeam.allrounder.count,alreadyCreatedTeam.bowler.count)
        
        if self.pvSquadData != nil
        {
            
            for player in self.pvSquadData.playersList
            {
                
                
                switch (player.role) {
                case "batsman":
                    
                    for userPlayer in alreadyCreatedTeam.batsman{
                        
                        if player.playerId == userPlayer.playerId{
                            
                            player.playerSelected = true
                            
                            if userPlayer.isCaptain == 1{
                                player.isCaptain = true
                            }
                            if userPlayer.isViceCaptain == 1{
                                player.isViceCaptain = true
                            }
                            
                            self.batsmanList.append(player)
                        }
                        
                    }
                    
                    break;
                case "bowler":
                    for userPlayer in alreadyCreatedTeam.bowler{
                        
                        if player.playerId == userPlayer.playerId{
                            
                            player.playerSelected = true
                            
                            if userPlayer.isCaptain == 1{
                                player.isCaptain = true
                            }
                            if userPlayer.isViceCaptain == 1{
                                player.isViceCaptain = true
                            }
                            
                            self.bowlerList.append(player)
                        }
                        
                    }
                    
                    break;
                case "keeper":
                    for userPlayer in alreadyCreatedTeam.keeper{
                        
                        if player.playerId == userPlayer.playerId{
                            
                            player.playerSelected = true
                            
                            if userPlayer.isCaptain == 1{
                                player.isCaptain = true
                            }
                            if userPlayer.isViceCaptain == 1{
                                player.isViceCaptain = true
                            }
                            
                            self.keeperList.append(player)
                        }
                        
                        
                    }
                    
                    break;
                case "allrounder":
                    for userPlayer in alreadyCreatedTeam.allrounder{
                        
                        if player.playerId == userPlayer.playerId{
                            
                            player.playerSelected = true
                            
                            if userPlayer.isCaptain == 1{
                                player.isCaptain = true
                            }
                            if userPlayer.isViceCaptain == 1{
                                player.isViceCaptain = true
                            }
                            self.allRounderList.append(player)
                        }
                    }
                    
                    break;
                    
                default:
                    break;
                }
                
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"previewPlayerCell") as! PreviewTableViewCell
        
        if indexPath.section == 0
        {
            cell.setInfo(players: keeperList)
        }
        else if indexPath.section == 1
        {
            print("batsmanList.count........",batsmanList.count)
            cell.setInfo(players: batsmanList)
        }
        else if indexPath.section == 2
        {
            cell.setInfo(players: allRounderList)
        }
        else
        {
            cell.setInfo(players: bowlerList)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if let cell = cell as? PreviewTableViewCell{
            
            var player: Player!
            
            if indexPath.section == 0
            {
                
                for index in 0..<keeperList.count
                {
                    let firstView = cell.stackView.arrangedSubviews[index]
                    firstView.isHidden = false
                    
                    player = keeperList.item(at: index)
                    
                    if index == 0{
                        
                        if player.isCaptain {
                            
                            cell.firstCap.isHidden = false
                            cell.firstCap.text = "C"
                            //  cell.firstCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.firstCap.isHidden = false
                            cell.firstCap.text = "VC"
                            // cell.firstCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 1{
                        if player.isCaptain {
                            
                            cell.secondCap.isHidden = false
                            cell.secondCap.text = "C"
                            //   cell.secondCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.secondCap.isHidden = false
                            cell.secondCap.text = "VC"
                            //  cell.secondCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                        
                        
                    }else if index == 2{
                        if player.isCaptain {
                            
                            cell.thirdCap.isHidden = false
                            cell.thirdCap.text = "C"
                            //   cell.thirdCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.thirdCap.isHidden = false
                            cell.thirdCap.text = "VC"
                            //   cell.thirdCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 3{
                        if player.isCaptain {
                            
                            cell.fourthCap.isHidden = false
                            cell.fourthCap.text = "C"
                            //  cell.fourthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.fourthCap.isHidden = false
                            cell.fourthCap.text = "VC"
                            //  cell.fourthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 4{
                        if player.isCaptain {
                            
                            cell.fifthCap.isHidden = false
                            cell.fifthCap.text = "C"
                            //  cell.fifthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.fifthCap.isHidden = false
                            cell.fifthCap.text = "VC"
                            //   cell.fifthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 5{
                        if player.isCaptain {
                            
                            cell.sixthCap.isHidden = false
                            cell.sixthCap.text = "C"
                            //   cell.sixthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.sixthCap.isHidden = false
                            cell.sixthCap.text = "VC"
                            //    cell.sixthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }
                }
            }
            else if indexPath.section == 1
            {
                for index in 0..<batsmanList.count
                {
                    let firstView = cell.stackView.arrangedSubviews[index]
                    firstView.isHidden = false
                    
                    player = batsmanList.item(at: index)
                    
                    if index == 0{
                        
                        if player.isCaptain {
                            
                            cell.firstCap.isHidden = false
                            cell.firstCap.text = "C"
                            //   cell.firstCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.firstCap.isHidden = false
                            cell.firstCap.text = "VC"
                            //  cell.firstCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 1{
                        if player.isCaptain {
                            
                            cell.secondCap.isHidden = false
                            cell.secondCap.text = "C"
                            //    cell.secondCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.secondCap.isHidden = false
                            cell.secondCap.text = "VC"
                            //   cell.secondCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 2{
                        if player.isCaptain {
                            
                            cell.thirdCap.isHidden = false
                            cell.thirdCap.text = "C"
                            //     cell.thirdCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.thirdCap.isHidden = false
                            cell.thirdCap.text = "VC"
                            //   cell.thirdCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 3{
                        if player.isCaptain {
                            
                            cell.fourthCap.isHidden = false
                            cell.fourthCap.text = "C"
                            //    cell.fourthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.fourthCap.isHidden = false
                            cell.fourthCap.text = "VC"
                            //    cell.fourthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 4{
                        if player.isCaptain {
                            
                            cell.fifthCap.isHidden = false
                            cell.fifthCap.text = "C"
                            //     cell.fifthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.fifthCap.isHidden = false
                            cell.fifthCap.text = "VC"
                            //   cell.fifthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 5{
                        if player.isCaptain {
                            
                            cell.sixthCap.isHidden = false
                            cell.sixthCap.text = "C"
                            //     cell.sixthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.sixthCap.isHidden = false
                            cell.sixthCap.text = "VC"
                            //    cell.sixthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }
                }
            }
            else if indexPath.section == 2
            {
                for index in 0..<allRounderList.count
                {
                    let firstView = cell.stackView.arrangedSubviews[index]
                    firstView.isHidden = false
                    
                    player = allRounderList.item(at: index)
                    
                    
                    
                    if index == 0{
                        
                        if player.isCaptain {
                            
                            cell.firstCap.isHidden = false
                            cell.firstCap.text = "C"
                            //       cell.firstCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.firstCap.isHidden = false
                            cell.firstCap.text = "VC"
                            //     cell.firstCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 1{
                        if player.isCaptain {
                            
                            cell.secondCap.isHidden = false
                            cell.secondCap.text = "C"
                            //    cell.secondCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.secondCap.isHidden = false
                            cell.secondCap.text = "VC"
                            //    cell.secondCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 2{
                        if player.isCaptain {
                            
                            cell.thirdCap.isHidden = false
                            cell.thirdCap.text = "C"
                            //     cell.thirdCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.thirdCap.isHidden = false
                            cell.thirdCap.text = "VC"
                            //     cell.thirdCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 3{
                        if player.isCaptain {
                            
                            cell.fourthCap.isHidden = false
                            cell.fourthCap.text = "C"
                            //    cell.fourthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.fourthCap.isHidden = false
                            cell.fourthCap.text = "VC"
                            //    cell.fourthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 4{
                        if player.isCaptain {
                            
                            cell.fifthCap.isHidden = false
                            cell.fifthCap.text = "C"
                            //     cell.fifthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.fifthCap.isHidden = false
                            cell.fifthCap.text = "VC"
                            //      cell.fifthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 5{
                        if player.isCaptain {
                            
                            cell.sixthCap.isHidden = false
                            cell.sixthCap.text = "C"
                            //      cell.sixthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.sixthCap.isHidden = false
                            cell.sixthCap.text = "VC"
                            //      cell.sixthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }
                }
            }
            else
            {
                for index in 0..<bowlerList.count
                {
                    let firstView = cell.stackView.arrangedSubviews[index]
                    firstView.isHidden = false
                    
                    player = bowlerList.item(at: index)
                    
                    if index == 0{
                        
                        if player.isCaptain {
                            
                            cell.firstCap.isHidden = false
                            cell.firstCap.text = "C"
                            //      cell.firstCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.firstCap.isHidden = false
                            cell.firstCap.text = "VC"
                            //     cell.firstCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 1{
                        if player.isCaptain {
                            
                            cell.secondCap.isHidden = false
                            cell.secondCap.text = "C"
                            //      cell.secondCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.secondCap.isHidden = false
                            cell.secondCap.text = "VC"
                            //       cell.secondCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 2{
                        if player.isCaptain {
                            
                            cell.thirdCap.isHidden = false
                            cell.thirdCap.text = "C"
                            //       cell.thirdCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.thirdCap.isHidden = false
                            cell.thirdCap.text = "VC"
                            //        cell.thirdCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 3{
                        if player.isCaptain {
                            
                            cell.fourthCap.isHidden = false
                            cell.fourthCap.text = "C"
                            //       cell.fourthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.fourthCap.isHidden = false
                            cell.fourthCap.text = "VC"
                            //       cell.fourthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 4{
                        if player.isCaptain {
                            
                            cell.fifthCap.isHidden = false
                            cell.fifthCap.text = "C"
                            //       cell.fifthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.fifthCap.isHidden = false
                            cell.fifthCap.text = "VC"
                            //       cell.fifthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }else if index == 5{
                        if player.isCaptain {
                            
                            cell.sixthCap.isHidden = false
                            cell.sixthCap.text = "C"
                            //       cell.sixthCap.backgroundColor = UIColor.init(named: "GreenHighlight")!
                        }else if player.isViceCaptain{
                            cell.sixthCap.isHidden = false
                            cell.sixthCap.text = "VC"
                            //       cell.sixthCap.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                        }
                    }
                }
            }
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textColor = UIColor.init(named: "Bg") // my custom colour
        label.textAlignment = .center
        headerView.addSubview(label)
        
        if section == 1
        {
            label.text = "Batsman".localized.uppercased()
        }
        else if section == 2
        {
            label.text = "All rounders".localized.uppercased()
        }
        else if section == 3
        {
            label.text = "Bowlers".localized.uppercased()
        }
        else
        {
            label.text = "Wicket Keeper".localized.uppercased()
        }
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.size.height - 200)/4
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
