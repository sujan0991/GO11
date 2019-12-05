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
    var squadData: MatchSquadData!
    var parentMatch: MatchList? = nil
    
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
        
        placeNavBar(withTitle: "MY TEAMS".localized, isBackBtnVisible: true,isLanguageBtnVisible: false)
        
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
        createTeamButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        
        createTeamButton.setTitle("Create Another Team".localized, for: .normal)
        
        self.firstTeamName.text = self.parentMatch?.teams.item(at: 0).teamKey ?? ""
        self.secondTeamName.text = self.parentMatch?.teams.item(at: 1).teamKey ?? ""
        self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatch?.joiningLastTime ?? "" )
        
        
        
        let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatch?.teams.item(at: 0).logo ?? "")")
        let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatch?.teams.item(at: 1).logo ?? "")")
        self.firstTeamFlag.kf.setImage(with: url1)
        self.secondTeamFlag.kf.setImage(with: url2)
        
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
        
        
        getSquadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("viewDidAppear in myteamview")
    }
    
    
    func getSquadData(){
        
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
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"CreatedTeamCell") as! CteatedTableViewCell
        
        let singleTeam = teams[indexPath.section] as CreatedTeam
        
        cell.setInfo(singleTeam)
        
        cell.editButton.tag = singleTeam.userTeamId!
        cell.previewButton.tag = singleTeam.userTeamId!
        
        cell.previewButton.addTarget(self, action: #selector(showPreview(_:)), for: .touchUpInside)
        
        cell.editButton.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)

        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    @IBAction func createNewTeam(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamCreateViewController") as? TeamCreateViewController
        
        popupVC?.squadData = squadData
        popupVC?.timeLeft = self.parentMatch?.joiningLastTime
        
        self.navigationController?.pushViewController(popupVC ?? self, animated: true)
    }
    
    @objc func showPreview(_ sender: UIButton){
    
        print("showPreview button action MyTeamViewController")
        
        let popupVC:TeamPreviewViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamPreviewViewController") as? TeamPreviewViewController)!
        
        
        popupVC.pvSquadData = squadData
        popupVC.userTeamId = sender.tag
        popupVC.isAlreadyCreatedTeam = true
        
        self.navigationController?.pushViewController(popupVC, animated: true)
        
    }
    
    
    
    @objc func editButtonAction(_ sender: UIButton){
        
        print("editButtonAction button action MyTeamViewController")
        
        let popupVC:EditTeamViewController = (UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditTeamViewController") as? EditTeamViewController)!
        
       
        popupVC.squadData = squadData
        popupVC.userTeamId = sender.tag
        popupVC.timeLeft = self.parentMatch?.joiningLastTime
        
        
        self.navigationController?.pushViewController(popupVC, animated: true)
       
    }

}
