//
//  MyTeamViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 17/4/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class MyTeamViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var teams:[CreatedTeam] = []
    var teamsFootball:[CreatedTeamFootball] = []
    var squadData: MatchSquadData!
    var parentMatch: MatchList? = nil
    var parentMatchFootball: FootBallMatchList? = nil
    
    @IBOutlet weak var firstTeamFlag: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var secondTeamFlag: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    @IBOutlet weak var createTeamButton: UIButton!
    @IBOutlet weak var teamTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "MY TEAMS".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
        createTeamButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        
        createTeamButton.setTitle("Create Another Team".localized, for: .normal)
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            self.firstTeamName.text = self.parentMatch?.teams.item(at: 0).teamKey ?? ""
            self.secondTeamName.text = self.parentMatch?.teams.item(at: 1).teamKey ?? ""
            self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatch?.joiningLastTime ?? "" )
            
            
            self.firstTeamFlag.image = UIImage.init(named: "teamPlaceHolder_icon")
            self.secondTeamFlag.image = UIImage.init(named: "teamPlaceHolder_icon")
            
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatch?.teams.item(at: 0).logo ?? "")")
            let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatch?.teams.item(at: 1).logo ?? "")")
            self.firstTeamFlag.kf.setImage(with: url1)
            self.secondTeamFlag.kf.setImage(with: url2)
            
        }else{
            
            self.firstTeamName.text = self.parentMatchFootball?.teams.item(at: 0).code ?? ""
            self.secondTeamName.text = self.parentMatchFootball?.teams.item(at: 1).code ?? ""
            self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatchFootball?.joiningLastTime ?? "" )
            
            self.firstTeamFlag.image = UIImage.init(named: "placeholder_football_team_logo")
            self.secondTeamFlag.image = UIImage.init(named: "placeholder_football_team_logo")
            
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatchFootball?.teams.item(at: 0).logo ?? "")")
            let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatchFootball?.teams.item(at: 1).logo ?? "")")
            self.firstTeamFlag.kf.setImage(with: url1)
            self.secondTeamFlag.kf.setImage(with: url2)
            
        }
        
        if (teamTableView != nil)
        {
            teamTableView.register(UINib(nibName: "CteatedTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatedTeamCell")
            
            teamTableView.delegate = self
            teamTableView.dataSource = self
            teamTableView.removeEmptyCells()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("teams in MyTeamViewController",teams)
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            APIManager.manager.getTeamForMatch(matchId: "\(parentMatch?.matchId ?? 0)") { (status, createdTeam, msg) in
                if status{
                    
                    if createdTeam != nil{
                        self.teams = (createdTeam?.teams)!
                        
                        self.teamTableView.reloadData()
                    }
                }
                else{
                    
                    
                    // self.showStatus(status, msg: msg)
                }
            }
            
        }else{
            
            APIManager.manager.getTeamForFootballMatch(matchId: "\(parentMatchFootball?.matchId ?? 0)") { (status, createdTeam, msg) in
                if status{
                    
                    if createdTeam != nil{
                        self.teamsFootball = (createdTeam?.teams)!
                        
                        self.teamTableView.reloadData()
                    }
                }
                else{
                    
                    
                    // self.showStatus(status, msg: msg)
                }
                
            }
        }
        
        
        getSquadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("viewDidAppear in myteamview")
    }
    
    
    func getSquadData(){
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            APIManager.manager.getMatchSquad(matchId: "\(parentMatch?.matchId ?? 0)") { (status, matchSquad, msg) in
                
                print("msg.....................",msg!)
                if status{
                    if matchSquad != nil{
                        
                        self.createTeamButton.isEnabled = true
                        self.squadData = matchSquad
                        
                        print("self.squadData........",self.squadData.playersList.count)
                    }
                }
            }
        }else{
            
            APIManager.manager.getFootballMatchSquad(matchId: "\(parentMatchFootball?.matchId ?? 0)") { (status, matchSquad, msg) in
                
                print("msg.....................",msg!)
                if status{
                    if matchSquad != nil{
                        
                        self.createTeamButton.isEnabled = true
                        self.squadData = matchSquad
                        
                        print("self.squadData........",self.squadData.playersList.count)
                    }
                }
            }
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            return teams.count
        }else{
            return teamsFootball.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"CreatedTeamCell") as! CteatedTableViewCell
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            let singleTeam = teams[indexPath.section] as CreatedTeam
            
            
            cell.keeperLabel.text = "WK"
            cell.batsmanLabel.text = "BAT"
            cell.allrounderLabel.text = "AL"
            cell.bowlerLabel.text = "BOWL"
            
            cell.setInfo(singleTeam)
            
            cell.editButton.tag = singleTeam.userTeamId!
            cell.previewButton.tag = singleTeam.userTeamId!
            
        }else{
            
            let singleTeam = teamsFootball[indexPath.section] as CreatedTeamFootball
            
            cell.keeperLabel.text = "GK"
            cell.batsmanLabel.text = "DEF"
            cell.allrounderLabel.text = "MID"
            cell.bowlerLabel.text = "STR"
            
            cell.setInfoFootball(singleTeam)
            
            cell.editButton.tag = singleTeam.userTeamId!
            cell.previewButton.tag = singleTeam.userTeamId!
            
        }
        
        
        
        cell.previewButton.addTarget(self, action: #selector(showPreview(_:)), for: .touchUpInside)
        
        cell.editButton.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    @IBAction func createNewTeam(_ sender: Any) {
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamCreateViewController") as? TeamCreateViewController
            
            popupVC?.squadData = squadData
            popupVC?.timeLeft = self.parentMatch?.joiningLastTime
            
            self.navigationController?.pushViewController(popupVC ?? self, animated: true)
            
        }else{
            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamCreateFootballViewController") as? TeamCreateFootballViewController
            
            popupVC?.squadData = squadData
            popupVC?.timeLeft = self.parentMatchFootball?.joiningLastTime
            
            self.navigationController?.pushViewController(popupVC ?? self, animated: true)
            
        }
    }
    
    @objc func showPreview(_ sender: UIButton){
        
        print("showPreview button action MyTeamViewController")
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            let popupVC:TeamPreviewViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamPreviewViewController") as? TeamPreviewViewController)!
            
            
            popupVC.pvSquadData = squadData
            popupVC.userTeamId = sender.tag
            popupVC.isAlreadyCreatedTeam = true
            
            self.navigationController?.pushViewController(popupVC, animated: true)
        }else{
            
            let popupVC:TeamPreviewFootballViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamPreviewFootballViewController") as? TeamPreviewFootballViewController)!
            
            
            popupVC.pvSquadData = squadData
            popupVC.userTeamId = sender.tag
            popupVC.isAlreadyCreatedTeam = true
            
            self.navigationController?.pushViewController(popupVC, animated: true)
            
        }
        
    }
    
    
    
    @objc func editButtonAction(_ sender: UIButton){
        
        print("editButtonAction button action MyTeamViewController")
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            let popupVC:EditTeamViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditTeamViewController") as? EditTeamViewController)!
            
            
            popupVC.squadData = squadData
            popupVC.userTeamId = sender.tag
            popupVC.timeLeft = self.parentMatch?.joiningLastTime
            
            
            self.navigationController?.pushViewController(popupVC, animated: true)
            
        }else{
            
            let popupVC:EditTeamFootballViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditTeamFootballViewController") as? EditTeamFootballViewController)!
            
            
            popupVC.squadData = squadData
            popupVC.userTeamId = sender.tag
            popupVC.timeLeft = self.parentMatchFootball?.joiningLastTime
            
            
            self.navigationController?.pushViewController(popupVC, animated: true)
            
        }
    }
    
    //    func joiningLastTime(matchTime: String, join_ends_before: Int) -> String{
    //        
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //        let dateFromString :Date = dateFormatter.date(from: matchTime)!
    //        
    //        let date = dateFromString.addingTimeInterval(TimeInterval(-(join_ends_before * 60)))
    //        
    //        let sttringFDate = date.toDateString(format: "yyyy-MM-dd HH:mm:ss")
    //        
    //        return sttringFDate.serverTimetoDateString()
    //        
    //    }
    
}
