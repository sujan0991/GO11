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
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var adCollectionView: UICollectionView!
    @IBOutlet weak var selectAmatchLabel: UILabel!
    
    @IBOutlet weak var noMatchView: UIView!
    @IBOutlet weak var noMatchLabel: UILabel!
    
    @IBOutlet weak var noContestLabel: UILabel!
    @IBOutlet weak var noContestView: UIView!
    @IBOutlet weak var selectAmatchButton: UIButton!
    
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var banglabutton: UIButton!
    @IBOutlet weak var changeLanguageLabel: UILabel!
    
    
    @IBOutlet weak var matchListTableView: UITableView!
    
   
    @IBOutlet weak var gameSegmentControl: BetterSegmentedControl!
    
    
    
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        // print("??????????..............",Language.language)
        
        selectAmatchLabel.text = "SELECT A MATCH".localized
        
        if Language.language == Language.bangla{
            
            banglabutton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
            banglabutton.backgroundColor = UIColor.init(named: "GreenHighlight")!
            
            englishButton.backgroundColor = UIColor.white
            englishButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
        }else{
            banglabutton.backgroundColor = UIColor.white
            banglabutton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
            
            englishButton.backgroundColor = UIColor.init(named: "GreenHighlight")!
            englishButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)

        }
        
        //Localize
        changeLanguageLabel.text = "Change Language".localized
       
        noMatchLabel.text = "We provide upcoming match schedule based on your preferences. No upcoming match of that priority is available now.".localized
        noContestLabel.text = "You haven't join any upcoming contests. Join the upcoming match contests and prove your skills.".localized
        
        selectAmatchButton.setTitle("SELECT A MATCH".localized, for: .normal)
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.languageChangeAction(_:)), name: NSNotification.Name(rawValue: "languageChange"), object: nil)
        
        
        
        
        englishButton.layer.borderWidth = 0.5
        englishButton.layer.borderColor = UIColor.lightGray.cgColor
        banglabutton.layer.borderWidth = 0.5
        banglabutton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        //
        
        self.noContestView.isHidden = true
        
        if type == .next {
            
            adCollectionView.delegate = self
            adCollectionView.dataSource = self
            
            APIManager.manager.getBannerList(pageName: "homepage") { (bannerArray) in
                
               
                self.bannerArray = bannerArray
                
                self.adCollectionView.reloadData()
            }
            
        }else{
            
            topViewHeight.constant = 0
        }
        
      
        matchListTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        shadowView.addGestureRecognizer(tap)
        
        
        gameSegmentControl.segments = LabelSegment.segments(withTitles: ["Cricket", "FootBall"],
                                                            normalFont: UIFont(name: "OpenSans-Bold", size: 13.0)!,
                                                            selectedFont: UIFont(name: "OpenSans-Bold", size: 13.0)!,
                                                            selectedTextColor: UIColor.init(named: "GreenHighlight")!)
       // gameSegmentControl.setIndex(1)
        
    }
    
    
    @IBAction func gameChangeAction(_ sender:
        BetterSegmentedControl) {
            
            print("The selected index is...... \(sender.index)")
        
        if sender.index == 0{
            
            UserDefaults.standard.set("cricket", forKey: "selectedGameType")
            
            getData()
            
        }else{
            
            UserDefaults.standard.set("football", forKey: "selectedGameType")
            
            getFootBallData()
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        shadowView.isHidden = true
        languageView.isHidden = true
    }
    @objc private func refreshData(_ sender: Any) {
        
       getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear..............match",UserDefaults.standard.string(forKey: "selectedGameType"))
 
       
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // print("viewDidAppear..............match")
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "gameChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.gameSelectAction(_:)), name: NSNotification.Name(rawValue: "gameChange"), object: nil)
        
        languageView.isHidden = true
        shadowView.isHidden = true
        
        
        self.tabBarController?.tabBar.isHidden = false
  
         if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            getData()
            
            gameSegmentControl.setIndex(0)
            
         }else{
            
             getFootBallData()
            
            gameSegmentControl.setIndex(1)
            
        }
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
//print("viewDidDisappear............///////////")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "gameChange"), object: nil)
    }
    
    
    func getData(){
        
        
        
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

                    self.noContestView.isHidden = false
                    
                }else{
                    self.noContestView.isHidden = true
                }
            }
        }
        else  if type == .completedContest
        {
            APIManager.manager.getUserJoinedCompletedMatchList { (nextMatches) in
                
                
                self.matches = nextMatches
                self.matchListTableView.reloadData()
                //                if self.matches.count == 0{
                //
                //                    self.noContestView.isHidden = false
                //                }else{
                //                     self.noContestView.isHidden = true
                //                }
            }
        }
        
        self.refreshControl.endRefreshing()
        
    }
    
     func getFootBallData(){
        
      //  print("get football data...............")
        
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
                    
                    self.noContestView.isHidden = false
                    
                }else{
                    
                    self.noContestView.isHidden = true
                }
            }
        }
        else  if type == .completedContest
        {
            APIManager.manager.getUserJoinedCompletedFootballMatchList { (nextMatches) in
                
                
                self.footBallmatches = nextMatches
                self.matchListTableView.reloadData()
                //                if self.matches.count == 0{
                //
                //                    self.noContestView.isHidden = false
                //                }else{
                //                     self.noContestView.isHidden = true
                //                }
            }
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
                
                if type == .upcomingContest{
                    
                    
                    cell.statusLabel.text = String.init(format:"%@ Left".localized.uppercased(),match.joiningLastTime?.localized.uppercased() ?? "" )
                    cell.statusBackground.backgroundColor = UIColor.init(named: "GreenHighlight")!
                    cell.firstTeamName.backgroundColor = UIColor.init(named: "GreenHighlight")!
                    cell.secondTeamName.backgroundColor = UIColor.init(named: "GreenHighlight")!
                    
                }else if type == .liveContest{
                    
                    cell.statusLabel.text = String.init(format: "IN PROGRESS".localized)
                    cell.statusBackground.backgroundColor = UIColor.init(named: "Blue")!
                    cell.firstTeamName.backgroundColor = UIColor.init(named: "Blue")!
                    cell.secondTeamName.backgroundColor = UIColor.init(named: "Blue")!
                    cell.contestLabel.textColor = UIColor.init(named: "Blue")!
                    
                }else if type == .completedContest{
                    
                    
                    cell.statusLabel.text = String.init(format: "COMPLETED".localized )
                    cell.statusBackground.backgroundColor = UIColor.init(named: "GreenHighlight")!
                    cell.firstTeamName.backgroundColor = UIColor.init(named: "GreenHighlight")!
                    cell.secondTeamName.backgroundColor = UIColor.init(named: "GreenHighlight")!
                    
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
                    cell.statusBackground.backgroundColor = UIColor.init(named: "GreenHighlight")!
                    cell.firstTeamName.backgroundColor = UIColor.init(named: "GreenHighlight")!
                    cell.secondTeamName.backgroundColor = UIColor.init(named: "GreenHighlight")!

                }else if type == .liveContest{

                    cell.statusLabel.text = String.init(format: "IN PROGRESS".localized)
                    cell.statusBackground.backgroundColor = UIColor.init(named: "Blue")!
                    cell.firstTeamName.backgroundColor = UIColor.init(named: "Blue")!
                    cell.secondTeamName.backgroundColor = UIColor.init(named: "Blue")!
                    cell.contestLabel.textColor = UIColor.init(named: "Blue")!

                }else if type == .completedContest{


                    cell.statusLabel.text = String.init(format: "COMPLETED".localized )
                    cell.statusBackground.backgroundColor = UIColor.init(named: "GreenHighlight")!
                    cell.firstTeamName.backgroundColor = UIColor.init(named: "GreenHighlight")!
                    cell.secondTeamName.backgroundColor = UIColor.init(named: "GreenHighlight")!

                }

            //    cell.setFootballInfo(match)

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
        print("didSelectRowAt............")
        
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
                                popupVC?.modalPresentationStyle = .overCurrentContext
                                popupVC?.modalTransitionStyle = .crossDissolve
                                
                                let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
                                navigationController.isNavigationBarHidden = true
                                
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
                popupVC?.modalPresentationStyle = .overCurrentContext
                popupVC?.modalTransitionStyle = .crossDissolve
                
                let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
                navigationController.isNavigationBarHidden = true
                
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
                                popupVC?.modalPresentationStyle = .overCurrentContext
                                popupVC?.modalTransitionStyle = .crossDissolve
                                
                                let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
                                navigationController.isNavigationBarHidden = true
                                
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
                popupVC?.modalPresentationStyle = .overCurrentContext
                popupVC?.modalTransitionStyle = .crossDissolve
                
                let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
                navigationController.isNavigationBarHidden = true
                
                self.present(navigationController, animated: true) {
                    
                    SVProgressHUD.dismiss()
                    print("")
                }
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if type == .next{
            
            return 120
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
        
       
        return CGSize(width: collectionView.frame.size.width - 30, height: collectionView.frame.size.height)
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
    
    @IBAction func englishButtonAction(_ sender: Any) {
        
        Language.language = Language.english
    }
   
    @IBAction func banglaButtonAction(_ sender: Any) {
        
        print("bangla.........")
        Language.language = Language.bangla
    }
    
   @objc func languageChangeAction(_ notification: NSNotification) {

        print("baseLanguageButtonAction")
    if let currentVC = UIApplication.topViewController() as? HomeViewController {
        
        shadowView.isHidden = false
        languageView.isHidden = false
        
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
