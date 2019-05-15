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
        
        placeNavBar(withTitle: "Contests", isBackBtnVisible: true)
        
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
        createTeamButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        
        self.firstTeamName.text = self.parentMatch?.teams.item(at: 0).teamKey ?? ""
        self.secondTeamName.text = self.parentMatch?.teams.item(at: 1).teamKey ?? ""
        self.statusLabel.text = String.init(format: "Ends: %@",self.parentMatch?.joiningLastTime ?? "" )
        
        
        
        let url1 = URL(string: "\(API_K.BaseUrlStr)\(self.parentMatch?.teams.item(at: 0).logo ?? "")")
        let url2 = URL(string: "\(API_K.BaseUrlStr)\(self.parentMatch?.teams.item(at: 1).logo ?? "")")
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
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
        
        
        cell.previewButton.addTarget(self, action: #selector(showPreview(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    @IBAction func createNewTeam(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamCreateViewController") as? TeamCreateViewController
        
        popupVC?.modalPresentationStyle = .overCurrentContext
        popupVC?.modalTransitionStyle = .crossDissolve
        popupVC?.squadData = squadData
        
        self.present(popupVC!, animated: true) {
            print("")
        }
    }
    
    @objc func showPreview(_ sender: UIButton){
    
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamPreviewViewController") as? TeamPreviewViewController
        
        popupVC?.modalPresentationStyle = .overCurrentContext
        popupVC?.modalTransitionStyle = .crossDissolve
        popupVC?.squadData = squadData
        
        self.navigationController?.pushViewController(popupVC ?? self, animated: true)
    
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
