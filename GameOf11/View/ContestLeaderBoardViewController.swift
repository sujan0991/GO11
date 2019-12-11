//
//  ContestLeaderBoardViewController.swift
//  CompleteCont
//
//  Created by Md.Ballal Hossen on 11/3/19.
//  Copyright © 2019 Sujan. All rights reserved.


import UIKit

class ContestLeaderBoardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    
    var contest_id: Int?
    var match_id: Int?

    var page_no = 1
    var total_page_no : Int!
    
    var matchData:MatchScoreData?
    
    var leaderBoardData:LeaderBoardData?
    var contestName:String!
    var sortedleaderBoard:[LeaderBoardUserListData] = []
   
    let formatter = NumberFormatter()
    
    @IBOutlet weak var navTitleLabel: UILabel!
    
    @IBOutlet weak var firstTeamFlagImageView: UIImageView!
    @IBOutlet weak var firstTeamNameLabel: UILabel!
    
    @IBOutlet weak var secondTeamFlagImageView: UIImageView!
    @IBOutlet weak var secondTeamNameLabel: UILabel!
    
    @IBOutlet weak var lastupdateTimeLabel: UILabel!
    
    @IBOutlet weak var scoreBoardLabel: UILabel!
    
    @IBOutlet weak var playingFormatLabel: UILabel!
    @IBOutlet weak var contestnamentNameLabel: UILabel!
    @IBOutlet weak var contestIconImageView: UIImageView!
    
    @IBOutlet weak var firstteamScoreLabel: UILabel!
    @IBOutlet weak var secondTeamScoreLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var rankTitlelabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var pointTitleLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var userteamnameLabel: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    
    @IBOutlet weak var allPlayerTitleLabel: UILabel!
    
    @IBOutlet weak var leaderBoardTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        placeNavBar(withTitle: "LEADERBOARD", isBackBtnVisible: true)
//
        navTitleLabel.text = "CONTEST LEADERBOARD".localized
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
        
        print("contest_id",contest_id ?? 0,match_id ?? 0)
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        
        leaderBoardTabelView.delegate = self
        leaderBoardTabelView.dataSource = self
        
        leaderBoardTabelView.isHidden = true
        
        resultLabel.text = "The result will be published when the match ends!".localized
        rankTitlelabel.text = "RANK".localized
        pointTitleLabel.text = "POINTS".localized
        allPlayerTitleLabel.text = "ALL PLAYERS RANK & POINTS".localized
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnImageView(_:)))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tap)

        getData()
        
    }
    
    @objc func tapOnImageView(_ sender: UITapGestureRecognizer? = nil) {
        
        print("tap on image view")
      if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PointBreakDownViewController") as? PointBreakDownViewController
      
        vc?.matchId = match_id ?? 0
        vc?.teamId = leaderBoardData?.user_team_id ?? 0
        vc?.username = leaderBoardData?.username ?? ""
        vc?.teamName = leaderBoardData?.user_team_name ?? ""
        vc?.matchType = matchData?.match_format
        vc?.match_status_id = matchData?.match_status_id ?? 0
        self.present(vc!, animated: true) {
            
            print("open PointBreakDownViewController")
        }
      }else{
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PointBreakdownFootballViewController") as? PointBreakdownFootballViewController
        
        vc?.matchId = match_id ?? 0
        vc?.teamId = leaderBoardData?.user_team_id ?? 0
        vc?.username = leaderBoardData?.username ?? ""
        vc?.teamName = leaderBoardData?.user_team_name ?? ""
      //  vc?.matchType = matchData?.match_format
        vc?.match_status_id = matchData?.match_status_id ?? 0
        self.present(vc!, animated: true) {
            
            print("open PointBreakDownViewController")
        }
        
        }
    }
    
    func getData(){
      
     if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
        APIManager.manager.getMatchScore(matchId: "\(match_id ?? 0)") { (Bool, data, msg) in
            
            print("getMatchScore",data!)
            
            if data != nil{
                
                self.matchData = data
                self.populateTeamView()
            }
            
        }
     }else{
        
        APIManager.manager.getFootballMatchScore(matchId: "\(match_id ?? 0)") { (Bool, data, msg) in
            
            print("getMatchScore",data!)
            
            if data != nil{
                
                self.matchData = data
                self.populateTeamView()
            }
            
        }
        
        }
        
        getLeaderBoard(contestId: contest_id ?? 0, pageNo: page_no)
        
    }
    //"\(parentMatch?.matchId ?? 0)"
    func getLeaderBoard(contestId:Int,pageNo:Int) {
        
        var c_id:String = String(describing: contestId)
        var p_no:String = String(describing: pageNo)
       
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
        APIManager.manager.getLeaderBoardOfCntest(contestId: c_id as String, pageNo: p_no) { (Bool, data, msg) in
            
            print("getLeaderBoardOfCntest",data!)
            
            
            if self.page_no == 1{
                
                self.total_page_no = data?.total_page_number
                
                self.leaderBoardData = data
                
            }else{
                
                self.leaderBoardData?.leaderboard.append(contentsOf: data?.leaderboard ?? [])
            }
            
            self.sortedleaderBoard = self.leaderBoardData?.leaderboard.sorted(by: {
                (player1: LeaderBoardUserListData, player2: LeaderBoardUserListData) -> Bool in
                
                if let rank1 = player1.rank,
                    let rank2 = player2.rank{
                    
                    return rank1 < rank2
                }
                
                
                return true
            }) ?? []

            
            self.populateUserView()
            
            self.leaderBoardTabelView.reloadData()
            self.leaderBoardTabelView.isHidden = false
            
        }
        }else{
            
            APIManager.manager.getLeaderBoardOfCntestFootball(contestId: c_id as String, pageNo: p_no) { (Bool, data, msg) in
                
                print("getLeaderBoardOfCntest",data!)
                
                
                if self.page_no == 1{
                    
                    self.total_page_no = data?.total_page_number
                    
                    self.leaderBoardData = data
                    
                }else{
                    
                    self.leaderBoardData?.leaderboard.append(contentsOf: data?.leaderboard ?? [])
                }
                
                self.sortedleaderBoard = self.leaderBoardData?.leaderboard.sorted(by: {
                    (player1: LeaderBoardUserListData, player2: LeaderBoardUserListData) -> Bool in
                    
                    if let rank1 = player1.rank,
                        let rank2 = player2.rank{
                        
                        return rank1 < rank2
                    }
                    
                    
                    return true
                }) ?? []
                
                
                self.populateUserView()
                
                self.leaderBoardTabelView.reloadData()
                self.leaderBoardTabelView.isHidden = false
                
            }
        }
    }
    
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        
         page_no = 1
        
         getData()
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.leaderBoardTabelView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    
    }
    
    func populateTeamView() {
        
        if matchData!.match_status_id == 2 {//live
            
           
         for singleTeam in matchData!.teams {
            
          if singleTeam.is_first_batting == 1{
            
            let singleTeam = matchData!.teams[0]
            self.firstTeamNameLabel.text = singleTeam.team_key?.uppercased()
            
            
            if singleTeam.team_logo != nil{

                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(singleTeam.team_logo!)")
                
                
                self.firstTeamFlagImageView.kf.setImage(with: url1)
            }
            
            if singleTeam.score != nil{
                
             //   if Language.language == Language.english{
                    
                    self.firstteamScoreLabel.text = "\(String(describing: singleTeam.team_key!.uppercased())) - \(String(describing: singleTeam.score!))"
//                }else{
//
//                    let bnNumberString = self.formatter.string(for: singleTeam.score!)
//                    self.firstteamScoreLabel.text = "\(String(describing: singleTeam.team_key!.uppercased())) - \(String(describing:bnNumberString!))"
//                }
            
            }else{
              //  if Language.language == Language.english{
                    
                   self.firstteamScoreLabel.text = "\(String(describing: singleTeam.team_key!.uppercased())) - 0/0 (0.0)"
//                }else{
//                    self.firstteamScoreLabel.text = "\(String(describing: singleTeam.team_key!.uppercased())) - ০/০ (০.০)"
//                }
            }
            
           }else{
            
            let singleTeam1 = matchData!.teams[1]
            secondTeamNameLabel.text = singleTeam1.team_key?.uppercased()
            
            if singleTeam1.team_logo != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(singleTeam1.team_logo!)")
                self.secondTeamFlagImageView.kf.setImage(with: url1)
            }

            if singleTeam1.score != nil{
                
               // if Language.language == Language.english{
                    
                    self.secondTeamScoreLabel.text = "\(String(describing: singleTeam1.team_key!.uppercased())) - \(String(describing: singleTeam1.score!))"
//                }else{
//
//                    let bnNumberString = self.formatter.string(for: singleTeam1.score!)
//                    self.secondTeamScoreLabel.text = "\(String(describing: singleTeam1.team_key!.uppercased())) - \(String(describing:bnNumberString!))"
//                }
                
            }else{
               // if Language.language == Language.english{
                    
                    self.secondTeamScoreLabel.text = "\(String(describing: singleTeam1.team_key!.uppercased())) - 0/0 (0.0)"
//                }else{
//                    self.secondTeamScoreLabel.text = "\(String(describing: singleTeam1.team_key!.uppercased())) - ০/০ (০.০)"
//                }
            }
            
              }
           }
        }
        else if matchData!.match_status_id == 3 {//completed
            
            
            for singleTeam in matchData!.teams {
                
                if singleTeam.is_first_batting == 1{
                    
                    let singleTeam = matchData!.teams[0]
                    self.firstTeamNameLabel.text = singleTeam.team_key?.uppercased()
                    
                    if singleTeam.team_logo != nil{
                        
                        let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(singleTeam.team_logo!)")
                        
                        
                        self.firstTeamFlagImageView.kf.setImage(with: url1)
                    }
                    if singleTeam.score != nil{
                      //  if Language.language == Language.english{
                            
                            self.firstteamScoreLabel.text = "\(String(describing: singleTeam.team_key!.uppercased())) - \(String(describing: singleTeam.score!))"
//                        }else{
//
//                            let bnNumberString = self.formatter.string(for: singleTeam.score!)
//                            self.firstteamScoreLabel.text = "\(String(describing: singleTeam.team_key!.uppercased())) - \(String(describing:bnNumberString!))"
//                        }
                        
                    }else{
                      //  if Language.language == Language.english{
                            
                            self.firstteamScoreLabel.text = "\(String(describing: singleTeam.team_key!.uppercased())) - 0/0 (0.0)"
//                        }else{
//                            self.firstteamScoreLabel.text = "\(String(describing: singleTeam.team_key!.uppercased())) - ০/০ (০.০)"
//                        }
                    }
                    
                }else{
                    
                    let singleTeam1 = matchData!.teams[1]
                    secondTeamNameLabel.text = singleTeam1.team_key?.uppercased()
                    if singleTeam1.team_logo != nil{
                        
                        let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(singleTeam1.team_logo!)")
                        
                        
                        self.secondTeamFlagImageView.kf.setImage(with: url1)
                    }
                    if singleTeam1.score != nil{
                       // if Language.language == Language.english{
                            
                            self.secondTeamScoreLabel.text = "\(String(describing: singleTeam1.team_key!.uppercased())) - \(String(describing: singleTeam1.score!))"
//                        }else{
//
//                            let bnNumberString = self.formatter.string(for: singleTeam1.score!)
//                            self.secondTeamScoreLabel.text = "\(String(describing: singleTeam1.team_key!.uppercased())) - \(String(describing:bnNumberString!))"
//                        }
                        
                    }else{
                      //  if Language.language == Language.english{
                            
                            self.secondTeamScoreLabel.text = "\(String(describing: singleTeam1.team_key!.uppercased())) - 0/0 (0.0)"
//                        }else{
//                            self.secondTeamScoreLabel.text = "\(String(describing: singleTeam1.team_key!.uppercased())) - ০/০ (০.০)"
//                        }
                    }
                    
                    
                }
            }
        }else if matchData!.match_status_id == 1{//not started
            
            let singleTeam = matchData!.teams[0]
            self.firstTeamNameLabel.text = singleTeam.team_key?.uppercased()
            if singleTeam.team_logo != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(singleTeam.team_logo!)")
                
                
                self.firstTeamFlagImageView.kf.setImage(with: url1)
            }
            
            let singleTeam1 = matchData!.teams[1]
            secondTeamNameLabel.text = singleTeam1.team_key?.uppercased()
            if singleTeam1.team_logo != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(singleTeam1.team_logo!)")
                
                
                self.secondTeamFlagImageView.kf.setImage(with: url1)
            }
        //    if Language.language == Language.english{
                
                if singleTeam.score != nil{
                  self.firstteamScoreLabel.text = "\(String(describing: singleTeam.team_key!.uppercased())) - \(String(describing: singleTeam.score!))"
                }
                if singleTeam1.score != nil{
                  self.secondTeamScoreLabel.text = "\(String(describing: singleTeam1.team_key!.uppercased())) - \(String(describing: singleTeam1.score!))"
                }
//            }else{
//                if singleTeam.score != nil{
//
//
//                    let bnNumberString = self.formatter.string(for: singleTeam.score!)
//                    print("singleTeam.score............",bnNumberString)
//
////                    self.firstteamScoreLabel.text = "\(String(describing: singleTeam.team_key!.uppercased())) - \(String(describing:bnNumberString!))"
//                }
//                if singleTeam1.score != nil{
//
////                    let bnNumberString1 = self.formatter.string(for: singleTeam1.score!)
////
////
////                    self.secondTeamScoreLabel.text = "\(String(describing: singleTeam1.team_key!.uppercased())) - \(String(describing:bnNumberString1!))"
//                }
//
//
//            }
            

            
        }
        

        
        self.contestnamentNameLabel.text = self.contestName.uppercased()
        self.playingFormatLabel.text = matchData?.match_format?.uppercased()
        if matchData?.result != nil{
         self.resultLabel.text = matchData?.result
        }
                
    }
    
    func populateUserView() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString :Date = dateFormatter.date(from: ((leaderBoardData?.last_updated_time!) ?? ""))!
        let sttringFDate = dateFromString.toDateString(format: "d MMM, yyyy hh:mm a")
        
        let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(leaderBoardData?.user_avatar ?? "")")
        
        self.userImageView.kf.setImage(with: url2)
        
        if Language.language == Language.english{
            
            self.lastupdateTimeLabel.text = "Last Updated: \( sttringFDate )"
            self.userNameLabel.text = leaderBoardData?.username
            self.rankLabel.text = "\(leaderBoardData?.user_rank ?? 0)"
            self.pointLabel.text = "\(leaderBoardData?.team_earning_point ?? 0)"
            self.userteamnameLabel.text = leaderBoardData?.user_team_name

        }else{
            
            self.lastupdateTimeLabel.text = "শেষ আপডেটের সময়: \( sttringFDate )"
            self.userNameLabel.text = leaderBoardData?.username
            let bnNumberString = self.formatter.string(for: leaderBoardData?.user_rank!)
            let bnNumberString2 = self.formatter.string(for: leaderBoardData?.team_earning_point!)

            self.rankLabel.text = bnNumberString ?? "০"
            self.pointLabel.text = bnNumberString2 ?? "০"
            self.userteamnameLabel.text = leaderBoardData?.user_team_name

        }
        
  }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sortedleaderBoard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
         let cell = tableView.dequeueReusableCell(withIdentifier:"leaderCell") as! LeaderBoardTableViewCell
        
        

        let singleUser = sortedleaderBoard[indexPath.row]
        
        
        cell.setInfo(singleUser)
        
        if indexPath.row == (sortedleaderBoard.count) - 3 {
            
            if total_page_no > page_no { // more items to fetch
               
                page_no = page_no + 1
                
                getLeaderBoard(contestId: contest_id ?? 0, pageNo: page_no)

            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if matchData!.match_status_id == 2 || matchData!.match_status_id == 3{
          
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PointBreakDownViewController") as? PointBreakDownViewController
            
            let singleUser = leaderBoardData?.leaderboard[indexPath.row]
            
            print(".........................matchData?.match_format",matchData?.match_format)
            vc?.matchId = match_id ?? 0
            vc?.teamId = singleUser?.user_team_id ?? 0
            vc?.username = singleUser?.username ?? ""
            vc?.teamName = singleUser?.team_name ?? ""
            vc?.matchType = matchData?.match_format
            vc?.match_status_id = matchData?.match_status_id ?? 0
            
            self.present(vc!, animated: true) {
                
                print("open PointBreakDownViewController")
            }
            }else{
                
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PointBreakdownFootballViewController") as? PointBreakdownFootballViewController
                
                vc?.matchId = match_id ?? 0
                vc?.teamId = leaderBoardData?.user_team_id ?? 0
                vc?.username = leaderBoardData?.username ?? ""
                vc?.teamName = leaderBoardData?.user_team_name ?? ""
                //  vc?.matchType = matchData?.match_format
                vc?.match_status_id = matchData?.match_status_id ?? 0
                self.present(vc!, animated: true) {
                    
                    print("open PointBreakDownViewController")
                }

            }
        }else{
            
            self.view.makeToast("Contest joining time not ended yet. After ending contest joining time you will be able to see other participant's player info with total points earned".localized)
        }
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            
        })
    }
    

}
