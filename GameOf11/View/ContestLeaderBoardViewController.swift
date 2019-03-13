//
//  ContestLeaderBoardViewController.swift
//  CompleteCont
//
//  Created by Md.Ballal Hossen on 11/3/19.
//  Copyright © 2019 Sujan. All rights reserved.


import UIKit

class ContestLeaderBoardViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    
    var contest_id: Int?
    var match_id: Int?

    var page_no = 1
    
    var matchData:MatchScoreData?
    
    var leaderBoardData:LeaderBoardData?
    
   
    @IBOutlet weak var firstTeamFlagImageView: UIImageView!
    @IBOutlet weak var firstTeamNameLabel: UILabel!
    
    @IBOutlet weak var secondTeamFlagImageView: UIImageView!
    @IBOutlet weak var secondTeamNameLabel: UILabel!
    
    @IBOutlet weak var lastupdateTimeLabel: UILabel!
    
    
    @IBOutlet weak var playingFormatLabel: UILabel!
    @IBOutlet weak var tournamentNameLabel: UILabel!
    
    @IBOutlet weak var firstteamScoreLabel: UILabel!
    @IBOutlet weak var secondTeamScoreLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var userteamnameLabel: UILabel!
    
    @IBOutlet weak var leaderBoardTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeNavBar(withTitle: "POINT BREAKDOWN", isBackBtnVisible: true)
        
        print("contest_id",contest_id ?? 0,match_id ?? 0)
        
        leaderBoardTabelView.delegate = self
        leaderBoardTabelView.dataSource = self
        
        leaderBoardTabelView.isHidden = true
        
        APIManager.manager.getMatchScore(matchId: "\(match_id ?? 0)") { (Bool, data, msg) in
            
            print("getMatchScore",data!)
            
            if data != nil{
                
                self.matchData = data
                self.populateTeamView()
            }
            
        }
        
        getLeaderBoard(contestId: contest_id ?? 0, pageNo: page_no)
        
    }
    //"\(parentMatch?.matchId ?? 0)"
    func getLeaderBoard(contestId:Int,pageNo:Int) {
        
        var c_id:String = String(describing: contestId)
        var p_no:String = String(describing: pageNo)
        
        APIManager.manager.getLeaderBoardOfCntest(contestId: c_id as String, pageNo: p_no) { (Bool, data, msg) in
            
            print("getLeaderBoardOfCntest",data!)
            self.leaderBoardData = data
            
            self.populateUserView()
            
            self.leaderBoardTabelView.reloadData()
            self.leaderBoardTabelView.isHidden = false
            
        }
    }
    
    
    func populateTeamView() {
        
        for singleTeam in matchData!.teams {
            
            if singleTeam.is_first_batting == 1{
                
                self.firstTeamNameLabel.text = singleTeam.team_key
                self.firstteamScoreLabel.text = singleTeam.score
                
            }else{
                
                secondTeamNameLabel.text = singleTeam.team_key
                self.secondTeamScoreLabel.text = singleTeam.score
                
            }
        }
        
        self.tournamentNameLabel.text = matchData?.match_name
        self.playingFormatLabel.text = matchData?.match_format
        self.resultLabel.text = matchData?.result
    }
    
    func populateUserView() {
        
        self.lastupdateTimeLabel.text = "Last update time:\(leaderBoardData?.last_updated_time! ?? "")"
        self.userNameLabel.text = leaderBoardData?.username
        self.rankLabel.text = "\(leaderBoardData?.user_rank ?? 0)"
        self.pointLabel.text = "\(leaderBoardData?.team_earning_point ?? 0)"
        self.userteamnameLabel.text = leaderBoardData?.user_team_name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return leaderBoardData?.leaderboard.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
         let cell = tableView.dequeueReusableCell(withIdentifier:"leaderCell") as! LeaderBoardTableViewCell
        
        let singleUser = leaderBoardData?.leaderboard[indexPath.row]
        
        
        cell.setInfo(singleUser!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PointBreakDownViewController") as? PointBreakDownViewController
        
        let singleUser = leaderBoardData?.leaderboard[indexPath.row]
        
        vc?.matchId = matchData?.match_id ?? 0
        vc?.teamId = singleUser?.user_team_id ?? 0
        
        self.present(vc!, animated: true) {
            
            print("open PointBreakDownViewController")
        }
    }
  

}
