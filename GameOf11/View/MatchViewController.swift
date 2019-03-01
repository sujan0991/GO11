//
//  MatchViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit


class MatchViewController : BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var matches:[MatchList] = []
    
    var type : MatchType = .next
    
    @IBOutlet weak var matchListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        if (matchListTableView != nil)
        {
            matchListTableView.register(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchCell")
            
            matchListTableView.delegate = self
            matchListTableView.dataSource = self
            matchListTableView.removeEmptyCells()
        }
        if type == .next
        {
            APIManager.manager.getUpcomingMatchList { (nextMatches) in
                self.matches = nextMatches
                self.matchListTableView.reloadData()
            }
        }
        else  if type == .live
        {
            APIManager.manager.getLiveMatchList { (nextMatches) in
                self.matches = nextMatches
                self.matchListTableView.reloadData()
            }
        }
        else  if type == .upcomingContest
        {
            APIManager.manager.getUserJoinedUpcomingMatchList { (nextMatches) in
                self.matches = nextMatches
                self.matchListTableView.reloadData()
            }
        }
        else  if type == .liveContest
        {
            APIManager.manager.getUserJoinedLiveMatchList { (nextMatches) in
                self.matches = nextMatches
                self.matchListTableView.reloadData()
            }
        }
        else  if type == .completedContest
        {
            APIManager.manager.getUserJoinedCompletedMatchList { (nextMatches) in
                self.matches = nextMatches
                self.matchListTableView.reloadData()
            }
        }
      
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"MatchCell") as! MatchTableViewCell
        let match = matches[indexPath.section]
        cell.setInfo(match)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let match = matches[indexPath.section]
        
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContestListViewController") as? ContestListViewController
        
        popupVC?.parentMatch = match
        popupVC?.modalPresentationStyle = .overCurrentContext
        popupVC?.modalTransitionStyle = .crossDissolve
        
        self.present(popupVC!, animated: true) {
            print("")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init()
        view.backgroundColor = .clear
        return view
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
