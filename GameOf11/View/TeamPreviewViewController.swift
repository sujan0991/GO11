//
//  TeamPreviewViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 27/2/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class TeamPreviewViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource {

    var squadData : MatchSquadData!
    
    var batsmanList:[Player] = []
    var bowlerList:[Player] = []
    var keeperList:[Player] = []
    var allRounderList:[Player] = []
    
    @IBOutlet weak var teamTableView: UITableView!
    
    
    @IBOutlet weak var previewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
         placeNavBar(withTitle: "Team Preview", isBackBtnVisible: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
        squadData.playersList = squadData.playersList.filter{($0 as Player).playerSelected == true }
        
        if squadData != nil
        {
            for player in squadData.playersList
            {
                switch (player.role) {
                case "batsman":
                    batsmanList.append(player)
                    break;
                case "bowler":
                    bowlerList.append(player)
                    break;
                case "keeper":
                    keeperList.append(player)
                    break;
                case "allrounder":
                    allRounderList.append(player)
                    break;
                    
                default:
                    break;
                }
                
            }
            
            teamTableView.delegate = self
            teamTableView.dataSource = self
            teamTableView.removeEmptyCells()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"previewPlayerCell") as! PreviewTableViewCell
        
        if indexPath.section == 0
        {
            cell.setInfo(players: keeperList,squad: squadData.teams!)
        }
        else if indexPath.section == 1
        {
            cell.setInfo(players: batsmanList,squad: squadData.teams!)
        }
        else if indexPath.section == 2
        {
            cell.setInfo(players: allRounderList,squad: squadData.teams!)
        }
        else
        {
            cell.setInfo(players: bowlerList,squad: squadData.teams!)
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textColor = UIColor.init(named: "BackgroundColor") // my custom colour
        label.textAlignment = .center
        headerView.addSubview(label)
        
        if section == 1
        {
            label.text = "Batsman"
        }
        else if section == 2
        {
            label.text = "All rounders"
        }
        else if section == 3
        {
            label.text = "Bowlers"
        }
        else
        {
            label.text = "Wicket Keeper"
        }
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.size.height - 200)/4
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
