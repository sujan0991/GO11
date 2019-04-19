//
//  TeamSelectViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 18/4/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class TeamSelectViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var teams:[CreatedTeam] = []
    var contestId: Int = 0
    
    var selectedIndex : Int!
    
    @IBOutlet weak var confirmView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var teamTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "Select Team", isBackBtnVisible: true)
        confirmButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        if (teamTableView != nil)
        {
            teamTableView.register(UINib(nibName: "CteatedTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatedTeamCell")
            
            teamTableView.delegate = self
            teamTableView.dataSource = self
            teamTableView.removeEmptyCells()
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
        cell.selectView.isHidden = false
        
        
        if selectedIndex == indexPath.section
        {
            cell.selectButton.isSelected = true
            
        }
        else
        {
             cell.selectButton.isSelected = false
        }
        cell.selectButton.tag = indexPath.section
     // cell.confirmButton.tag = singleTeam.userTeamId ?? 0
        
        cell.selectButton.addTarget(self, action: #selector(teamSelectAction(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        
        let singleTeam = teams[selectedIndex] as CreatedTeam
        
        
        APIManager.manager.joinInContestWith(contestId: String.init(format: "%d", contestId), teamId: String.init(format: "%d", singleTeam.userTeamId ?? 0), withCompletionHandler: { (status, msg) in
            if status{
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            else{
                self.showStatus(status, msg: msg)
            }
        })
       
        
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
