//
//  CaptainSelectorViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 1/4/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

import Mixpanel

class CaptainSelectorViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var userTeam : UsersFantasyTeam!
    var nextsquadData : MatchSquadData!
    
    
    var selectedPlayerList:[Player] = []
    var batsmanList:[Player] = []
    var bowlerList:[Player] = []
    var keeperList:[Player] = []
    var allRounderList:[Player] = []
    
    
    var currentCaptain : Player!
    var currentViceCaptain : Player!
    
    var currentFantasyCaptain : UserFantasyPlayer!
    var currentFantasyViceCaptain : UserFantasyPlayer!
    
    //if comes from edit view
    var isFromEdit = false
    var userTeamId = 0
    var userTeamName = ""
    
    var timeLeft : String!
    
    @IBOutlet weak var chooseCaptainLabel: UILabel!
    @IBOutlet weak var xPointLabel: UILabel!
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamPlayerListView: UITableView!
    
    @IBOutlet weak var saveTeamButton: UIButton!
    @IBOutlet weak var navTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //        placeNavBar(withTitle: "Create Your Team", isBackBtnVisible: true)
        navTitle.text = String.init(format: "%@ Left".localized,timeLeft ?? "" )
        
        chooseCaptainLabel.text = "CHOOSE CAPTAIN (C) & VICE CAPTAIN (VC)".localized
        xPointLabel.text = "Your Captain gets 2x points & Vice Captain gets 1.5x points".localized
        //teamNameTextField.placeholder = "Your Team Name".localized
        saveTeamButton.setTitle("Save Your Team".localized, for: .normal)
       // teamNameTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
       // teamNameTextField.delegate = self
        
        
        saveTeamButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        saveTeamButton.layer.shadowColor = UIColor.gray.cgColor
        saveTeamButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        saveTeamButton.layer.shadowRadius = 2
        saveTeamButton.layer.shadowOpacity = 0.5
        saveTeamButton.layer.masksToBounds = false
        
        selectedPlayerList = nextsquadData.playersList.filter{($0 as Player).playerSelected == true }
        
        
        
        if selectedPlayerList.count != 0
        {
            for player in selectedPlayerList
            {
                print("selectedPlayerList player.isCaptain",player.isCaptain)
                print("selectedPlayerList isViceCaptain.....",player.isViceCaptain)
                
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
                
                //Check if any captain or vice captain selected earlier or edit
                
                if player.isCaptain{
                    
                    currentCaptain = player
                    userTeam.captain = player.playerId
                    
                }
                if player.isViceCaptain{
                    
                    currentViceCaptain = player
                    userTeam.viceCaptain = player.playerId
                }
                
                //if comes from edit view
//                if isFromEdit{
//
//                    self.teamNameTextField.text = userTeamName
//
//                }
            }
        }
        
        teamPlayerListView.delegate = self
        teamPlayerListView.dataSource = self
        teamPlayerListView.removeEmptyCells()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13, *) {
                  if UserDefaults.standard.bool(forKey: "DarkMode"){
                      
                      overrideUserInterfaceStyle = .dark
                      self.tabBarController?.tabBar.backgroundColor = UIColor.init(named: "tab_dark_bg")
                      self.tabBarController?.tabBar.unselectedItemTintColor = .white

                  }else{
                      overrideUserInterfaceStyle = .light
                  }
              
              }else{
                  
              }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1
        {
            return batsmanList.count;
        }
        else if section == 2
        {
            return allRounderList.count;
        }
        else if section == 3
        {
            return bowlerList.count;
        }
        else
        {
            return keeperList.count;
        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"captainCell") as! TeamPlayerTableViewCell
        
        var player: Player!
        
        if indexPath.section == 0
        {
            player = keeperList[indexPath.row]
        }
        else if indexPath.section == 1
        {
            player = batsmanList[indexPath.row]
        }
        else if indexPath.section == 2
        {
            player = allRounderList[indexPath.row]
        }
        else
        {
            player = bowlerList[indexPath.row]
        }
        
        print("player.isViceCaptain.......... ",player.isViceCaptain)
        print("player.isCaptain............ ",player.isCaptain)
        
        cell.setInfo(player: player,squad: nextsquadData.teams!)
        
        cell.captainButton.tag = (indexPath.section * 100 + indexPath.row)
        cell.viceCaptainButton.tag = (indexPath.section * 100 + indexPath.row)
        
        cell.captainButton.addTarget(self, action: #selector(setCaptain(_:)), for: .touchUpInside)
        cell.viceCaptainButton.addTarget(self, action: #selector(setViceCaptain(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? TeamPlayerTableViewCell{
            
            var player: Player!
            
            if indexPath.section == 0
            {
                player = keeperList[indexPath.row]
            }
            else if indexPath.section == 1
            {
                player = batsmanList[indexPath.row]
            }
            else if indexPath.section == 2
            {
                player = allRounderList[indexPath.row]
            }
            else
            {
                player = bowlerList[indexPath.row]
            }
            
            if player.teamBelong == 1{
                cell.teamNamelabel.textColor = UIColor.init(named: "on_green")!
            }else{
                cell.teamNamelabel.textColor = UIColor.init(named: "brand_orange")!
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        //        if section == 1
        //        {
        //            return "Batsman"
        //        }
        //        else if section == 2
        //        {
        //            return "All rounders"
        //        }
        //        else if section == 3
        //        {
        //            return "Bowlers"
        //        }
        //        else
        //        {
        //            return "Wicket Keeper"
        //        }
        return ""
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        guard let textFieldText = textField.text,
        //            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
        //                return false
        //        }
        //        let substringToReplace = textFieldText[rangeOfTextToReplace]
        //        let count = textFieldText.count - substringToReplace.count + string.count
        //
        //        return count <= 24
        
        if range.location > 24 - 1 {
            textField.text?.removeLast()
            let alertVC = UIAlertController(title: nil, message: "Maximum 24 Character".localized, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (aciton) in
                
                // self.dismiss(animated: true, completion: nil)
                
                // self.teamNameTextField.resignFirstResponder()
            })
            
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            
            
        }
        
        return true
    }
    
    
    
    //            let alertVC = UIAlertController(title: nil, message: "Maximum 24 Character".localized, preferredStyle: .alert)
    //            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (aciton) in
    //
    //               // self.dismiss(animated: true, completion: nil)
    //
    //               // self.teamNameTextField.resignFirstResponder()
    //            })
    //
    //            alertVC.addAction(okAction)
    //            self.present(alertVC, animated: true, completion: nil)
    
    //    self.view.makeToast("Maximum 24 Character".localized)
    
    
    
    @objc func setCaptain(_ sender: UIButton){
        
        
        let section = sender.tag/100
        let row = sender.tag % 10
        
        var player: Player!
        var userFantasyPlayer : UserFantasyPlayer! // for user team
        
        
        //        if isFromEdit{
        //
        //            for singlePlayer in userTeam.keeper{
        //
        //                if singlePlayer.isCaptain == 1{
        //
        //                    singlePlayer.isCaptain = 0
        //
        //                    print("singlePlayer.isCaptain",singlePlayer.isCaptain)
        //                }
        //
        //            }
        //
        //            for singlePlayer in userTeam.batsman{
        //
        //                if singlePlayer.isCaptain == 1{
        //
        //                    singlePlayer.isCaptain = 0
        //
        //                    print("singlePlayer.isCaptain",singlePlayer.isCaptain)
        //                }
        //
        //            }
        //
        //            for singlePlayer in userTeam.allrounder{
        //
        //                if singlePlayer.isCaptain == 1{
        //
        //                    singlePlayer.isCaptain = 0
        //
        //                    print("singlePlayer.isCaptain",singlePlayer.isCaptain)
        //                }
        //            }
        //
        //            for singlePlayer in userTeam.bowler{
        //
        //                if singlePlayer.isCaptain == 1{
        //
        //                    singlePlayer.isCaptain = 0
        //
        //                    print("singlePlayer.isCaptain",singlePlayer.isCaptain)
        //                }
        //
        //            }
        //        }
        
        
        // change the player state in user team
        if section == 0
        {
            player = keeperList[row]
            userFantasyPlayer =  userTeam.keeper.item(at: row)
            
        }
        else if section == 1
        {
            player = batsmanList[row]
            userFantasyPlayer =  userTeam.batsman.item(at: row)
        }
        else if section == 2
        {
            player = allRounderList[row]
            userFantasyPlayer =  userTeam.allrounder.item(at: row)
        }
        else
        {
            player = bowlerList[row]
            userFantasyPlayer =  userTeam.bowler.item(at: row)
        }
        
        //*****************
        
        
        player.isViceCaptain = false
        player.isCaptain = true
        
        userFantasyPlayer.isViceCaptain = 0
        userFantasyPlayer.isCaptain = 1
        
        userTeam.captain = player.playerId
        
        if userTeam.captain == userTeam.viceCaptain{
            userTeam.viceCaptain = 0
        }
        
        print("player.playerId......in  captain",player.playerId,player.isCaptain,player.isViceCaptain)
        
        // change status for main squad
        if currentCaptain != nil && currentCaptain.playerId != player.playerId
        {
            //  print("currentCaptain.isCaptain.......id.",currentCaptain.playerId,  player.playerId)
            currentCaptain.isCaptain = false
            currentCaptain = player
            
            //  print("currentCaptain.isCaptain........",currentCaptain.isCaptain)
        }
        else
        {
            currentCaptain = player
            // print("currentCaptain.isCaptain",currentCaptain.isCaptain)
        }
        
        //check if there is any captain in user team
        //        if currentFantasyCaptain != nil && currentFantasyCaptain.id != userFantasyPlayer.id
        //        {
        //
        //            currentFantasyCaptain.isCaptain = 0
        //            currentFantasyCaptain = userFantasyPlayer
        //        }
        //        else
        //        {
        //            currentFantasyCaptain = userFantasyPlayer
        //        }
        
        
        
        
        //remove other captain from squad
        removeOtherCaptain(id: userTeam.captain)
        
        
        
        
        
        //        //For double check
        //        for userFanPlayer in userTeam.keeper{
        //
        //            if userFanPlayer.id == currentCaptain.playerId{
        //
        //                userFanPlayer.isCaptain = 1
        //                userFanPlayer.isViceCaptain = 0
        //            }
        //            print("userFanPlayer .in  captain",userFanPlayer.id,userFanPlayer.isViceCaptain,userFanPlayer.isCaptain)
        //        }
        //        for userFanPlayer in userTeam.batsman{
        //
        //            if userFanPlayer.id == currentCaptain.playerId{
        //
        //                userFanPlayer.isCaptain = 1
        //                userFanPlayer.isViceCaptain = 0
        //            }
        //            print("userFanPlayer .in  captain",userFanPlayer.id,userFanPlayer.isViceCaptain,userFanPlayer.isCaptain)
        //        }
        //        for userFanPlayer in userTeam.bowler{
        //
        //            if userFanPlayer.id == currentCaptain.playerId{
        //
        //                userFanPlayer.isCaptain = 1
        //                userFanPlayer.isViceCaptain = 0
        //            }
        //            print("userFanPlayer .in  captain",userFanPlayer.id,userFanPlayer.isViceCaptain,userFanPlayer.isCaptain)
        //        }
        //
        //        for userFanPlayer in userTeam.allrounder{
        //
        //            if userFanPlayer.id == currentCaptain.playerId{
        //
        //                userFanPlayer.isCaptain = 1
        //                userFanPlayer.isViceCaptain = 0
        //            }
        //            print("userFanPlayer .in  captain",userFanPlayer.id,userFanPlayer.isViceCaptain,userFanPlayer.isCaptain)
        //        }
        
        teamPlayerListView.reloadData()
        
        
    }
    
    func removeOtherCaptain(id:Int?) {
        
        for singlaPlayer in userTeam.keeper{
            
            if singlaPlayer.id == id{
                
                print("same id for captain keeper")
                singlaPlayer.isCaptain = 1
                
            }
            else{
                
                singlaPlayer.isCaptain = 0
            }
        }
        
        for singlaPlayer in userTeam.batsman{
            
            if singlaPlayer.id == id{
                print("same id for captain batsman")
                singlaPlayer.isCaptain = 1
            }
            else{
                
                singlaPlayer.isCaptain = 0
            }
        }
        for singlaPlayer in userTeam.allrounder{
            
            if singlaPlayer.id == id{
                print("same id for captain allroun")
                singlaPlayer.isCaptain = 1
            }
            else{
                
                singlaPlayer.isCaptain = 0
            }
        }
        for singlaPlayer in userTeam.bowler{
            
            if singlaPlayer.id == id{
                print("same id for captain bowler")
                singlaPlayer.isCaptain = 1
            }
            else{
                
                singlaPlayer.isCaptain = 0
            }
        }
        
    }
    
    @objc func setViceCaptain(_ sender: UIButton){
        
        let section = sender.tag/100
        let row = sender.tag % 10
        
        var player: Player!
        
        var userFantasyPlayer : UserFantasyPlayer!
        
        
        //        if isFromEdit{
        //
        //            for singlePlayer in userTeam.keeper{
        //
        //                if singlePlayer.isViceCaptain == 1{
        //
        //                    singlePlayer.isViceCaptain = 0
        //
        //                    print("singlePlayer.isCaptain",singlePlayer.isViceCaptain)
        //                }
        //
        //            }
        //
        //            for singlePlayer in userTeam.batsman{
        //
        //                if singlePlayer.isViceCaptain == 1{
        //
        //                    singlePlayer.isViceCaptain = 0
        //
        //                    print("singlePlayer.isCaptain",singlePlayer.isViceCaptain)
        //                }
        //
        //            }
        //
        //            for singlePlayer in userTeam.allrounder{
        //
        //                if singlePlayer.isViceCaptain == 1{
        //
        //                    singlePlayer.isViceCaptain = 0
        //
        //                    print("singlePlayer.isCaptain",singlePlayer.isViceCaptain)
        //                }
        //            }
        //
        //            for singlePlayer in userTeam.bowler{
        //
        //                if singlePlayer.isViceCaptain == 1{
        //
        //                    singlePlayer.isViceCaptain = 0
        //
        //                    print("singlePlayer.isCaptain",singlePlayer.isViceCaptain)
        //                }
        //
        //            }
        //        }
        
        
        
        if section == 0
        {
            player = keeperList[row]
            userFantasyPlayer =  userTeam.keeper.item(at: row)
        }
        else if section == 1
        {
            player = batsmanList[row]
            userFantasyPlayer =  userTeam.batsman.item(at: row)
        }
        else if section == 2
        {
            player = allRounderList[row]
            userFantasyPlayer =  userTeam.allrounder.item(at: row)
        }
        else
        {
            player = bowlerList[row]
            userFantasyPlayer =  userTeam.bowler.item(at: row)
        }
        
        player.isViceCaptain = true
        player.isCaptain = false
        
        userFantasyPlayer.isViceCaptain = 1
        userFantasyPlayer.isCaptain = 0
        
        userTeam.viceCaptain = player.playerId
        
        if userTeam.captain == userTeam.viceCaptain{
            userTeam.captain = 0
        }
        
        print("player.playerId......in vice captain",player.playerId,player.isViceCaptain,player.isCaptain)
        
        if currentViceCaptain != nil && currentViceCaptain.playerId != player.playerId
        {
            currentViceCaptain.isViceCaptain = false
            currentViceCaptain = player
        }
        else
        {
            currentViceCaptain = player
        }
        
        //        if currentFantasyViceCaptain != nil && currentFantasyViceCaptain.id != userFantasyPlayer.id
        //        {
        //            currentFantasyViceCaptain.isViceCaptain = 0
        //            currentFantasyViceCaptain = userFantasyPlayer
        //        }
        //        else
        //        {
        //            currentFantasyViceCaptain = userFantasyPlayer
        //        }
        
        removeOtherViceCaptain(id: userTeam.viceCaptain)
        
        
        //For double check
        //        for userFanPlayer in userTeam.keeper{
        //
        //            if userFanPlayer.id == currentViceCaptain.playerId{
        //
        //                userFanPlayer.isCaptain = 0
        //                userFanPlayer.isViceCaptain = 1
        //            }
        //            print("userFanPlayer .in  captain",userFanPlayer.id,userFanPlayer.isViceCaptain,userFanPlayer.isCaptain)
        //        }
        //        for userFanPlayer in userTeam.batsman{
        //
        //            if userFanPlayer.id == currentViceCaptain.playerId{
        //
        //                userFanPlayer.isCaptain = 0
        //                userFanPlayer.isViceCaptain = 1
        //            }
        //            print("userFanPlayer .in  captain",userFanPlayer.id,userFanPlayer.isViceCaptain,userFanPlayer.isCaptain)
        //        }
        //        for userFanPlayer in userTeam.bowler{
        //
        //            if userFanPlayer.id == currentViceCaptain.playerId{
        //
        //                userFanPlayer.isCaptain = 0
        //                userFanPlayer.isViceCaptain = 1
        //            }
        //            print("userFanPlayer .in  captain",userFanPlayer.id,userFanPlayer.isViceCaptain,userFanPlayer.isCaptain)
        //        }
        //        for userFanPlayer in userTeam.allrounder{
        //
        //            if userFanPlayer.id == currentViceCaptain.playerId{
        //
        //                userFanPlayer.isCaptain = 0
        //                userFanPlayer.isViceCaptain = 1
        //            }
        //            print("userFanPlayer .in  captain",userFanPlayer.id,userFanPlayer.isViceCaptain,userFanPlayer.isCaptain)
        //        }
        
        teamPlayerListView.reloadData()
        
    }
    
    func removeOtherViceCaptain(id:Int?) {
        
        for singlaPlayer in userTeam.keeper{
            
            if singlaPlayer.id == id{
                print("same id for ViceCaptain keeper")
                singlaPlayer.isViceCaptain = 1
                
            }
            else{
                
                singlaPlayer.isViceCaptain = 0
            }
        }
        
        for singlaPlayer in userTeam.batsman{
            
            if singlaPlayer.id == id{
                print("same id for ViceCaptain batsman")
                singlaPlayer.isViceCaptain = 1
            }
            else{
                
                singlaPlayer.isViceCaptain = 0
            }
        }
        for singlaPlayer in userTeam.allrounder{
            
            if singlaPlayer.id == id{
                print("same id for ViceCaptain allroun")
                singlaPlayer.isViceCaptain = 1
            }
            else{
                
                singlaPlayer.isViceCaptain = 0
            }
        }
        for singlaPlayer in userTeam.bowler{
            
            if singlaPlayer.id == id{
                
                print("same id for ViceCaptain bowler")
                singlaPlayer.isViceCaptain = 1
                
            }
            else{
                
                singlaPlayer.isViceCaptain = 0
            }
        }
    }
    
    @IBAction func saveTeamAction(_ sender: Any) {
        
        print("captain and vice cap id in save team",userTeam.captain,userTeam.viceCaptain)
        
        
        if (userTeam.captain ?? 0 <= 0)
        {
            self.view.makeToast("You Must Select a Captain".localized)
        }
        else  if (userTeam.viceCaptain ?? 0 <= 0)
        {
            
            self.view.makeToast("You Must Select a Vice Captain".localized)
            
        }else if userTeam.captain == userTeam.viceCaptain{
            
            self.view.makeToast("Please select Captain and Vice Captain properly".localized)
        }
        else
//        if teamNameTextField.text!.count > 25{
//
//            self.view.makeToast("Maximum 24 Character".localized)
//        }
//        else if self.teamNameTextField.text?.count ?? 0 > 0
        {
           // userTeam.teamName = self.teamNameTextField.text
            
            print("captain and vice cap id........",userTeam.captain,userTeam.viceCaptain)
            
            
            //For double check/ set captain again
            
            for singlaPlayer in userTeam.keeper{
                
                if singlaPlayer.id == userTeam.captain{
                    
                    print("same id for captain keeper........")
                    singlaPlayer.isCaptain = 1
                    singlaPlayer.isViceCaptain = 0
                }
                
            }
            
            for singlaPlayer in userTeam.batsman{
                
                if singlaPlayer.id == userTeam.captain{
                    print("same id for captain batsman.........")
                    singlaPlayer.isCaptain = 1
                    singlaPlayer.isViceCaptain = 0
                }
                
            }
            for singlaPlayer in userTeam.allrounder{
                
                if singlaPlayer.id == userTeam.captain{
                    print("same id for captain allroun........")
                    singlaPlayer.isCaptain = 1
                    singlaPlayer.isViceCaptain = 0
                }
                
            }
            for singlaPlayer in userTeam.bowler{
                
                if singlaPlayer.id == userTeam.captain{
                    print("same id for captain bowler........")
                    singlaPlayer.isCaptain = 1
                    singlaPlayer.isViceCaptain = 0
                }
                
            }
            
            //For double check/ set Vicecaptain again
            
            for singlaPlayer in userTeam.keeper{
                
                if singlaPlayer.id == userTeam.viceCaptain{
                    
                    print("same id for vicecaptain keeper.........")
                    singlaPlayer.isCaptain = 0
                    singlaPlayer.isViceCaptain = 1
                }
                
            }
            
            for singlaPlayer in userTeam.batsman{
                
                if singlaPlayer.id == userTeam.viceCaptain{
                    print("same id for vicecaptain batsman........")
                    singlaPlayer.isCaptain = 0
                    singlaPlayer.isViceCaptain = 1
                }
                
            }
            for singlaPlayer in userTeam.allrounder{
                
                if singlaPlayer.id == userTeam.viceCaptain{
                    print("same id for vicecaptain allroun..........")
                    singlaPlayer.isCaptain = 0
                    singlaPlayer.isViceCaptain = 1
                }
                
            }
            for singlaPlayer in userTeam.bowler{
                
                if singlaPlayer.id == userTeam.viceCaptain{
                    print("same id for vicecaptain bowler........")
                    singlaPlayer.isCaptain = 0
                    singlaPlayer.isViceCaptain = 1
                }
                
            }
            
            
        }
            
            
            
            if isFromEdit{
                
                //print("userTeam.toJSON()..........saveTeamAction.",userTeam.toJSON())
                
                
                APIManager.manager.postEditedTeam(team: userTeam, teamId: String(describing: userTeamId)) { (status, msg) in
                    
                    //    print("msg...........",msg)
                    self.view.makeToast(msg!)
                    
                    if status{
                        
                        if (self.navigationController != nil)
                        {
                            if self.isFromEdit{
                                
                                if let destinationViewController = self.navigationController?.viewControllers
                                    .filter(
                                        {$0.classForCoder == MyTeamViewController.self})
                                    .first {
                                    self.navigationController?.popToViewController(destinationViewController, animated: true)
                                }
                            }
                            else
                            {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            
                        }
                        else
                        {
                            self.dismiss(animated: true) {
                                print("Dismiss")
                            }
                        }
                    }
                }
            }else{
                
                //     print("userTeam.captain ",userTeam.captain,userTeam.viceCaptain)
                
                
                APIManager.manager.postTeam(params: userTeam) { (status, msg) in
                    self.view.makeToast(msg!)
                    
                    if status{
                        
                        if (self.navigationController != nil)
                        {
                            self.navigationController?.popToRootViewController(animated: true)
                            
                        }
                        else
                        {
                            self.dismiss(animated: true) {
                                print("Dismiss")
                            }
                        }
                        
                        let p: Properties = ["match_id": self.userTeam.matchId ?? ""]
                        Mixpanel.mainInstance().track(event: "team_created_cricket", properties: p)// set team_created_cricket event in mixpanel
                       
                        
                    }
                    
                }
                
            }
        
        
//        else
//        {
//
//            self.view.makeToast("Please provide a name for your team".localized)
//            //print(userTeam.batsman.toJSONArray())
//            //print(userTeam.bowler.toJSONArray())
//            //print(userTeam.allrounder.toJSONArray())
//
//        }
        
    }
    

    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
