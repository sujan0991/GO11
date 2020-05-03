//
//  TeamSelectViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 18/4/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class TeamSelectViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var delegate: BackFromTeamSelect?
    
    var teams:[CreatedTeam] = []
    var teamsFootball:[CreatedTeamFootball] = []
    var contestId: Int = 0
    
    var selectedIndex : Int!
    
    @IBOutlet weak var confirmView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var teamTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("teams........",teams)
        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "SELECT YOUR TEAM".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        confirmButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        confirmButton.setTitle("JOIN CONTEST".localized, for: .normal)
        confirmButton.layer.shadowColor = UIColor.gray.cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        confirmButton.layer.shadowRadius = 2
        confirmButton.layer.shadowOpacity = 0.5
        confirmButton.layer.masksToBounds = false
        
        
        if (teamTableView != nil)
        {
            teamTableView.register(UINib(nibName: "CreatedTeamTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatedTeamTableViewCell")
            
            teamTableView.delegate = self
            teamTableView.dataSource = self
            teamTableView.removeEmptyCells()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if #available(iOS 13, *) {
                  if UserDefaults.standard.bool(forKey: "DarkMode"){
                      
                      overrideUserInterfaceStyle = .dark
                      
                  }else{
                      overrideUserInterfaceStyle = .light
                  }
              
              }else{
                  
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"CreatedTeamTableViewCell") as! CreatedTeamTableViewCell
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            let singleTeam = teams[indexPath.section] as CreatedTeam
            
            cell.keeperLabel.text = "WK"
            cell.batsmanLabel.text = "BAT"
            cell.allrounderLabel.text = "AL"
            cell.bowlerLabel.text = "BOWL"
            
            cell.setInfo(singleTeam)
            //  cell.selectView.isHidden = false
        }else{
            let singleTeam = teamsFootball[indexPath.section] as CreatedTeamFootball
            
            cell.keeperLabel.text = "GK"
            cell.batsmanLabel.text = "DEF"
            cell.allrounderLabel.text = "MID"
            cell.bowlerLabel.text = "STR"
            
            cell.setInfoFootball(singleTeam)
            
        }
        
        
        if selectedIndex == indexPath.section
        {
            cell.selectTeamButton.isSelected = true
            
        }
        else
        {
            cell.selectTeamButton.isSelected = false
        }
        cell.selectTeamButton.tag = indexPath.section
        // cell.confirmButton.tag = singleTeam.userTeamId ?? 0
        
        cell.selectTeamButton.addTarget(self, action: #selector(teamSelectAction(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            let singleTeam = teams[selectedIndex] as CreatedTeam
            
            if let delegate = self.delegate {
                
                delegate.selectedTeam(team: singleTeam,contestId: self.contestId)
            }
            
            print("team name...........?????????",singleTeam.teamName)
            dismiss(animated: true, completion: nil)
        }else{
            let singleTeam = teamsFootball[selectedIndex] as CreatedTeamFootball
            
            if let delegate = self.delegate {
                
                delegate.selectedTeamFootball(team: singleTeam,contestId: self.contestId)
            }
            
            print("team name...........?????????",singleTeam.teamName)
            dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func teamSelectAction(_ sender: UIButton) {
        
        selectedIndex = sender.tag
        self.teamTableView.reloadData()
        
        self.confirmView.isHidden = false
        
        
        //        let cell = teamTableView.cellForRow(at: IndexPath.init(item: 0, section: sender.tag)) as! CteatedTableViewCell
        //
        //        cell.confirmButton.isHidden = false
        
        
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
