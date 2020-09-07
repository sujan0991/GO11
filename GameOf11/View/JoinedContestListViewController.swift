//
//  JoinedContestListViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 12/7/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class JoinedContestListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var joinedContestList:[ContestData] = []
    var parentMatch: MatchList? = nil
    var parentMatchFootball: FootBallMatchList? = nil
    
    var prizeFilteredArray: [PrizeRankCal] = []
    
    @IBOutlet weak var firstTeamFlag: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var secondTeamFlag: UIImageView!
    
    
    
    @IBOutlet weak var contestTableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var prizeListTitleLabel: UILabel!
    @IBOutlet weak var matchSummaryView: UIView!
    
    @IBOutlet weak var prizeRankView: UIView!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var prizeRankTableView: UITableView!
    @IBOutlet weak var prizeRankViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backShadowView: UIView!
    
    var isFreeContest = 1
    let formatter = NumberFormatter()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeNavBar(withTitle: "JOINED CONTESTS".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
     
        prizeListTitleLabel.text = "Prize List".localized
        taxLabel.text = "Tax Msg".localized
        
        contestTableView.register(UINib(nibName: "ContestTableViewCell", bundle: nil), forCellReuseIdentifier: "contestCell")
        
        contestTableView.delegate = self
        contestTableView.dataSource = self
        contestTableView.removeEmptyCells()
        
        prizeRankTableView.delegate = self
        prizeRankTableView.dataSource = self
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            self.firstTeamName.text = self.parentMatch?.teams.item(at: 0).teamKey?.uppercased() ?? ""
            self.secondTeamName.text = self.parentMatch?.teams.item(at: 1).teamKey?.uppercased() ?? ""
            self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatch?.joiningLastTime ?? "" )
            
            self.firstTeamFlag.image = UIImage.init(named: "teamPlaceHolder_icon")
            self.secondTeamFlag.image = UIImage.init(named: "teamPlaceHolder_icon")
            
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatch?.teams.item(at: 0).logo ?? "")")
            let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatch?.teams.item(at: 1).logo ?? "")")
            self.firstTeamFlag.kf.setImage(with: url1)
            self.secondTeamFlag.kf.setImage(with: url2)
            
        }else{
            
            
            self.firstTeamName.text = self.parentMatchFootball?.teams.item(at: 0).code?.uppercased() ?? ""
            self.secondTeamName.text = self.parentMatchFootball?.teams.item(at: 1).code?.uppercased() ?? ""
            self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatchFootball?.joiningLastTime ?? "" )
            
            self.firstTeamFlag.image = UIImage.init(named: "placeholder_football_team_logo")
            self.secondTeamFlag.image = UIImage.init(named: "placeholder_football_team_logo")
            
            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatchFootball?.teams.item(at: 0).logo ?? "")")
            let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatchFootball?.teams.item(at: 1).logo ?? "")")
            self.firstTeamFlag.kf.setImage(with: url1)
            self.secondTeamFlag.kf.setImage(with: url2)
            
        }
        
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backShadowView.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prizeRankView.isHidden = true
        
        if #available(iOS 13, *) {
                  if UserDefaults.standard.bool(forKey: "DarkMode"){
                      
                      overrideUserInterfaceStyle = .dark
                      
                  }else{
                      overrideUserInterfaceStyle = .light
                  }
              
              }else{
                  
              }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        backShadowView.isHidden = true
        prizeRankView.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.contestTableView{
            return 1
        }else{
            
            return prizeFilteredArray.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == self.contestTableView{
            return joinedContestList.count
        }else{
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == contestTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier:"contestCell") as! ContestTableViewCell
            
            let contest = joinedContestList[indexPath.section]
            cell.setInfo(contest)
            
            cell.joinedButton.isHidden = true
            
            cell.totalWinnerButton.tag = indexPath.section
            
            cell.totalWinnerButton.addTarget(self, action: #selector(prizeCalculation(_:)), for: .touchUpInside)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"rankCell") as! PrizeListTableViewCell
            
            let singlePrize = prizeFilteredArray[indexPath.row]
            
            //  print("singlePrize........",singlePrize.amount)
            
            var bnLowRankString : String!
            var bnHighRankString : String!
            var bnPrizeAmountString : String!
            
            if Language.language == Language.english{
                bnLowRankString = String(singlePrize.lowRank!)
                if singlePrize.hignRank != nil {
                    bnHighRankString = String(singlePrize.hignRank!)
                }
                bnPrizeAmountString = String(singlePrize.amount!)
         
               
            }else{
                bnLowRankString = self.formatter.string(for: singlePrize.lowRank! )
                if singlePrize.hignRank != nil {
                    bnHighRankString = self.formatter.string(for: singlePrize.hignRank! )
           
                }
                bnPrizeAmountString = self.formatter.string(for: singlePrize.amount! )
            }
            
            if singlePrize.hignRank == nil{
                //cell.rankLabel.text = "Rank \(singlePrize.lowRank!)"
                cell.rankLabel.text =  String.init(format: "Rank %@".localized, bnLowRankString!)
               
            }else{
                _ = self.formatter.string(for: singlePrize.lowRank! )
                _ = self.formatter.string(for: singlePrize.hignRank! )
           
              //  cell.rankLabel.text = "Rank \(singlePrize.lowRank!) - Rank \(singlePrize.hignRank!)"
                cell.rankLabel.text =  String.init(format: "Rank %@ - Rank %@".localized, bnLowRankString!,bnHighRankString!)
         
            }
            cell.amountLabel.text = bnPrizeAmountString //"\(singlePrize.amount!)"
            
            if isFreeContest == 1{
                
                cell.prizeIconImageView.image = UIImage(named: "coinIcon")
            }else{
                cell.prizeIconImageView.image = UIImage(named: "takaIcon")
            }
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == contestTableView{
            
            print("didSelectRowAt ",self.tabBarController?.selectedIndex)
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let VC = storyboard.instantiateViewController(withIdentifier: "ContestLeaderBoardViewController") as! ContestLeaderBoardViewController
            
            let contest = joinedContestList[indexPath.section]
            
            VC.contest_id = contest.id
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                
                VC.match_id = parentMatch?.matchId
            }else{
                VC.match_id = parentMatchFootball?.matchId
            }
            VC.contestName = contest.name
            
            // self.navigationController?.pushViewController(VC, animated: true)
            
            self.present(VC, animated: true) {
                
                print("open")
                
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == contestTableView{
            let contest = joinedContestList[indexPath.section]
            
            if contest.is_league! == 1{
                
                return 225
            }else{
                return 185
            }
            
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
        
    }
    
    @IBAction func prizeCalculation(_ sender: UIButton) {
        
        
        self.prizeFilteredArray = []
        
        let selectedContest = joinedContestList[sender.tag]
        
        if selectedContest.contestType == "free"{
            
            isFreeContest = 1
            taxLabel.isHidden = true
            
        }else{
            
            isFreeContest = 0
            taxLabel.isHidden = false
            
        }
        print("selectedContest.prizes.count",selectedContest.prizes.count)
        
        for i in 0..<selectedContest.prizes.count {
            
            let singlePrize = selectedContest.prizes.item(at: i)
            
            if self.prizeFilteredArray.count == 0{
                
                let prize = PrizeRankCal()
                prize.lowRank = singlePrize.rank
                // prize.hignRank = singlePrize.rank
                prize.amount = singlePrize.prizeAmount
                
                self.prizeFilteredArray.append(prize)
                
            }else{
                
                for j in 0..<prizeFilteredArray.count {
                    
                    if self.prizeFilteredArray.item(at: j).amount == singlePrize.prizeAmount{
                        
                        self.prizeFilteredArray.item(at: j).hignRank = singlePrize.rank
                        
                    }else if j == self.prizeFilteredArray.count - 1{
                        
                        let prize = PrizeRankCal()
                        prize.lowRank = singlePrize.rank
                        prize.amount = singlePrize.prizeAmount
                        
                        self.prizeFilteredArray.append(prize)
                    }
                    
                }
            }
            
        }
        
        prizeRankTableView.reloadData()
        
        
        self.prizeRankView.isHidden = false
        self.backShadowView.isHidden = false
        self.prizeRankView.frame = CGRect(x: 0, y:self.view.frame.height, width: self.prizeRankView.frame.width, height: self.prizeRankView.frame.height)
        
        let bottonSpace = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
        
        UIView.animate(withDuration:0.2, animations: {
            
            
            self.prizeRankView.frame = CGRect(x: 0, y:self.view.frame.height - self.prizeRankView.frame.height - bottonSpace, width: self.prizeRankView.frame.width, height: self.prizeRankView.frame.height)
            
        }) { _ in
            
            
        }
        
        
        //        self.prizeRankView.isHidden = false
        //        self.backShadeView.isHidden = false
        
        print("prizeCalculation........",self.prizeFilteredArray.count)
        
        prizeRankViewHeight.constant = CGFloat((prizeFilteredArray.count * 44) + 90)
        
    }
    
    
    //    func joiningLastTime(matchTime: String, join_ends_before: Int) -> String{
    //        
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //        let dateFromString :Date = dateFormatter.date(from: matchTime)!
    //        
    //        let date = dateFromString.addingTimeInterval(TimeInterval(-(join_ends_before * 60)))
    //        
    //        let sttringFDate = date.toDateString(format: "yyyy-MM-dd HH:mm:ss")
    //        
    //        return sttringFDate.serverTimetoDateString()
    //        
    //    }
    
}
