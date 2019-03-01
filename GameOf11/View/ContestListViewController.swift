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
    
    @IBOutlet weak var matchSummaryView: UIView!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var firstTeamFlag: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var secondTeamFlag: UIImageView!
    
    @IBOutlet weak var contestTableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var parentMatch: MatchList? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeNavBar(withTitle: "Contests", isBackBtnVisible: true)
        
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
        nextButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        
        contestTableView.register(UINib(nibName: "ContestTableViewCell", bundle: nil), forCellReuseIdentifier: "contestCell")
        
        contestTableView.delegate = self
        contestTableView.dataSource = self
        contestTableView.removeEmptyCells()
        
        
        
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
        
        self.firstTeamName.text = self.parentMatch?.teams.item(at: 0).teamKey ?? ""
        self.secondTeamName.text = self.parentMatch?.teams.item(at: 1).teamKey ?? ""
        self.statusLabel.text = String.init(format: "Ends: %@",self.parentMatch?.joiningLastTime ?? "" )
        
        
        
        let url1 = URL(string: "\(API_K.BaseUrlStr)\(self.parentMatch?.teams.item(at: 0).logo ?? "")")
        let url2 = URL(string: "\(API_K.BaseUrlStr)\(self.parentMatch?.teams.item(at: 1).logo ?? "")")
        self.firstTeamFlag.kf.setImage(with: url1)
        self.secondTeamFlag.kf.setImage(with: url2)

    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        APIManager.manager.getMatchSquad(matchId: "\(parentMatch?.matchId ?? 0)") { (status, matchSquad, msg) in
            if status{
                if matchSquad != nil{
                    //self.activeContestList = (matchSquad?.contests)!
                    self.nextButton.isEnabled = true
                    self.squadData = matchSquad

                }
            }
            else{
                self.showStatus(status, msg: msg)
            }
        }
        
//        APIManager.manager.getTeamForMatch(matchId: "\(parentMatch?.matchId ?? 0)") { (status, createdTeam, msg) in
//            if status{
//
//                if createdTeam != nil{
//                    //    self.activeContestList = (matchSquad?.contests)!
//                }
//            }
//            else{
//                self.showStatus(status, msg: msg)
//            }
//        }
        
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
    
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        
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
        
        self.present(popupVC!, animated: true) {
            print("")
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
