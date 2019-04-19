//
//  ContestListViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 5/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class ContestListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var activeContestList:[ContestData] = []
    var squadData: MatchSquadData!
    var createdTeamList: [CreatedTeam] = []
    
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var firstTeamFlag: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var secondTeamFlag: UIImageView!
    
    
    
    @IBOutlet weak var contestTableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var matchSummaryView: UIView!
    
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var teamCount: UILabel!
    @IBOutlet weak var contestCount: UILabel!
    
    
    
    var parentMatch: MatchList? = nil
    var type : MatchType = .upcomingContest
    
    var contest_id = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeNavBar(withTitle: "Contests", isBackBtnVisible: true)
        
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
        nextButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        
        contestTableView.register(UINib(nibName: "ContestTableViewCell", bundle: nil), forCellReuseIdentifier: "contestCell")
        
        contestTableView.delegate = self
        contestTableView.dataSource = self
        contestTableView.removeEmptyCells()
        
        
        if type == .upcomingContest || type == .liveContest || type == .completedContest {
            
            APIManager.manager.getJoinedActiveContestList(matchId: "\(parentMatch?.matchId ?? 0)") { (status, cm, msg) in
                if status{
                    if cm != nil{
                        
                        // self.fill(u)
                        self.activeContestList = (cm?.contests)!
                        self.contestTableView.reloadData()
                    }
                }
                else{
                    self.showStatus(status, msg: msg)
                }
            }
        }else{
            
            APIManager.manager.getActiveContestList(matchId: "\(parentMatch?.matchId ?? 0)") { (status, cm, msg) in
                if status{
                    if cm != nil{
                        
                        // self.fill(u)
                        self.activeContestList = (cm?.contests)!
                        self.contestTableView.reloadData()
                    }
                }
                else{
                    self.showStatus(status, msg: msg)
                }
            }

        }
        self.firstTeamName.text = self.parentMatch?.teams.item(at: 0).teamKey ?? ""
        self.secondTeamName.text = self.parentMatch?.teams.item(at: 1).teamKey ?? ""
        self.statusLabel.text = String.init(format: "Ends: %@",self.parentMatch?.joiningLastTime ?? "" )
        
        
        
        let url1 = URL(string: "\(API_K.BaseUrlStr)\(self.parentMatch?.teams.item(at: 0).logo ?? "")")
        let url2 = URL(string: "\(API_K.BaseUrlStr)\(self.parentMatch?.teams.item(at: 1).logo ?? "")")
        self.firstTeamFlag.kf.setImage(with: url1)
        self.secondTeamFlag.kf.setImage(with: url2)

        
        print("AppSessionManager.shared.authToken ",AppSessionManager.shared.authToken ?? "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
        if type == .next {
            
            print("type ..",type)
            
            APIManager.manager.getMatchSquad(matchId: "\(parentMatch?.matchId ?? 0)") { (status, matchSquad, msg) in
                if status{
                    if matchSquad != nil{
                      
                        self.nextButton.isEnabled = true
                        self.squadData = matchSquad
                    }
                }
                else{
                    self.showStatus(status, msg: msg)
                }
            }
            
            
            APIManager.manager.getTeamForMatch(matchId: "\(parentMatch?.matchId ?? 0)") { (status, createdTeam, msg) in
                if status{
                    
                    if createdTeam != nil{
                        self.createdTeamList = (createdTeam?.teams)!
                        
                        if self.createdTeamList.count > 0
                        {
                            self.stateView.isHidden = false
                            self.nextButton.isHidden = true
                            
                            self.teamCount.text = String.init(format: "%d\nCreated Team",self.createdTeamList.count)
                        }
                        
                    }
                }
                else{
                    self.showStatus(status, msg: msg)
                }
            }
        }
        else
        {
            self.footerView.isHidden = true

        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return activeContestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"contestCell") as! ContestTableViewCell
        
        let contest = activeContestList[indexPath.section]
        cell.setInfo(contest)
    
        cell.joinedButton.tag = contest.id ?? 0
        cell.joinedButton.addTarget(self, action: #selector(teamSelectAction(_:)), for: .touchUpInside)
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        print("didSelectRowAt ",self.tabBarController?.selectedIndex)
    
        if  type == .next
        {
            if self.createdTeamList.count > 0
            {
                
            }
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let VC = storyboard.instantiateViewController(withIdentifier: "ContestLeaderBoardViewController") as! ContestLeaderBoardViewController
            
            let contest = activeContestList[indexPath.section]
            
            print("parentMatch?.matchId",parentMatch?.matchId ?? 0)
            
            VC.contest_id = contest.id
            VC.match_id = parentMatch?.matchId
            
            // self.navigationController?.pushViewController(VC, animated: true)
            
            self.present(VC, animated: true) {
                
                print("open")
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
        
    }
    @IBAction func teamCreateAction(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamCreateViewController") as? TeamCreateViewController
        
        popupVC?.modalPresentationStyle = .overCurrentContext
        popupVC?.modalTransitionStyle = .crossDissolve
        popupVC?.squadData = squadData 
        
        self.navigationController?.pushViewController(popupVC ?? self, animated: true)
        
//        self.present(popupVC!, animated: true) {
//            print("")
//        }
    }
    @IBAction func teamSelectAction(_ sender: UIButton) {
       
        if self.createdTeamList.count > 0
        {
            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
            
            popupVC?.modalPresentationStyle = .overCurrentContext
            popupVC?.modalTransitionStyle = .crossDissolve
            popupVC?.teams = self.createdTeamList
            popupVC?.contestId = sender.tag
            
            self.present(popupVC!, animated: true) {
                print("")
            }
        }
        
        
       
    }
    
    @IBAction func teamEditAction(_ sender: Any) {
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyTeamViewController") as? MyTeamViewController
        
        popupVC?.modalPresentationStyle = .overCurrentContext
        popupVC?.modalTransitionStyle = .crossDissolve
        popupVC?.teams = self.createdTeamList
        popupVC?.squadData = squadData
        popupVC?.parentMatch = parentMatch
        
        self.present(popupVC!, animated: true) {
            print("")
        }
    }
    
    
    @IBAction func showJoinedContestList(_ sender: Any) {
        
    }
    
    override func backButtonAction() {
        self.navigationController?.dismiss(animated: true
            , completion: nil)
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
