//
//  MatchViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher
import BetterSegmentedControl

class MatchViewController : BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    var matches:[MatchList] = []
    var footBallmatches:[FootBallMatchList] = []
    
    var type : MatchType = .next
    
    var bannerArray:[Any] = []
    
    var page_no = 1
    var total_page_no : Int!

    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var adCollectionView: UICollectionView!
    
    @IBOutlet weak var selectAmatchLabel: UILabel!
    
    @IBOutlet weak var noMatchView: UIView!
    @IBOutlet weak var noMatchLabel: UILabel!
    
    @IBOutlet weak var noContestLabel: UILabel!
    @IBOutlet weak var noContestView: UIView!
    @IBOutlet weak var selectAmatchButton: UIButton!
    
    
    
    
    @IBOutlet weak var noContestImageView: UIImageView!
    @IBOutlet weak var noMatchImageView: UIImageView!
    
    
    
    @IBOutlet weak var matchListTableView: UITableView!
    
    
    @IBOutlet weak var gameSegmentControl: BetterSegmentedControl!
    
    
    @IBOutlet weak var showMoreButton: UIButton!
    

    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if #available(iOS 13.0, *) {
        //            overrideUserInterfaceStyle = .dark
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
        print("fcm............?????", AppSessionManager.shared.fcmToken ?? "no fcm token")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToContestView(_:)), name: NSNotification.Name(rawValue: "notificationRecieved"), object: nil)
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        // print("??????????..............",Language.language)
        
        selectAmatchLabel.text = "SELECT A MATCH".localized
        
        
        
        noMatchLabel.text = "We provide upcoming match schedule based on your preferences. No upcoming match of that priority is available now.".localized
        noContestLabel.text = "You haven't join any upcoming contests. Join the upcoming match contests and prove your skills.".localized
        
        selectAmatchButton.setTitle("SELECT A MATCH".localized, for: .normal)
  
        self.noContestView.isHidden = true
        
        
        
        print(type)
        if type == .next {
            
            adCollectionView.addConstraint(NSLayoutConstraint(item: adCollectionView,
            attribute: .height,
            relatedBy: .equal,
            toItem: adCollectionView,
            attribute: .width,
            multiplier: 1350 / 460,
            constant: 0))
            
            print("bannerRatioConstraint..........??@@",bannerRatioConstraint.constant)
            topViewHeight.isActive = false
            bannerRatioConstraint.isActive = true
            self.view.layoutIfNeeded()
            
            adCollectionView.delegate = self
            adCollectionView.dataSource = self
            
            
            APIManager.manager.getBannerList(pageName: "homepage") { (bannerArray) in
                
                
                self.bannerArray = bannerArray
                
                self.adCollectionView.reloadData()
                
            }
            
        }else {
            
            //don't show ad.
            
            adCollectionView.addConstraint(NSLayoutConstraint(item: adCollectionView,
            attribute: .height,
            relatedBy: .equal,
            toItem: adCollectionView,
            attribute: .width,
            multiplier: 0,
            constant: 0))
            
            print("bannerRatioConstraint..........??",bannerRatioConstraint.constant)
            topViewHeight.isActive = true
            bannerRatioConstraint.isActive = false
            self.view.layoutIfNeeded()
            
        }
        
        
        matchListTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        
        
        
        gameSegmentControl.segments = LabelSegment.segments(withTitles: ["Cricket", "Football"],
                                                            normalFont: UIFont(name: "OpenSans-Bold", size: 13.0)!,
                                                            selectedFont: UIFont(name: "OpenSans-Bold", size: 13.0)!,
                                                            selectedTextColor: UIColor.init(named: "brand_red")!)
        // gameSegmentControl.setIndex(1)
        
    }
    
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//
//        if type == .next {
//
//            topViewHeight.isActive = false
//            bannerRatioConstraint.isActive = true
//            self.view.layoutIfNeeded()
//            self.view.setNeedsLayout()
//
//        }else {
//
//            topViewHeight.isActive = true
//            bannerRatioConstraint.isActive = false
//            self.view.layoutIfNeeded()
//            self.view.setNeedsLayout()
//        }
//
//    }
    
    
    @IBAction func gameChangeAction(_ sender:
        BetterSegmentedControl) {
        
        
        self.showMoreButton.isHidden = true
        
        print("The selected index is...... \(sender.index)")
        
        if sender.index == 0{
            
            UserDefaults.standard.set("cricket", forKey: "selectedGameType")
            
            getData()
            
        }else{
            
            UserDefaults.standard.set("football", forKey: "selectedGameType")
            
            getFootBallData()
        }
    }
    
    
    @objc private func refreshData(_ sender: Any) {
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            getData()
        }else{
            
            getFootBallData()
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
        
        if type != .next {
            
            topViewHeight.isActive = true
            bannerRatioConstraint.isActive = false
            self.view.layoutIfNeeded()
           
        }
        
        print("viewWillAppear..............match",UserDefaults.standard.string(forKey: "selectedGameType"))
        self.noMatchView.isHidden = true
        self.noContestView.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = false
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            getData()
            
            gameSegmentControl.setIndex(0)
            
        }else{
            
            getFootBallData()
            
            gameSegmentControl.setIndex(1)
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // print("viewDidAppear..............match")
        
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "gameChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gameSelectAction(_:)), name: NSNotification.Name(rawValue: "gameChange"), object: nil)
        
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        //print("viewDidDisappear............///////////")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "gameChange"), object: nil)
    }
    
    @objc func moveToContestView(_ notification: NSNotification) {
        
        print("noti info...........",notification.userInfo)
       
        
        if let totalfup = Int(notification.userInfo?["match_id"] as! String)
        {
           
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                
                getData()
                gameSegmentControl.setIndex(0)
                if let index = self.matches.firstIndex(where: {$0.matchId == totalfup}){
                    let indexPath = IndexPath(row: 0 , section: index)
                    matchListTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    matchListTableView.delegate?.tableView!(matchListTableView, didSelectRowAt: indexPath)
             
                }
            }else{
                
                getFootBallData()
                gameSegmentControl.setIndex(1)
                if let index = self.footBallmatches.firstIndex(where: {$0.matchId == totalfup}){
                    let indexPath = IndexPath(row: 0 , section: index)
                    matchListTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    matchListTableView.delegate?.tableView!(matchListTableView, didSelectRowAt: indexPath)
             
                }
               
            }
            
            
        }
       
   
    }
    
    func getData(){
        
        self.page_no = 1
        self.noMatchView.isHidden = true
        self.noContestView.isHidden = true
        
        if (matchListTableView != nil)
        {
            if type == .next{
                
                matchListTableView.register(UINib(nibName: "UpComingMatchCell", bundle: nil), forCellReuseIdentifier: "UpcomingMatchCell")
            }else{
                matchListTableView.register(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchCell")
            }
            matchListTableView.delegate = self
            matchListTableView.dataSource = self
            matchListTableView.removeEmptyCells()
        }
        
        if type == .next
        {
            APIManager.manager.getUpcomingMatchList { (nextMatches) in
                self.matches = nextMatches
                self.matchListTableView.reloadData()
               
                
                if self.matches.count == 0{
                    
                    self.selectAmatchLabel.isHidden = true
                    
                    self.noMatchImageView.image =  UIImage.init(named: "match_icon")
                    self.noMatchView.isHidden = false
                    
                }else{
                    
                    self.noMatchView.isHidden = true
                    self.selectAmatchLabel.isHidden = false
                    
                }
                
            }
            
            
        }
            //        else  if type == .live
            //        {
            //            APIManager.manager.getLiveMatchList { (nextMatches) in
            //                self.matches = nextMatches
            //                self.matchListTableView.reloadData()
            //            }
            //        }
        else  if type == .upcomingContest
        {
            APIManager.manager.getUserJoinedUpcomingMatchList { (nextMatches) in
                
                self.matches = nextMatches
                self.matchListTableView.reloadData()
                if self.matches.count == 0{
                    
                    self.noContestImageView.image = UIImage.init(named: "trophy_no_contest_icon")
                    self.noContestView.isHidden = false
                }else{
                    self.noContestView.isHidden = true
                }
                
            }
        }
        else  if type == .liveContest
        {
            APIManager.manager.getUserJoinedLiveMatchList { (nextMatches) in
                
                
                self.matches = nextMatches
                self.matchListTableView.reloadData()
                if self.matches.count == 0{
                    
                    self.noContestLabel.text = "You haven't join any live contests. Join the upcoming match contests and prove your skills.".localized
                    self.noContestImageView.image = UIImage.init(named: "trophy_no_contest_icon")
                    self.noContestView.isHidden = false
                    
                }else{
                    self.noContestView.isHidden = true
                }
            }
        }
        else  if type == .completedContest
        {
           getCompletedMatch(pageNo: 1)
        }
        
        self.refreshControl.endRefreshing()
        
    }
    
    func getCompletedMatch(pageNo:Int){
        
        let p_no:String = String(describing: pageNo)

        APIManager.manager.getUserJoinedCompletedMatchList(page_no: p_no) { (nextMatches,pageCount) in
            
            print("pageCount......",pageCount ?? 0)
            
            if self.page_no == 1{
                
                self.total_page_no = pageCount
                
                self.matches = nextMatches
                
            }else{
                
                self.matches.append(contentsOf: nextMatches)
            }

            print("self.matches",self.matches.count)
            self.matchListTableView.reloadData()
            //                if self.matches.count == 0{
            //
            //                    self.noContestView.isHidden = false
            //                }else{
            //                     self.noContestView.isHidden = true
            //                }
        }
    }
    
    func getFootBallData(){
        
        print("get football data...............")
        self.page_no = 1
        
        self.noMatchView.isHidden = true
        self.noContestView.isHidden = true
        
        if (matchListTableView != nil)
        {
            if type == .next{
                
                matchListTableView.register(UINib(nibName: "UpComingMatchCell", bundle: nil), forCellReuseIdentifier: "UpcomingMatchCell")
            }else{
                matchListTableView.register(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchCell")
            }
            matchListTableView.delegate = self
            matchListTableView.dataSource = self
            matchListTableView.removeEmptyCells()
        }
        
        if type == .next
        {
            APIManager.manager.getUpcomingFootBallMatchList { (nextMatches) in
                self.footBallmatches = nextMatches
                self.matchListTableView.reloadData()
                
                if self.footBallmatches.count == 0{
                    
                    self.selectAmatchLabel.isHidden = true
                    self.noMatchImageView.image =  UIImage.init(named: "icon_football_match_upcoming")
                    self.noMatchView.isHidden = false
                    
                }else{
                    
                    self.noMatchView.isHidden = true
                    self.selectAmatchLabel.isHidden = false
                    
                }
                
            }
            
            
        }
        else  if type == .upcomingContest
        {
            APIManager.manager.getUserJoinedUpcomingFootballMatchList { (nextMatches) in
                
                print("upcomingContest........")
                self.footBallmatches = nextMatches
                self.matchListTableView.reloadData()
                if self.footBallmatches.count == 0{
                    
                    self.noContestImageView.image = UIImage.init(named: "trophy_no_contest_football")
                    self.noContestView.isHidden = false
                    
                }else{
                    
                    self.noContestView.isHidden = true
                    
                }
                
            }
        }
        else  if type == .liveContest
        {
            APIManager.manager.getUserJoinedLiveFootballMatchList { (nextMatches) in
                
                
                self.footBallmatches = nextMatches
                self.matchListTableView.reloadData()
                if self.footBallmatches.count == 0{
                    
                    self.noContestLabel.text = "You haven't join any live contests. Join the upcoming match contests and prove your skills.".localized
                    self.noContestImageView.image = UIImage.init(named: "trophy_no_contest_football")
                    self.noContestView.isHidden = false
                    
                }else{
                    
                    self.noContestView.isHidden = true
                }
            }
        }
        else  if type == .completedContest
        {
            getCompletedFootballMatch(pageNo: 1)
        
        }
        
        self.refreshControl.endRefreshing()
    }
    
    func getCompletedFootballMatch(pageNo:Int){
        
        let p_no:String = String(describing: pageNo)

        APIManager.manager.getUserJoinedCompletedFootballMatchList(page_no: p_no) { (nextMatches,pageCount) in
            
            print("pageCount......",pageCount ?? 0)
            
            if self.page_no == 1{
                
                self.total_page_no = pageCount
                
                self.footBallmatches = nextMatches
                
            }else{
                
                self.footBallmatches.append(contentsOf: nextMatches)
            }

            print("self.matches",self.matches.count)
            self.matchListTableView.reloadData()
            //                if self.matches.count == 0{
            //
            //                    self.noContestView.isHidden = false
            //                }else{
            //                     self.noContestView.isHidden = true
            //                }
        }
    }

    
    @IBAction func selectAMatchbuttonAction(_ sender: Any) {
        
        print(".....................")
        self.tabBarController?.selectedIndex = 0
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            print(".......matches.coun......",matches.count)
            
            return matches.count
            
        }else{
            
            return footBallmatches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            let match = matches[indexPath.section]
            
            if type == .next{
                
                let cell = tableView.dequeueReusableCell(withIdentifier:"UpcomingMatchCell") as! UpComingMatchCell
                
                if match.joiningLastTime == "CONTEST JOIN ENDED"{
                    
                    cell.statusLabel.text = String.init(format: "%@",match.joiningLastTime ?? "" )
                    
                }else{
                    
                    cell.statusLabel.text = String.init(format: "%@ Left".localized,match.joiningLastTime?.localized ?? "" )
                    
                }
                
                cell.setInfo(match)
                
                
                
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier:"MatchCell") as! MatchTableViewCell
                //brand_red
                //on_green
                if type == .upcomingContest{
                    
                    
                    cell.statusLabel.text = String.init(format:"%@ Left".localized.uppercased(),match.joiningLastTime?.localized.uppercased() ?? "" )
                    cell.statusLabel.textColor = UIColor.init(named: "brand_red")!
                    
//                    cell.statusBackground.backgroundColor = UIColor.init(named: "on_green")!
//                    cell.firstTeamName.backgroundColor = UIColor.init(named: "on_green")!
//                    cell.secondTeamName.backgroundColor = UIColor.init(named: "on_green")!
//
                }else if type == .liveContest{
                    
                    cell.statusLabel.text = String.init(format: "IN PROGRESS".localized)
                    cell.statusLabel.textColor = UIColor.init(named: "Blue")!
                    
//                    cell.statusBackground.backgroundColor = UIColor.init(named: "Blue")!
//                    cell.firstTeamName.backgroundColor = UIColor.init(named: "Blue")!
//                    cell.secondTeamName.backgroundColor = UIColor.init(named: "Blue")!
                    cell.contestLabel.textColor = UIColor.init(named: "Blue")!
                    
                }else if type == .completedContest{
                    
                    
                    cell.statusLabel.text = String.init(format: "COMPLETED".localized )
                    cell.statusLabel.textColor = UIColor.init(named: "on_green")!
                    
//                    cell.statusBackground.backgroundColor = UIColor.init(named: "on_green")!
//                    cell.firstTeamName.backgroundColor = UIColor.init(named: "on_green")!
//                    cell.secondTeamName.backgroundColor = UIColor.init(named: "on_green")!
//
                    if indexPath.section == (matches.count) - 3 {
                        
                        print("(self.matches.count) - 3")
                        
                        if total_page_no > page_no { // more items to fetch
                            
                            
                            page_no = page_no + 1
                            
                            getCompletedMatch(pageNo: page_no)
                            
                        }else{
                            
                            showMoreButton.isHidden = false
                            
                        }
                    }

                }
                
                cell.setInfo(match)
                
                if match.totalJoinedContests ?? 0 > 0 {
                    
                    cell.contestMessageHeightConstraint.constant = 20
                }
                else
                {
                    cell.contestMessageHeightConstraint.constant = 0
                }
                
                return cell
            }
            
        }else{
            
            let match = footBallmatches[indexPath.section]
            
            if type == .next{
                
                let cell = tableView.dequeueReusableCell(withIdentifier:"UpcomingMatchCell") as! UpComingMatchCell
                
                if match.joiningLastTime == "CONTEST JOIN ENDED"{
                    
                    cell.statusLabel.text = String.init(format: "%@",match.joiningLastTime ?? "" )
                    
                }else{
                    
                    cell.statusLabel.text = String.init(format: "%@ Left".localized,match.joiningLastTime?.localized ?? "" )
                    
                }
                
                cell.setFootballInfo(match)
                
                
                
                return cell
                
            }
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier:"MatchCell") as! MatchTableViewCell
                
                if type == .upcomingContest{
                    
                    
                    cell.statusLabel.text = String.init(format:"%@ Left".localized.uppercased(),match.joiningLastTime?.localized.uppercased() ?? "" )
                   cell.statusLabel.textColor = UIColor.init(named: "brand_red")!
                    
                }else if type == .liveContest{
                    
                    cell.statusLabel.text = String.init(format: "IN PROGRESS".localized)
                    cell.statusLabel.textColor = UIColor.init(named: "Blue")!
                                        
                    //                    cell.statusBackground.backgroundColor = UIColor.init(named: "Blue")!
                    //                    cell.firstTeamName.backgroundColor = UIColor.init(named: "Blue")!
                    //                    cell.secondTeamName.backgroundColor = UIColor.init(named: "Blue")!
                    cell.contestLabel.textColor = UIColor.init(named: "Blue")!
                                        
                }else if type == .completedContest{
                    
                    
                    cell.statusLabel.text = String.init(format: "COMPLETED".localized )
                    cell.statusLabel.textColor = UIColor.init(named: "on_green")!
                    
                    if indexPath.section == (matches.count) - 3 {
                        
                        print("(self.matches.count) - 3")
                        
                        if total_page_no > page_no { // more items to fetch
                            
                            
                            page_no = page_no + 1
                            
                            getCompletedFootballMatch(pageNo: page_no)
                            
                        }else{
                            
                            showMoreButton.isHidden = false
                            
                        }
                    }

                                       
                }
                
                cell.setFootballInfo(match)
                
                if match.totalJoinedContests ?? 0 > 0 {
                    
                    cell.contestMessageHeightConstraint.constant = 20
                }
                else
                {
                    cell.contestMessageHeightConstraint.constant = 0
                }
                
                return cell
            }
            
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        SVProgressHUD.show()
        print("didSelectRowAt............ \(indexPath.section)")
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            let match = matches[indexPath.section]
            
            
            if type == .next{
                
                if match.joiningLastTime == "CONTEST JOIN ENDED"{
                    
                    self.view.makeToast("Oops! Contest joining deadline has passed".localized)
                    
                    SVProgressHUD.dismiss()
                }else{
                    
                    APIManager.manager.getActiveContestList(matchId: "\(match.matchId ?? 0)") { (status, cm, msg) in
                        if status{
                            if cm != nil{
                                
                                let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContestListViewController") as? ContestListViewController
                                popupVC?.type = self.type
                                popupVC?.parentMatch = match
                                popupVC?.activeContestList = (cm?.contests)!
                                popupVC?.modalPresentationStyle = .fullScreen
                                popupVC?.modalTransitionStyle = .crossDissolve
                                
                                let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
                                navigationController.isNavigationBarHidden = true
                                navigationController.modalPresentationStyle = .fullScreen
                                
                                self.present(navigationController, animated: true) {
                                    
                                    SVProgressHUD.dismiss()
                                    print("")
                                }
                                
                            }
                        }
                        else{
                            
                            self.view.makeToast(msg!)
                        }
                    }
                    
                }
                
                
            }else{
                
                let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContestListViewController") as? ContestListViewController
                popupVC?.type = type
                popupVC?.parentMatch = match
                popupVC?.modalPresentationStyle = .fullScreen
                popupVC?.modalTransitionStyle = .crossDissolve
                
                let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
                navigationController.isNavigationBarHidden = true
                navigationController.modalPresentationStyle = .fullScreen
                
                self.present(navigationController, animated: true) {
                    
                    SVProgressHUD.dismiss()
                    print("")
                }
            }
        }else{
            
            let match = footBallmatches[indexPath.section]
            
            
            if type == .next{
                
                if match.joiningLastTime == "CONTEST JOIN ENDED"{
                    
                    self.view.makeToast("Oops! Contest joining deadline has passed".localized)
                    
                    SVProgressHUD.dismiss()
                }else{
                    
                    APIManager.manager.getActiveFootBallContestList(matchId: "\(match.matchId ?? 0)") { (status, cm, msg) in
                        if status{
                            if cm != nil{
                                
                                let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContestListViewController") as? ContestListViewController
                                popupVC?.type = self.type
                                popupVC?.parentMatchFootball = match
                                popupVC?.activeContestList = (cm?.contests)!
                                popupVC?.modalPresentationStyle = .fullScreen
                                popupVC?.modalTransitionStyle = .crossDissolve
                                
                                let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
                                navigationController.isNavigationBarHidden = true
                                navigationController.modalPresentationStyle = .fullScreen
                                
                                self.present(navigationController, animated: true) {
                                    
                                    SVProgressHUD.dismiss()
                                    print("")
                                }
                                
                            }
                        }
                        else{
                            
                            self.view.makeToast(msg!)
                        }
                    }
                    
                }
                
                
            }else{
                
                let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContestListViewController") as? ContestListViewController
                popupVC?.type = type
                popupVC?.parentMatchFootball = match
                popupVC?.modalPresentationStyle = .fullScreen
                popupVC?.modalTransitionStyle = .crossDissolve
                
                let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
                navigationController.isNavigationBarHidden = true
                navigationController.modalPresentationStyle = .fullScreen
                
                self.present(navigationController, animated: true) {
                    
                    SVProgressHUD.dismiss()
                    print("")
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if type == .next{
            
            return 140
        }
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init()
        view.backgroundColor = .clear
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return bannerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adCell", for: indexPath) as! BannerCollectionViewCell
        
        let singleBanner = bannerArray[indexPath.item] as! Dictionary<String,Any>
        
        
        let urlString = singleBanner["image_path"] as! String
        let fullUrl = "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(urlString)"
        print("singleBanner.....",fullUrl)
        
        // let url = URL(string: fullUrl)
        if let url = URL(string: fullUrl) {
            print("url string ",url)
            
            cell.bannerImageView.kf.setImage(with:url)
            
        } else {
            if let urlEscapedString = fullUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ,
                let escapedURL = URL(string: urlEscapedString){
                
                print("escapedURL string ",escapedURL)
                
                cell.bannerImageView.kf.setImage(with:escapedURL)
                
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let singleBanner = bannerArray[indexPath.item] as! Dictionary<String,Any>
        let urlString = singleBanner["reference_url"] as! String
        
        guard let url = URL(string: urlString) else {
            return //be safe
        }
        print("didSelectItemAt.....:  ",url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func showMoreButtonAction(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompletedMatchViewController") as? CompletedMatchViewController
       
        popupVC?.modalPresentationStyle = .fullScreen
        popupVC?.modalTransitionStyle = .crossDissolve
        
        let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
        navigationController.isNavigationBarHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        
        self.present(navigationController, animated: true) {
            
            SVProgressHUD.dismiss()
            print("")
        }
    }
    
    
    @objc func gameSelectAction(_ notification: NSNotification) {
        
        print("noti info...........",notification.userInfo!["isSelected"]!)
        if let currentVC = UIApplication.topViewController() as? MyContestViewController {
            
            print("match gameChangeAction")
            //selected for football
            
            if notification.userInfo!["isSelected"]! as! Bool == true{
                
                UserDefaults.standard.set("cricket", forKey: "selectedGameType")
                getData()
                
            }else{
                
                
                UserDefaults.standard.set("football", forKey: "selectedGameType")
                getFootBallData()
            }
            
        }
    }
    
    //    override func gameChange() {
    //
    //         print("match gameChangeAction.........")
    //    }
    
}
