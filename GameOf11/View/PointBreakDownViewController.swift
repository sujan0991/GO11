//
//  PointBreakDownViewController.swift
//  CompleteCont
//
//  Created by Md.Ballal Hossen on 12/3/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit
import SafariServices

class PointBreakDownViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
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
    
    
    @IBOutlet weak var isInXILabel: UILabel!
    @IBOutlet weak var isInXIValueLabel: UILabel!
    @IBOutlet weak var isInXIPointLabel: UILabel!
    
    @IBOutlet weak var runsLabel: UILabel!
    @IBOutlet weak var runsValueLabel: UILabel!
    @IBOutlet weak var runsPointLabel: UILabel!
    
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var fourValueLabel: UILabel!
    @IBOutlet weak var fourPointLabel: UILabel!
    
    @IBOutlet weak var sixLabel: UILabel!
    @IBOutlet weak var sixValueLabel: UILabel!
    @IBOutlet weak var sixPointLabel: UILabel!
    
    @IBOutlet weak var strikeLabel: UILabel!
    @IBOutlet weak var strikeValueLabel: UILabel!
    @IBOutlet weak var strikePointLabel: UILabel!
    
    @IBOutlet weak var catchLabel: UILabel!
    @IBOutlet weak var catchValueLabel: UILabel!
    @IBOutlet weak var catchPointLabel: UILabel!
    
    @IBOutlet weak var wicketLabel: UILabel!
    @IBOutlet weak var wicketValueLabel: UILabel!
    @IBOutlet weak var wicketPointLabel: UILabel!
    
    @IBOutlet weak var maidenLabel: UILabel!
    @IBOutlet weak var maidenValueLabel: UILabel!
    @IBOutlet weak var maidenPointLabel: UILabel!
    
    @IBOutlet weak var econLabel: UILabel!
    @IBOutlet weak var econValueLabel: UILabel!
    @IBOutlet weak var econPointLabel: UILabel!
    
    @IBOutlet weak var runOutLabel: UILabel!
    @IBOutlet weak var runOutValueLabel: UILabel!
    @IBOutlet weak var runOutPointLabel: UILabel!
    
    @IBOutlet weak var stumpingLabel: UILabel!
    @IBOutlet weak var stumpingValueLabel: UILabel!
    @IBOutlet weak var stumpingPointLabel: UILabel!
    
    
    
    
    @IBOutlet weak var secondInningsView: UIView!
    @IBOutlet weak var secondInningsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var secondInningsLabel: UILabel!
    
    @IBOutlet weak var secondPointStackView: UIStackView!
    @IBOutlet weak var secondTopStackView: UIStackView!
    
    @IBOutlet weak var secondEventTitleLabel: UILabel!
    @IBOutlet weak var secondEarningTitleLabel: UILabel!
    @IBOutlet weak var secondPointLabel: UILabel!
    
    @IBOutlet weak var secondisInXILabel: UILabel!
    @IBOutlet weak var secondisInXIValueLabel: UILabel!
    @IBOutlet weak var secondisInXIPointLabel: UILabel!
    
    @IBOutlet weak var secondrunsLabel: UILabel!
    @IBOutlet weak var secondrunsValueLabel: UILabel!
    @IBOutlet weak var secondrunsPointLabel: UILabel!
    
    @IBOutlet weak var secondfourLabel: UILabel!
    @IBOutlet weak var secondfourValueLabel: UILabel!
    @IBOutlet weak var secondfourPointLabel: UILabel!
    
    @IBOutlet weak var secondsixLabel: UILabel!
    @IBOutlet weak var secondsixValueLabel: UILabel!
    @IBOutlet weak var secondsixPointLabel: UILabel!
    
    @IBOutlet weak var secondstrikeLabel: UILabel!
    @IBOutlet weak var secondstrikeValueLabel: UILabel!
    @IBOutlet weak var secondstrikePointLabel: UILabel!
    
    @IBOutlet weak var secondcatchLabel: UILabel!
    @IBOutlet weak var secondcatchValueLabel: UILabel!
    @IBOutlet weak var secondcatchPointLabel: UILabel!
    
    @IBOutlet weak var secondwicketLabel: UILabel!
    @IBOutlet weak var secondwicketValueLabel: UILabel!
    @IBOutlet weak var secondwicketPointLabel: UILabel!
    
    @IBOutlet weak var secondmaidenLabel: UILabel!
    @IBOutlet weak var secondmaidenValueLabel: UILabel!
    @IBOutlet weak var secondmaidenPointLabel: UILabel!
    
    @IBOutlet weak var secondeconLabel: UILabel!
    @IBOutlet weak var secondeconValueLabel: UILabel!
    @IBOutlet weak var secondeconPointLabel: UILabel!
    
    @IBOutlet weak var secondrunOutLabel: UILabel!
    @IBOutlet weak var secondrunOutValueLabel: UILabel!
    @IBOutlet weak var secondrunOutPointLabel: UILabel!
    
    @IBOutlet weak var secondstumpingLabel: UILabel!
    @IBOutlet weak var secondstumpingValueLabel: UILabel!
    @IBOutlet weak var secondstumpingPointLabel: UILabel!
    
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
        
        if matchType == "test"{
            
            secondInningsView.isHidden = false
            firstInningsLabel.text = "First Innings"
            secondInningsHeight.constant = secondInningsLabel.frame.height + secondTopStackView.frame.height + secondPointStackView.frame.height + 35
            
        }else{
            
            secondInningsView.isHidden = true
            firstInningsLabel.text = ""
            secondInningsHeight.constant = 0
        }
        
        
        
        APIManager.manager.getBreakDownOfCntest(match_id:"\(matchId)", user_team_id:"\(teamId)") { (Bool, data, msg) in
            
            if data != nil{
                
                self.leaderBoardData = data
                
                self.pointTableView.reloadData()
                self.pointTableView.isHidden = false
                
                print("count ???????",self.leaderBoardData?.team_info?.player_info.count ?? 0)
            }
        }
        
        
        
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
            
            let singlePlayerPoint = singlePlayerInfo?.point_breakdown
            
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
            
            self.isInXIValueLabel.text = singlePlayerInfo?.is_in_playing_xi
            self.runsValueLabel.text = "\(singlePlayerPoint?.runs?["1"] ?? 0)"
            self.fourValueLabel.text = "\(singlePlayerPoint?.fours?["1"] ?? 0)"
            self.sixValueLabel.text = "\(singlePlayerPoint?.sixes?["1"] ?? 0)"
            self.strikeValueLabel.text = "\(singlePlayerPoint?.strike_rate?["1"] ?? 0)"
            self.catchValueLabel.text = "\(singlePlayerPoint?.catches?["1"] ?? 0)"
            self.wicketValueLabel.text = "\(singlePlayerPoint?.wickets?["1"] ?? 0)"
            self.maidenValueLabel.text = "\(singlePlayerPoint?.maiden_overs?["1"] ?? 0)"
            self.econValueLabel.text = "\(singlePlayerPoint?.economy?["1"] ?? 0)"
            self.runOutValueLabel.text = "\(singlePlayerPoint?.runouts?["1"] ?? 0)"
            self.stumpingValueLabel.text = "\(singlePlayerPoint?.stumbeds?["1"] ?? 0)"
            
            
            if self.matchType == "test"{
                
                self.secondisInXIValueLabel.text = singlePlayerInfo?.is_in_playing_xi
                self.secondrunsValueLabel.text = "\(singlePlayerPoint?.runs?["2"] ?? 0)"
                self.secondfourValueLabel.text = "\(singlePlayerPoint?.fours?["2"] ?? 0)"
                self.secondsixValueLabel.text = "\(singlePlayerPoint?.sixes?["2"] ?? 0)"
                self.secondstrikeValueLabel.text = "\(singlePlayerPoint?.strike_rate?["2"] ?? 0)"
                self.secondcatchValueLabel.text = "\(singlePlayerPoint?.catches?["2"] ?? 0)"
                self.secondwicketValueLabel.text = "\(singlePlayerPoint?.wickets?["2"] ?? 0)"
                self.secondmaidenValueLabel.text = "\(singlePlayerPoint?.maiden_overs?["1"] ?? 0)"
                self.secondeconValueLabel.text = "\(singlePlayerPoint?.economy?["2"] ?? 0)"
                self.secondrunOutValueLabel.text = "\(singlePlayerPoint?.runouts?["2"] ?? 0)"
                self.secondstumpingValueLabel.text = "\(singlePlayerPoint?.stumbeds?["2"] ?? 0)"
                
                
                if isInXIValueLabel.text == "Yes"{
                    self.isInXIPointLabel.text = "2"
                }else{
                    
                    self.isInXIPointLabel.text = "0.0"
                }
                
                if secondisInXIValueLabel.text == "Yes"{
                    
                    self.secondisInXIPointLabel.text = "2"
                }else{
                    self.secondisInXIPointLabel.text = "0.0"
                    
                }
                
                
                self.runsPointLabel.text = "\(Float((singlePlayerPoint?.runs?["1"])!) * 0.5)"
                self.fourPointLabel.text = "\(Float((singlePlayerPoint?.fours?["1"])!) * 0.5)"
                self.sixPointLabel.text = "\(Float((singlePlayerPoint?.sixes?["1"])!) * 1.0)"
                
                self.secondrunsPointLabel.text = "\(Float((singlePlayerPoint?.runs?["2"])!) * 0.5)"
                self.secondfourPointLabel.text = "\(Float((singlePlayerPoint?.fours?["2"])!) * 0.5)"
                self.secondsixPointLabel.text = "\(Float((singlePlayerPoint?.sixes?["2"])!) * 1.0)"
                
                self.strikePointLabel.text = "0"
                self.secondstrikePointLabel.text = "0"
                
                self.catchPointLabel.text = "\(Float((singlePlayerPoint?.catches?["1"])!) * 4.0)"
                self.secondcatchPointLabel.text = "\(Float((singlePlayerPoint?.catches?["2"])!) * 4.0)"
                
                self.wicketPointLabel.text = "\(Float((singlePlayerPoint?.wickets?["1"])!) * 8.0)"
                self.secondwicketPointLabel.text = "\(Float((singlePlayerPoint?.wickets?["2"])!) * 8.0)"
                
                self.maidenPointLabel.text = "0"
                self.secondmaidenPointLabel.text = "0"
                
                self.econPointLabel.text = "0"
                self.secondeconPointLabel.text = "0"
                
                self.runOutPointLabel.text = "\(Float((singlePlayerPoint?.runouts?["1"])!) * 4.0)"
                self.secondrunOutPointLabel.text = "\(Float((singlePlayerPoint?.runouts?["2"])!) * 4.0)"
                
                
                self.stumpingPointLabel.text = "\(Float((singlePlayerPoint?.stumbeds?["1"])!) * 6.0)"
                self.secondstumpingPointLabel.text = "\(Float((singlePlayerPoint?.stumbeds?["2"])!) * 6.0)"
                
                
                
                
                
            }else if self.matchType == "one-day" {
                
                if isInXIValueLabel.text == "Yes"{
                    self.isInXIPointLabel.text = "2"
                }else{
                    
                    self.isInXIPointLabel.text = "0.0"
                }
                
                if singlePlayerPoint?.runs != nil{
                    
                    self.runsPointLabel.text = "\(Float((singlePlayerPoint?.runs?["1"])!) * 0.5)"
                }
                if singlePlayerPoint?.fours != nil{
                    
                    self.fourPointLabel.text = "\(Float((singlePlayerPoint?.fours?["1"])!) * 0.5)"
                    
                }
                if singlePlayerPoint?.sixes != nil{
                    
                    self.sixPointLabel.text = "\(Float((singlePlayerPoint?.sixes?["1"])!) * 1.0)"
                    
                }
                
                if singlePlayerPoint?.strike_rate != nil{
                    
                    if singlePlayerInfo?.player_role != "bowler"{
                        
                        if (Float((singlePlayerPoint?.strike_rate?["1"])!) != 0.0 && Float((singlePlayerPoint?.strike_rate?["1"])!) < 40) {
                            
                            
                            self.strikePointLabel.text = "-3.0"
                            
                            
                            
                        }else if (Float((singlePlayerPoint?.strike_rate?["1"])!) < 49.99 && Float((singlePlayerPoint?.strike_rate?["1"])!) > 40  ){
                            
                            
                            self.strikePointLabel.text = "-2.0"
                            
                            
                        }else if (Float((singlePlayerPoint?.strike_rate?["1"])!) < 60 && Float((singlePlayerPoint?.strike_rate?["1"])!) >= 50  ){
                            
                            self.strikePointLabel.text = "-1.0"
                            
                            
                        }else{
                            self.strikePointLabel.text = "0.0"
                        }
                    }
                }
                if singlePlayerPoint?.catches != nil{
                    self.catchPointLabel.text = "\(Float((singlePlayerPoint?.catches?["1"])!) * 4.0)"
                    
                }
                
                if singlePlayerPoint?.wickets != nil{
                    self.wicketPointLabel.text = "\(Float((singlePlayerPoint?.wickets?["1"])!) * 12.0)"
                    
                }
                if singlePlayerPoint?.maiden_overs != nil{
                    self.maidenPointLabel.text = "\(Float((singlePlayerPoint?.maiden_overs?["1"])!) * 2.0)"
                }
                
                
                
                //Have to calculate like strike rate
                // self.econPointLabel.text = "\(Float((singlePlayerPoint?.sixes)!) * 1.0)"
                if singlePlayerPoint?.economy != nil{
                    
                    if (Float((singlePlayerPoint?.economy?["1"])!) != 0.0 && Float((singlePlayerPoint?.economy?["1"])!) < 2.5 ){
                        
                        self.econPointLabel.text = "3.0"
                        
                    }else if (Float((singlePlayerPoint?.economy?["1"])!) <= 3.49 && Float((singlePlayerPoint?.economy?["1"])!) >= 2.5  ){
                        
                        self.econPointLabel.text = "2.0"
                        
                        
                    }else if (Float((singlePlayerPoint?.economy?["1"])!) <= 4.5 && Float((singlePlayerPoint?.economy?["1"])!) >= 3.5  ){
                        
                        self.econPointLabel.text = "1.0"
                        
                        
                    }
                    else if (Float((singlePlayerPoint?.economy?["1"])!) <= 8 && Float((singlePlayerPoint?.economy?["1"])!) >= 7  ){
                        
                        self.econPointLabel.text = "-1.0"
                        
                        
                    }else if (Float((singlePlayerPoint?.economy?["1"])!) <= 9 && Float((singlePlayerPoint?.economy?["1"])!) >= 8.1  ){
                        
                        self.econPointLabel.text = "-2.0"
                        
                    } else if Float((singlePlayerPoint?.economy?["1"])!) > 9{
                        
                        self.econPointLabel.text = "-3.0"
                    }
                    else{
                        self.econPointLabel.text = "0.0"
                    }
                }
                
                if singlePlayerPoint?.runouts != nil{
                    
                    self.runOutPointLabel.text = "\(Float((singlePlayerPoint?.runouts?["1"])!) * 6.0)"
                }
                if singlePlayerPoint?.stumbeds != nil{
                    
                    self.stumpingPointLabel.text = "\(Float((singlePlayerPoint?.stumbeds?["1"])!) * 6.0)"
                }
                
                
                
            }else if self.matchType == "t20"{
                
                if isInXIValueLabel.text == "Yes"{
                    self.isInXIPointLabel.text = "2"
                }else{
                    
                    self.isInXIPointLabel.text = "0.0"
                }
                
                if singlePlayerPoint?.runs != nil{
                    self.runsPointLabel.text = "\(Float((singlePlayerPoint?.runs?["1"])!) * 0.5)"
                }
                if singlePlayerPoint?.fours != nil{
                    self.fourPointLabel.text = "\(Float((singlePlayerPoint?.fours?["1"])!) * 0.5)"
                }
                if singlePlayerPoint?.sixes != nil{
                    self.sixPointLabel.text = "\(Float((singlePlayerPoint?.sixes?["1"])!) * 1.0)"
                    
                }
                
                
                if singlePlayerPoint?.strike_rate != nil{
                    if singlePlayerInfo?.player_role != "bowler"{
                        
                        if ( Float((singlePlayerPoint?.strike_rate?["1"])!) != 0.0 && Float((singlePlayerPoint?.strike_rate?["1"])!) < 50 ){
                            
                            self.strikePointLabel.text = "-3.0"
                            
                        }else if (Float((singlePlayerPoint?.strike_rate?["1"])!) <= 59.99 && Float((singlePlayerPoint?.strike_rate?["1"])!) >= 50  ){
                            
                            self.strikePointLabel.text = "-2.0"
                            
                            
                        }else if (Float((singlePlayerPoint?.strike_rate?["1"])!) <= 70 && Float((singlePlayerPoint?.strike_rate?["1"])!) >= 60  ){
                            
                            self.strikePointLabel.text = "-1.0"
                            
                            
                        }else{
                            self.strikePointLabel.text = "0.0"
                        }
                    }
                }
                
                if singlePlayerPoint?.catches != nil{
                    self.catchPointLabel.text = "\(Float((singlePlayerPoint?.catches?["1"])!) * 4.0)"
                }
                if singlePlayerPoint?.wickets != nil{
                    self.wicketPointLabel.text = "\(Float((singlePlayerPoint?.wickets?["1"])!) * 10.0)"
                    
                }
                if singlePlayerPoint?.maiden_overs != nil{
                    self.maidenPointLabel.text = "\(Float((singlePlayerPoint?.maiden_overs?["1"])!) * 4.0)"
                }
                
                
                
                //Have to calculate like strike rate
                // self.econPointLabel.text = "\(Float((singlePlayerPoint?.sixes)!) * 1.0)"
                if singlePlayerPoint?.economy != nil{
                    if ( Float((singlePlayerPoint?.economy?["1"])!) != 0.0 && Float((singlePlayerPoint?.economy?["1"])!) < 4 ){
                        
                        self.econPointLabel.text = "3.0"
                        
                    }else if (Float((singlePlayerPoint?.economy?["1"])!) <= 4.99 && Float((singlePlayerPoint?.economy?["1"])!) >= 4  ){
                        
                        self.econPointLabel.text = "2.0"
                        
                        
                    }else if (Float((singlePlayerPoint?.economy?["1"])!) <= 5.99 && Float((singlePlayerPoint?.economy?["1"])!) >= 5  ){
                        
                        self.econPointLabel.text = "1.0"
                        
                        
                    }
                    else if (Float((singlePlayerPoint?.economy?["1"])!) <= 9.99 && Float((singlePlayerPoint?.economy?["1"])!) >= 9  ){
                        
                        self.econPointLabel.text = "-1.0"
                        
                        
                    }else if (Float((singlePlayerPoint?.economy?["1"])!) <= 11 && Float((singlePlayerPoint?.economy?["1"])!) >= 10  ){
                        
                        self.econPointLabel.text = "-2.0"
                    } else if Float((singlePlayerPoint?.economy?["1"])!) > 11{
                        
                        self.econPointLabel.text = "-3.0"
                    }else{
                        self.econPointLabel.text = "0.0"
                    }
                }
                
                if singlePlayerPoint?.runouts != nil{
                    self.runOutPointLabel.text = "\(Float((singlePlayerPoint?.runouts?["1"])!) * 6.0)"
                }
                if singlePlayerPoint?.stumbeds != nil{
                    self.stumpingPointLabel.text = "\(Float((singlePlayerPoint?.stumbeds?["1"])!) * 6.0)"
                    
                }
                
                
            }else if self.matchType == "t10"{
                
                if isInXIValueLabel.text == "Yes"{
                    self.isInXIPointLabel.text = "2"
                }else{
                    
                    self.isInXIPointLabel.text = "0.0"
                }
                
                if singlePlayerPoint?.runs != nil{
                    self.runsPointLabel.text = "\(Float((singlePlayerPoint?.runs?["1"])!) * 0.5)"
                }
                if singlePlayerPoint?.fours != nil{
                    self.fourPointLabel.text = "\(Float((singlePlayerPoint?.fours?["1"])!) * 0.5)"
                }
                if singlePlayerPoint?.sixes != nil{
                    self.sixPointLabel.text = "\(Float((singlePlayerPoint?.sixes?["1"])!) * 1.0)"
                    
                }
                
                
                if singlePlayerPoint?.strike_rate != nil{
                    
                    if singlePlayerInfo?.player_role != "bowler"{
                        
                        if (Float((singlePlayerPoint?.strike_rate?["1"])!) != 0.0 && Float((singlePlayerPoint?.strike_rate?["1"])!) < 80 ) {
                            
                            self.strikePointLabel.text = "-3.0"
                            
                        }else if (Float((singlePlayerPoint?.strike_rate?["1"])!) <= 89.99 && Float((singlePlayerPoint?.strike_rate?["1"])!) >= 80  ){
                            
                            self.strikePointLabel.text = "-2.0"
                            
                            
                        }else if (Float((singlePlayerPoint?.strike_rate?["1"])!) <= 90.99 && Float((singlePlayerPoint?.strike_rate?["1"])!) >= 90  ){
                            
                            self.strikePointLabel.text = "-1.0"
                            
                            
                        }else{
                            self.strikePointLabel.text = "0.0"
                        }
                    }
                }
                
                if singlePlayerPoint?.catches != nil{
                    self.catchPointLabel.text = "\(Float((singlePlayerPoint?.catches?["1"])!) * 4.0)"
                }
                if singlePlayerPoint?.wickets != nil{
                    self.wicketPointLabel.text = "\(Float((singlePlayerPoint?.wickets?["1"])!) * 10.0)"
                    
                }
                if singlePlayerPoint?.maiden_overs != nil{
                    self.maidenPointLabel.text = "\(Float((singlePlayerPoint?.maiden_overs?["1"])!) * 8.0)"
                }
                
                
                
                //Have to calculate like strike rate
                // self.econPointLabel.text = "\(Float((singlePlayerPoint?.sixes)!) * 1.0)"
                if singlePlayerPoint?.economy != nil{
                    if  (Float((singlePlayerPoint?.economy?["1"])!) != 0.0 && Float((singlePlayerPoint?.economy?["1"])!) < 6 ) {
                        
                        self.econPointLabel.text = "6.0"
                        
                    }else if (Float((singlePlayerPoint?.economy?["1"])!) <= 6.99 && Float((singlePlayerPoint?.economy?["1"])!) >= 6  ){
                        
                        self.econPointLabel.text = "4.0"
                        
                        
                    }else if (Float((singlePlayerPoint?.economy?["1"])!) <= 7.99 && Float((singlePlayerPoint?.economy?["1"])!) >= 7  ){
                        
                        self.econPointLabel.text = "2.0"
                        
                        
                    }
                    else if (Float((singlePlayerPoint?.economy?["1"])!) < 12 && Float((singlePlayerPoint?.economy?["1"])!) >= 11  ){
                        
                        self.econPointLabel.text = "-2.0"
                        
                        
                    }else if (Float((singlePlayerPoint?.economy?["1"])!) <= 13 && Float((singlePlayerPoint?.economy?["1"])!) >= 12  ){
                        
                        self.econPointLabel.text = "-3.0"
                    } else if Float((singlePlayerPoint?.economy?["1"])!) > 13{
                        
                        self.econPointLabel.text = "-4.0"
                        
                    }else{
                        self.econPointLabel.text = "0.0"
                    }
                }
                
                if singlePlayerPoint?.runouts != nil{
                    self.runOutPointLabel.text = "\(Float((singlePlayerPoint?.runouts?["1"])!) * 6.0)"
                }
                if singlePlayerPoint?.stumbeds != nil{
                    self.stumpingPointLabel.text = "\(Float((singlePlayerPoint?.stumbeds?["1"])!) * 6.0)"
                    
                }
                
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
