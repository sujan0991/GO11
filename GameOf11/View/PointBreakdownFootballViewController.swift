//
//  PointBreakdownFootballViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 10/12/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import SafariServices

class PointBreakdownFootballViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    
    var matchId = 0
    var teamId = 0
    var match_status_id = 0
    var username = ""
    var teamName = ""
    
    var leaderBoardData:BreakDownData?
    var playerInfo:PlayerInfoData?
    
    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var teamnamelabel: UILabel!
    
    var matchType:String?
    
    
    @IBOutlet weak var firstInningsLabel: UILabel!
    
    @IBOutlet weak var firstInningsView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var pointTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var breakdownView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var playernameLabel: UILabel!
    @IBOutlet weak var playerRollLabel: UILabel!
    @IBOutlet weak var playerPointLabel: UILabel!
    @IBOutlet weak var totalPointLabel: UILabel!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var pointTitleLabel: UILabel!
    @IBOutlet weak var earningTitleLabel: UILabel!
    
    

    
    @IBOutlet weak var assistLabel: UILabel!
    @IBOutlet weak var assistValueLabel: UILabel!
    @IBOutlet weak var assistPointLabel: UILabel!
    
    @IBOutlet weak var cleansheetLabel: UILabel!
    @IBOutlet weak var cleansheetValueLabel: UILabel!
    @IBOutlet weak var cleansheetPointLabel: UILabel!
    
    @IBOutlet weak var goal_concededLabel: UILabel!
    @IBOutlet weak var goal_concededValueLabel: UILabel!
    @IBOutlet weak var goal_concededPointLabel: UILabel!
    
    @IBOutlet weak var goal_savedLabel: UILabel!
    @IBOutlet weak var goal_savedValueLabel: UILabel!
    @IBOutlet weak var goal_savedPointLabel: UILabel!
    
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var goalsValueLabel: UILabel!
    @IBOutlet weak var goalsPointLabel: UILabel!
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var minutesValueLabel: UILabel!
    @IBOutlet weak var minutesPointLabel: UILabel!
    
    @IBOutlet weak var own_goalLabel: UILabel!
    @IBOutlet weak var own_goalValueLabel: UILabel!
    @IBOutlet weak var own_goalPointLabel: UILabel!
    
    @IBOutlet weak var passesLabel: UILabel!
    @IBOutlet weak var passesValueLabel: UILabel!
    @IBOutlet weak var passesPointLabel: UILabel!
    
    @IBOutlet weak var penalty_missedLabel: UILabel!
    @IBOutlet weak var penalty_missedValueLabel: UILabel!
    @IBOutlet weak var penalty_missedPointLabel: UILabel!
    
    @IBOutlet weak var penalty_savedLabel: UILabel!
    @IBOutlet weak var penalty_savedValueLabel: UILabel!
    @IBOutlet weak var penalty_savedPointLabel: UILabel!
    
    @IBOutlet weak var penalty_scoredLabel: UILabel!
    @IBOutlet weak var penalty_scoredValueLabel: UILabel!
    @IBOutlet weak var penalty_scoredPointLabel: UILabel!

    @IBOutlet weak var red_cardLabel: UILabel!
    @IBOutlet weak var red_cardValueLabel: UILabel!
    @IBOutlet weak var red_cardPointLabel: UILabel!
    
    @IBOutlet weak var tacklesLabel: UILabel!
    @IBOutlet weak var tacklesValueLabel: UILabel!
    @IBOutlet weak var tacklesPointLabel: UILabel!
    
    @IBOutlet weak var yellow_cardLabel: UILabel!
    @IBOutlet weak var yellow_cardValueLabel: UILabel!
    @IBOutlet weak var yellow_cardPointLabel: UILabel!
    
    
    @IBOutlet weak var suggestionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //   placeNavBar(withTitle: "POINT BRAKDOWN", isBackBtnVisible: true)
        
        self.usernameLabel.text = username
        self.teamnamelabel.text = teamName.uppercased()
        
        navTitleLabel.text = "POINTS BREAKDOWN".localized
        totalPointLabel.text = "Total Points".localized
        eventTitleLabel.text = "     Events".localized
        earningTitleLabel.text = "  Earned Points".localized
        pointTitleLabel.text = " Points".localized
        suggestionLabel.text = "Some criteria of player points breakdown is not listed here to avoid calculation complexity. You can check the full scoring point system by clicking top right 'Question Mark' icon.".localized
        
        pointTableView.delegate = self
        pointTableView.dataSource = self
        
        print("......",self.matchId,self.teamId)
        pointTableView.isHidden = true
        
        print("matchType...............",matchType,matchId)
        
      
        
        APIManager.manager.getBreakDownOfFootballCntest(match_id:"\(matchId)", user_team_id:"\(teamId)") { (Bool, data, msg) in
            
            if data != nil{
                
                self.leaderBoardData = data
                
                self.pointTableView.reloadData()
                self.pointTableView.isHidden = false
                
                print("count ???????",self.leaderBoardData?.team_info?.player_info.count ?? 0)
            }
        }
        
        
        //test
        
//        var x:Float = 25/10
//        var y:Float = 5/10
//        print("................................................",x,x.rounded(.down),y.rounded(.down))
//        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.leaderBoardData?.team_info?.player_info.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"playerCell") as! PointBreakDownTableViewCell
        
        let singlePlayerInfo = self.leaderBoardData?.team_info?.player_info[indexPath.row]
        
        cell.setInfo(singlePlayerInfo!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? PointBreakDownTableViewCell{
            
            let singlePlayerInfo = self.leaderBoardData?.team_info?.player_info[indexPath.row]
            
            if singlePlayerInfo!.is_captain == 1{
                
                print("indexPath.row........",indexPath.row)
                
                cell.captainLabel.isHidden = false
                cell.xLabel.isHidden = false
                cell.captainLabel.text = "C"
                cell.captainLabel.backgroundColor = UIColor.init(named: "GreenHighlight")!
                cell.xLabel.text = "2x"
                cell.xLabel.textColor = UIColor.init(named: "GreenHighlight")!
                
            }else if singlePlayerInfo!.is_vice_captain == 1{
                
                cell.captainLabel.isHidden = false
                cell.captainLabel.text = "VC"
                cell.captainLabel.backgroundColor = UIColor.init(named: "TabOrangeColor")!
                cell.xLabel.isHidden = false
                cell.xLabel.text = "1.5x"
                cell.xLabel.textColor = UIColor.init(named: "TabOrangeColor")!
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cellIdentifier = "headerCell"
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        let playerInfoLabel:UILabel = cell.viewWithTag(101) as! UILabel
        let pointsLabel:UILabel = cell.viewWithTag(102) as! UILabel
        
        playerInfoLabel.text = "PLAYER INFO".localized
        pointsLabel.text = "POINTS".localized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("match_status_id.........",match_status_id)
        
        if match_status_id == 3{
            
            showPointBreakDown()
            
            let singlePlayerInfo = self.leaderBoardData?.team_info?.player_info[indexPath.row]
            
            let singlePlayerPoint = singlePlayerInfo?.point_breakdown_football
            
            self.playernameLabel.text = singlePlayerInfo?.player_name
            self.playerRollLabel.text = singlePlayerInfo?.player_role?.uppercased()
            
            if singlePlayerInfo?.player_image != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\( singlePlayerInfo!.player_image!)")
                
                
                self.playerImageView.kf.setImage(with: url1)
                
                if url1 == nil{
                    self.playerImageView.image = UIImage.init(named: "player_avatar_global.png")
                }
                
            }else{
                
                self.playerImageView.image = UIImage(named: "player_avatar_global.png")
            }
            

            self.playerPointLabel.text = "\(singlePlayerInfo?.player_earning_point ?? 0)"
            
            self.assistValueLabel.text = "\(singlePlayerPoint?.assist ?? 0)"
            self.cleansheetValueLabel.text = "\(singlePlayerPoint?.cleansheet ?? 0)"
            self.goal_concededValueLabel.text = "\(singlePlayerPoint?.goal_conceded ?? 0)"
            self.goal_savedValueLabel.text = "\(singlePlayerPoint?.goal_saved ?? 0)"
            self.goalsValueLabel.text = "\(singlePlayerPoint?.goals ?? 0)"
            self.minutesValueLabel.text = "\(singlePlayerPoint?.minutes ?? 0)"
            self.own_goalValueLabel.text = "\(singlePlayerPoint?.own_goal ?? 0)"
            self.passesValueLabel.text = "\(singlePlayerPoint?.passes ?? 0)"
            self.penalty_savedValueLabel.text = "\(singlePlayerPoint?.penalty_saved ?? 0)"
            self.penalty_missedValueLabel.text = "\(singlePlayerPoint?.penalty_missed ?? 0)"
            self.penalty_scoredValueLabel.text = "\(singlePlayerPoint?.penalty_scored ?? 0)"
            self.red_cardValueLabel.text = "\(singlePlayerPoint?.red_card ?? 0)"
            self.tacklesValueLabel.text = "\(singlePlayerPoint?.tackles ?? 0)"
            self.yellow_cardValueLabel.text = "\(singlePlayerPoint?.yellow_card ?? 0)"
            
            
            
                if singlePlayerPoint?.assist != nil{
                
                    self.assistPointLabel.text = "\(Float((singlePlayerPoint?.assist)!) * 5.0)"
                }
                
                if singlePlayerPoint?.cleansheet != nil{
                    if singlePlayerInfo?.player_role == "midfielder"{
                        self.cleansheetPointLabel.text = "\(Float((singlePlayerPoint?.cleansheet)!) * 1.0)"
                    }else if singlePlayerInfo?.player_role == "defender"{
                        self.cleansheetPointLabel.text = "\(Float((singlePlayerPoint?.cleansheet)!) * 5.0)"
                    }
                    
                }
                if singlePlayerPoint?.goal_conceded != nil{
                    
                    let concededPoint:Float = Float((singlePlayerPoint?.goal_conceded)!/2)
                    self.goal_concededPointLabel.text = "\(concededPoint.rounded(.down) * -1.0)"
                }
                if singlePlayerPoint?.goal_saved != nil{
                    self.goal_savedPointLabel.text = "\(Float((singlePlayerPoint?.goal_saved)!) * 2.0)"
                    
                }
                
                
                if singlePlayerPoint?.goals != nil{
                    
                    if singlePlayerInfo?.player_role == "midfielder"{
                        self.goalsPointLabel.text = "\(Float((singlePlayerPoint?.goals)!) * 9.0)"
                    }else if singlePlayerInfo?.player_role == "defender" || singlePlayerInfo?.player_role == "goalkeeper"{
                        self.goalsPointLabel.text = "\(Float((singlePlayerPoint?.goals)!) * 10.0)"
                    }else if singlePlayerInfo?.player_role == "striker"{
                        self.goalsPointLabel.text = "\(Float((singlePlayerPoint?.goals)!) * 8.0)"
                    }
                }
                
                if singlePlayerPoint?.minutes != nil{
                    
                    if singlePlayerPoint!.minutes! >= 55{
                        
                        self.minutesPointLabel.text = "2.0"
                        
                    }else{
                        
                        self.minutesPointLabel.text = "1.0"
                        
                    }
                    
                }
                if singlePlayerPoint?.own_goal != nil{
                    self.own_goalPointLabel.text = "\(Float((singlePlayerPoint?.own_goal)!) * -2.0)"
                    
                }
            
                if singlePlayerPoint?.passes != nil{

                    var passPoint:Float = Float((singlePlayerPoint?.passes)!/10)
                    self.passesPointLabel.text = "\( passPoint.rounded(.down) * 0.5)"
                }



                //Have to calculate like strike rate
                // self.econPointLabel.text = "\(Float((singlePlayerPoint?.sixes)!) * 1.0)"
            if singlePlayerPoint?.penalty_missed != nil{
                
                self.penalty_missedPointLabel.text = "\(Float((singlePlayerPoint?.penalty_missed)!) * -2.0)"
            }
            
            if singlePlayerPoint?.penalty_saved != nil{
                
                self.penalty_savedPointLabel.text = "\(Float((singlePlayerPoint?.penalty_saved)!) * 9.0)"
            }
//            if singlePlayerPoint?.penalty_scored != nil{
//
//                self.penalty_scoredPointLabel.text = "\(Float((singlePlayerPoint?.penalty_scored)!) * -2.0)"
//            }

            if singlePlayerPoint?.red_card != nil{
                    self.red_cardPointLabel.text = "\(Float((singlePlayerPoint?.red_card)!) * -3.0)"
            }
            if singlePlayerPoint?.tackles != nil{
                    
                    let tacklesPoint:Float = Float((singlePlayerPoint?.tackles)!/3)
                    self.tacklesPointLabel.text = "\( tacklesPoint.rounded(.down) * 1)"
            }
            if singlePlayerPoint?.yellow_card != nil{
                
                 self.yellow_cardPointLabel.text = "\(Float((singlePlayerPoint?.yellow_card)!) * -1.0)"
            }
            
        }else{
            
            self.view.makeToast("Each player's detailed points breakdown will be available when the match is completed and the completion of reviewing and updating individual players point calculation via our web server".localized)
            
        }
        
        
        
    }
    
    
    func showPointBreakDown() {
        
        scrollView.setContentOffset(.zero, animated: false)
        
        self.breakdownView.frame = CGRect(x: 0, y:self.view.frame.height, width: self.breakdownView.frame.width, height: self.breakdownView.frame.height)
        let bottonSpace = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 1.0
        let topSpace = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 1.0
        
        UIView.animate(withDuration:0.2, animations: {
            
            
            self.breakdownView.frame = CGRect(x: 0, y:topSpace + 44, width: self.breakdownView.frame.width, height: self.breakdownView.frame.height)
            
        }) { _ in
            
            
        }
        self.view.bringSubviewToFront(breakdownView)
        
        breakdownView.isHidden = false
        backButton.isHidden = true
        closeButton.isHidden = false
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        print("closeButtonAction")
        breakdownView.isHidden = true
        backButton.isHidden = false
        closeButton.isHidden = true
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        
        let urlString = "https://www.gameof11.com/team-select-and-scoring-system"
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
        }
    }
    
    
}
