//
//  CaptainSelectorViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 1/4/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class CaptainSelectorViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var userTeam : UsersFantasyTeam!
    var squadData : MatchSquadData!
    
    var currentCaptain : Player!
    var currentViceCaptain : Player!
    
    var currentFantasyCaptain : UserFantasyPlayer!
    var currentFantasyViceCaptain : UserFantasyPlayer!
    
    
    var batsmanList:[Player] = []
    var bowlerList:[Player] = []
    var keeperList:[Player] = []
    var allRounderList:[Player] = []
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamPlayerListView: UITableView!
    
    @IBOutlet weak var saveTeamButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        placeNavBar(withTitle: "Create Your Team", isBackBtnVisible: true)
        saveTeamButton.makeRound(5, borderWidth: 0, borderColor: .clear)
       
        // Do any additional setup after loading the view.
        squadData.playersList = squadData.playersList.filter{($0 as Player).playerSelected == true }
        print(userTeam)
        
        if squadData != nil
        {
            for player in squadData.playersList
            {
                
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
        
        teamPlayerListView.delegate = self
        teamPlayerListView.dataSource = self
        teamPlayerListView.removeEmptyCells()
        
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
            return 1;
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
        
        cell.setInfo(player: player,squad: squadData.teams!)
        
        cell.captainButton.tag = (indexPath.section * 100 + indexPath.row)
        cell.viceCaptainButton.tag = (indexPath.section * 100 + indexPath.row)
        
        cell.captainButton.addTarget(self, action: #selector(setCaptain(_:)), for: .touchUpInside)
        cell.viceCaptainButton.addTarget(self, action: #selector(setViceCaptain(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 1
        {
            return "Batsman"
        }
        else if section == 2
        {
            return "All rounders"
        }
        else if section == 3
        {
            return "Bowlers"
        }
        else
        {
            return "Wicket Keeper"
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20;
    }
    
    @objc func setCaptain(_ sender: UIButton){
        
        let section = sender.tag/100
        let row = sender.tag % 10
        
        var player: Player!
        var userFantasyPlayer : UserFantasyPlayer!
        
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
        
        player.isViceCaptain = false
        player.isCaptain = true
        
        userFantasyPlayer.isViceCaptain = 0
        userFantasyPlayer.isCaptain = 1
        
        if currentCaptain != nil && currentCaptain.playerId != player.playerId
        {
            currentCaptain.isCaptain = false
            currentCaptain = player
        }
        else
        {
            currentCaptain = player
        }
        
        if currentFantasyCaptain != nil && currentFantasyCaptain.id != userFantasyPlayer.id
        {
            currentFantasyCaptain.isCaptain = 0
            currentFantasyCaptain = userFantasyPlayer
        }
        else
        {
            currentFantasyCaptain = userFantasyPlayer
        }
        
        userTeam.captain = player.playerId
        teamPlayerListView.reloadData()
    }
    
    @objc func setViceCaptain(_ sender: UIButton){
       
        let section = sender.tag/100
        let row = sender.tag % 10
        
        var player: Player!
        
        var userFantasyPlayer : UserFantasyPlayer!
        
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
        
        
        if currentViceCaptain != nil && currentViceCaptain.playerId != player.playerId
        {
            currentViceCaptain.isViceCaptain = false
            currentViceCaptain = player
        }
        else
        {
            currentViceCaptain = player
        }
        
        if currentFantasyViceCaptain != nil && currentFantasyViceCaptain.id != userFantasyPlayer.id
        {
            currentFantasyViceCaptain.isViceCaptain = 0
            currentFantasyViceCaptain = userFantasyPlayer
        }
        else
        {
            currentFantasyViceCaptain = userFantasyPlayer
        }
        
        userTeam.viceCaptain = player.playerId
        
        teamPlayerListView.reloadData()
    }

    @IBAction func saveTeamAction(_ sender: Any) {
        
        if (userTeam.captain ?? 0 <= 0)
        {
            self.showStatus(false, msg: String.init(format: "Please select a captain" ))
            
        }
        else  if (userTeam.viceCaptain ?? 0 <= 0)
        {
            self.showStatus(false, msg: String.init(format: "Please select a vice captain" ))
            
        }
        else if self.teamNameTextField.text?.count ?? 0 > 0
        {
            userTeam.teamName = self.teamNameTextField.text
            
            APIManager.manager.postTeam(params: userTeam) { (status, msg) in

                self.showStatus(status, msg: msg)
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
                }

            }
        }
        else
        {
            self.showStatus(false, msg: String.init(format: "Please provide a name for your team" ))
            
            //print(userTeam.batsman.toJSONArray())
            //print(userTeam.bowler.toJSONArray())
            //print(userTeam.allrounder.toJSONArray())
           
        }
        
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
