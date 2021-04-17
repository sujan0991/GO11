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
    var forTeamChange = false
   
    var selectedTeamId : Int!
    var selectedIndex : Int!
    
    var isSelectButtonCliked = false
    
    @IBOutlet weak var confirmView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var teamTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("teams........??? \(selectedTeamId)")
        // Do any additional setup after loading the view.
       
      
        
        placeNavBar(withTitle: "SELECT YOUR TEAM".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        confirmButton.setTitle("JOIN CONTEST".localized, for: .normal)
        
        
      
        if (self.forTeamChange)
        {
            placeNavBar(withTitle: "CHANGE YOUR TEAM".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
            confirmButton.setTitle("CHANGE TEAM".localized, for: .normal)
               
        }
        
        confirmButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
       
//        confirmButton.makeRound(5, borderWidth: 0, borderColor: .clear)
//
//        confirmButton.layer.shadowColor = UIColor.gray.cgColor
//        confirmButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        confirmButton.layer.shadowRadius = 2
//        confirmButton.layer.shadowOpacity = 0.5
//        confirmButton.layer.masksToBounds = false
        
        
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
        
        print("selectedIndex.......cellForRowAt",selectedIndex,forTeamChange)
        
        if forTeamChange{
                     
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                
                let singleTeam = teams[indexPath.section] as CreatedTeam
                
                if singleTeam.userTeamId == selectedTeamId{
                    
                    cell.selectTeamButton.isSelected = true
                    
                }else{
                    
                    cell.selectTeamButton.isSelected = false
                    
                }
                
            }else{
                
                let singleTeam = teamsFootball[indexPath.section] as CreatedTeamFootball
                
                if singleTeam.userTeamId == selectedTeamId{
                    
                    cell.selectTeamButton.isSelected = true
                    
                }else{
                    
                    cell.selectTeamButton.isSelected = false
                    
                }

            }
            
        }
        
        if isSelectButtonCliked{
            
            if selectedIndex == indexPath.section
                   {
                       cell.selectTeamButton.isSelected = true
                       
                   }
                   else
                   {
                       cell.selectTeamButton.isSelected = false
                   }
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
        
        
        if self.forTeamChange {
                    let alertVC = UIAlertController(title: nil, message: "You are changing your team, Want to join using the new team".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Confirm", style: .default, handler: { (aciton) in
                        self.changeContestTeam()
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        alertVC.dismiss(animated: true, completion: nil)
                    })
            
                    alertVC.addAction(okAction)
                    alertVC.addAction(cancelAction)
            
                    self.present(alertVC, animated: true, completion: nil)
        }
        else
        {
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                
                let singleTeam = teams[selectedIndex] as CreatedTeam
                
                if let delegate = self.delegate {
                    
                    delegate.selectedTeam(team: singleTeam,contestId: self.contestId)
                }
                
              //  print("team name...........?????????",singleTeam.teamName)
                dismiss(animated: true, completion: nil)
            }else{
                let singleTeam = teamsFootball[selectedIndex] as CreatedTeamFootball
                
                if let delegate = self.delegate {
                    
                    delegate.selectedTeamFootball(team: singleTeam,contestId: self.contestId)
                }
                
         //       print("team name...........?????????",singleTeam.teamName)
                dismiss(animated: true, completion: nil)
            }
        }
    
    }
    
    @IBAction func teamSelectAction(_ sender: UIButton) {
        
        isSelectButtonCliked = true
        selectedIndex = sender.tag
        self.teamTableView.reloadData()
        
        self.confirmView.isHidden = false
        
    }
    
    func changeContestTeam() {
       
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            let singleTeam = teams[selectedIndex] as CreatedTeam
            
            APIManager.manager.updateTeamInContestWith(contestId: String.init(format: "%d",  self.contestId), teamId: String.init(format: "%d", singleTeam.userTeamId!), forTeamType: "cricket", withCompletionHandler: { (status, msg) in
                if status{
                    
                    //update joined contest
                    self.view.makeToast(msg!)
                    NotificationCenter.default.post(name: Notification.Name("updateContestDetails"), object: nil, userInfo: nil)
                }
                else{
                    self.view.makeToast(msg!)
                }
            })
            
        }else{
            let singleFootballTeam = teamsFootball[selectedIndex] as CreatedTeamFootball
     
            APIManager.manager.updateTeamInContestWith(contestId: String.init(format: "%d", self.contestId), teamId: String.init(format: "%d", singleFootballTeam.userTeamId!),forTeamType: "football", withCompletionHandler: { (status, msg) in
                if status{
                    
                    //update contest list
                    self.view.makeToast(msg!)
                    NotificationCenter.default.post(name: Notification.Name("updateContestDetails"), object: nil, userInfo: nil)
           
                }
                else{
                    
                    self.view.makeToast(msg!)
                }
            })
            
        }
        dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name("updateContestDetails"), object: nil, userInfo: nil)
           
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
