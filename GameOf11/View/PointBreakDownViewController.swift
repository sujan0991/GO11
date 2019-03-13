//
//  PointBreakDownViewController.swift
//  CompleteCont
//
//  Created by Md.Ballal Hossen on 12/3/19.
//  Copyright © 2019 Sujan. All rights reserved.
//

import UIKit

class PointBreakDownViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    
    var matchId = 0
    var teamId = 0
    
    var leaderBoardData:BreakDownData?
    var playerInfo:PlayerInfoData?
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var pointTableView: UITableView!
    
    @IBOutlet weak var breakdownView: UIView!
    
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var playernameLabel: UILabel!
    @IBOutlet weak var playerRollLabel: UILabel!
    @IBOutlet weak var playerPointLabel: UILabel!
    
    @IBOutlet weak var isInXIValueLabel: UILabel!
    @IBOutlet weak var isInXIPointLabel: UILabel!
    
    @IBOutlet weak var runsValueLabel: UILabel!
    @IBOutlet weak var runsPointLabel: UILabel!
    
    @IBOutlet weak var fourValueLabel: UILabel!
    @IBOutlet weak var fourPointLabel: UILabel!
    
    @IBOutlet weak var sixValueLabel: UILabel!
    @IBOutlet weak var sixPointLabel: UILabel!
    
    @IBOutlet weak var strikeValueLabel: UILabel!
    @IBOutlet weak var strikePointLabel: UILabel!
    
    @IBOutlet weak var catchValueLabel: UILabel!
    @IBOutlet weak var catchPointLabel: UILabel!
    
    @IBOutlet weak var wicketValueLabel: UILabel!
    @IBOutlet weak var wicketPointLabel: UILabel!
    
    @IBOutlet weak var maidenValueLabel: UILabel!
    @IBOutlet weak var maidenPointLabel: UILabel!
    
    @IBOutlet weak var econValueLabel: UILabel!
    @IBOutlet weak var econPointLabel: UILabel!
    
    @IBOutlet weak var runOutValueLabel: UILabel!
    @IBOutlet weak var runOutPointLabel: UILabel!
    
    @IBOutlet weak var stumpingValueLabel: UILabel!
    @IBOutlet weak var stumpingPointLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeNavBar(withTitle: "POINT BREAKDOWN", isBackBtnVisible: true)
        
        pointTableView.delegate = self
        pointTableView.dataSource = self
        
        print("......",self.matchId,self.teamId)
        pointTableView.isHidden = true
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cellIdentifier = "headerCell"
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       showPointBreakDown()
       let singlePlayerInfo = self.leaderBoardData?.team_info?.player_info[indexPath.row]
        
       let singlePlayerPoint = singlePlayerInfo?.point_breakdown
        
        self.playernameLabel.text = singlePlayerInfo?.player_name
        self.playerRollLabel.text = singlePlayerInfo?.player_role
        self.playerPointLabel.text = "\(singlePlayerInfo?.player_earning_point ?? 0)"
       
        self.isInXIValueLabel.text = singlePlayerInfo?.is_in_playing_xi
        self.runsValueLabel.text = "\(singlePlayerPoint?.runs ?? 0)"
        self.fourValueLabel.text = "\(singlePlayerPoint?.fours ?? 0)"
        self.sixValueLabel.text = "\(singlePlayerPoint?.sixes ?? 0)"
        self.strikeValueLabel.text = "\(singlePlayerPoint?.strike_rate ?? 0)"
        self.catchValueLabel.text = "\(singlePlayerPoint?.catches ?? 0)"
        self.wicketValueLabel.text = "\(singlePlayerPoint?.wickets ?? 0)"
        self.maidenValueLabel.text = "\(singlePlayerPoint?.maiden_overs ?? 0)"
        self.econValueLabel.text = "\(singlePlayerPoint?.economy ?? 0)"
        self.runOutValueLabel.text = "\(singlePlayerPoint?.runouts ?? 0)"
        self.stumpingValueLabel.text = "\(singlePlayerPoint?.stumbeds ?? 0)"
        
        
    }
    
    
    func showPointBreakDown() {
        
         self.view.bringSubviewToFront(breakdownView)
        
         breakdownView.isHidden = false
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        print("closeButtonAction")
        breakdownView.isHidden = true
    }
    
    

}
