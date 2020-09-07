//
//  ContestListViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 5/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

import SafariServices
import SVProgressHUD

protocol BackFromTeamSelect {
    func selectedTeam(team: CreatedTeam,contestId: Int)
    func selectedTeamFootball(team: CreatedTeamFootball,contestId: Int)
}

class ContestListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BackFromTeamSelect {
    
    
    
    
    
    private let refreshControl = UIRefreshControl()
    
    var activeContestList:[ContestData] = []
    var joinedContestList:[ContestData] = []
    
    var squadData: MatchSquadData!
    var createdTeamList: [CreatedTeam] = []
    var createdTeamListFootball: [CreatedTeamFootball] = []
    var selectedTeamId = 0
    var selectedContestId = 0
    
    var userData: UserModel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var createTeamButton: UIButton!
    
    @IBOutlet weak var firstTeamFlag: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var secondTeamFlag: UIImageView!
    
    
    
    @IBOutlet weak var contestTableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var matchSummaryView: UIView!
    
    @IBOutlet weak var stateView: UIView!
    
    @IBOutlet weak var createdTeamLabel: UILabel!
    @IBOutlet weak var teamCount: UILabel!
    @IBOutlet weak var contestCount: UILabel!
    @IBOutlet weak var joinedContestLabel: UILabel!
    
    @IBOutlet weak var backShadeView: UIView!
    @IBOutlet weak var prizeRankView: UIView!
    @IBOutlet weak var prizeRankViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var prizeListLabel: UILabel!
    @IBOutlet weak var taxlabel: UILabel!
    
    @IBOutlet weak var prizeRankTableView: UITableView!
    
    
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    @IBOutlet weak var tcLabel: UILabel!
    @IBOutlet weak var toPayLabel: UILabel!
    @IBOutlet weak var totalCoinCountLabel: UILabel!
    @IBOutlet weak var freeContestCountLabel: UILabel!
    @IBOutlet weak var entryAmountLabel: UILabel!
    @IBOutlet weak var applyFreeLabel: UILabel!
    @IBOutlet weak var applyFreeButton: UIButton!
    @IBOutlet weak var freeAmountLabel: UILabel!
    @IBOutlet weak var payAmountLabel: UILabel!
    @IBOutlet weak var joinContestButton: UIButton!
    
    
    @IBOutlet weak var buyCoinView: UIView!
    @IBOutlet weak var confirmationLabel2: UILabel!
    @IBOutlet weak var entryLabel2: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var toPayLabel2: UILabel!
    @IBOutlet weak var totalCoinCountLabel2: UILabel!
    @IBOutlet weak var freeContestCountLabel2: UILabel!
    @IBOutlet weak var entryAmountLabel2: UILabel!
    @IBOutlet weak var applyFreeLabel2: UILabel!
    @IBOutlet weak var applyFreeButton2: UIButton!
    @IBOutlet weak var freeAmountLabel2: UILabel!
    @IBOutlet weak var payAmountLabel2: UILabel!
    @IBOutlet weak var BDTLabel: UILabel!
    @IBOutlet weak var bdtAmountLabel: UILabel!
    
    @IBOutlet weak var buyCoinButton: UIButton!
    
    @IBOutlet weak var paymentView: UIView!
    
    @IBOutlet weak var selectBkashButton: UIButton!
    @IBOutlet weak var selectCardButton: UIButton!
    @IBOutlet weak var selectTermButton: UIButton!
    @IBOutlet weak var paymentMethodsLabel: UILabel!
    @IBOutlet weak var bKashLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginSuggestionLabel: UILabel!
    
    
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var addCoinView: UIView!
    @IBOutlet weak var coinCountLabel: UILabel!
    @IBOutlet weak var tkCountLabel: UILabel!
    @IBOutlet weak var addMoreButton: UIButton!
    @IBOutlet weak var winningLabel: UILabel!
    @IBOutlet weak var totalCoinLabel: UILabel!
    
    @IBOutlet weak var blockSuggestionView: UIView!
    @IBOutlet weak var blockSuggestionTextView: UITextView!
    
    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var cashInfoButton: UIButton!
    
    
    var parentMatch: MatchList? = nil
    var parentMatchFootball: FootBallMatchList? = nil
    var type : MatchType = .upcomingContest
    
    var contest_id = 0
    
    var joinedContestCount = 0
    
    var prizeFilteredArray: [PrizeRankCal] = []
    
    var isFreeContest = 1
    
    var selectedContest: ContestData?
    
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        self.tabBarController?.tabBar.isHidden = true
        
        // placeNavBar(withTitle: "CONTESTS", isBackBtnVisible: true)
        
        navTitleLabel.text = "CONTESTS".localized
        
        prizeListLabel.text = "Prize List".localized
        taxlabel.text = "Tax Msg".localized
        
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        
        
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
      //  createTeamButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        createTeamButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "on_green")!)
        createTeamButton.layer.shadowColor = UIColor.gray.cgColor
        createTeamButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        createTeamButton.layer.shadowRadius = 2
        createTeamButton.layer.shadowOpacity = 0.5
        createTeamButton.layer.masksToBounds = false
              
        signUpButton.buttonRound(5, borderWidth: 0.5, borderColor: UIColor.init(named: "on_green")!)
        loginButton.buttonRound(5, borderWidth: 0.5, borderColor: UIColor.init(named: "on_green")!)
        
        contestTableView.register(UINib(nibName: "ContestTableViewCell", bundle: nil), forCellReuseIdentifier: "contestCell")
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.paymentSuccessful(_:)), name: NSNotification.Name(rawValue: "paymentFromContestList"), object: nil)
        
        
        contestTableView.delegate = self
        contestTableView.dataSource = self
        contestTableView.removeEmptyCells()
        
        prizeRankTableView.delegate = self
        prizeRankTableView.dataSource = self
        prizeRankTableView.removeEmptyCells()
        
        createdTeamLabel.text = "CREATED TEAMS".localized
        joinedContestLabel.text = "JOINED CONTESTS".localized
        
        
        loginButton.setTitle("Login".localized, for: .normal)
        signUpButton.setTitle("Sign Up".localized, for: .normal)
        
        totalBalanceLabel.text = "TOTAL BALANCE".localized
        totalCoinLabel.text = "Total Coins".localized
        winningLabel.text = "Total Winnings".localized
        addMoreButton.setTitle("ADD MORE COINS".localized, for: .normal)
        
        createTeamButton.setTitle("CREATE YOUR TEAM".localized, for: .normal)
        
      
        
        confirmationLabel.text = "CONFIRMATION".localized
        entryLabel.text = "Entry".localized
        applyFreeLabel.text = "Apply Free Contest".localized
        toPayLabel.text = "To Pay".localized
        
        confirmationLabel2.text = "CONFIRMATION".localized
        entryLabel2.text = "Entry".localized
        applyFreeLabel2.text = "Apply Free Contest".localized
        toPayLabel2.text = "To Pay".localized
        warningLabel.text = "You don't have enough coins".localized
        BDTLabel.text = "1 BDT".localized
        bdtAmountLabel.text = "= 50".localized
        buyCoinButton.setTitle("BUY COINS".localized, for: .normal)
        joinContestButton.setTitle("JOIN CONTEST".localized, for: .normal)
        
        blockSuggestionTextView.text = "Your profile has been blocked! To know about reason of blocking or to resolve the matter please message to our facebook page https://www.facebook.com/gameof11/ . GO11 support team will guide you for further procedure.".localized
        
        
        
        
        paymentMethodsLabel.text = "Payment Methods".localized
        bKashLabel.text = "bKash Digital Payment".localized
        cardLabel.text = "Credit/Debit Cards/Mobile\nBanking/Online Banking".localized
        payButton.setTitle("PAY NOW".localized, for: .normal)
        
        blockSuggestionTextView.isEditable = false;
        blockSuggestionTextView.dataDetectorTypes = UIDataDetectorTypes.all;
        
        
        
        contestTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        
        //    getData()
        
        //get active contest list
        
        //        if type == .next{
        //
        //            APIManager.manager.getActiveContestList(matchId: "\(parentMatch?.matchId ?? 0)") { (status, cm, msg) in
        //                if status{
        //                    if cm != nil{
        //
        //                        // self.fill(u)
        //                        self.activeContestList = (cm?.contests)!
        //                        self.contestTableView.reloadData()
        //                    }
        //                }
        //                else{
        //                  //  self.showStatus(status, msg: msg)
        //                }
        //            }
        //        }
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            self.firstTeamName.text = self.parentMatch?.teams.item(at: 0).teamKey?.uppercased() ?? ""
            self.secondTeamName.text = self.parentMatch?.teams.item(at: 1).teamKey?.uppercased() ?? ""
            
            if type == .next  {
                
                self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatch?.joiningLastTime?.lowercased() ?? "" )
                
            }else if type == .upcomingContest{
                
                navTitleLabel.text = "JOINED CONTESTS".localized
                infoButton.isHidden = true
                cashInfoButton.isHidden = true
                self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatch?.joiningLastTime?.lowercased() ?? "" )
                
                
            }else if type == .liveContest{
                
                navTitleLabel.text = "JOINED CONTESTS".localized
                infoButton.isHidden = true
                cashInfoButton.isHidden = true
                self.statusLabel.text = "In Progress".localized
                
            }else if type == .completedContest{
                
                navTitleLabel.text = "JOINED CONTESTS".localized
                infoButton.isHidden = true
                cashInfoButton.isHidden = true
                self.statusLabel.text = "Completed".localized
            }
            
            if self.parentMatch?.teams.item(at: 0).logo != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatch?.teams.item(at: 0).logo ?? "")")
                self.firstTeamFlag.kf.setImage(with: url1)
            }else{
                
                self.firstTeamFlag.image = UIImage.init(named: "teamPlaceHolder_icon")
            }
            
            if self.parentMatch?.teams.item(at: 1).logo != nil{
                
                let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatch?.teams.item(at: 1).logo ?? "")")
                
                self.secondTeamFlag.kf.setImage(with: url2)
                
            }else{
                self.secondTeamFlag.image = UIImage.init(named: "teamPlaceHolder_icon")
            }
            
        }else{
            
            self.firstTeamName.text = self.parentMatchFootball?.teams.item(at: 0).code?.uppercased() ?? ""
            self.secondTeamName.text = self.parentMatchFootball?.teams.item(at: 1).code?.uppercased() ?? ""
            self.firstTeamFlag.image = UIImage.init(named: "placeholder_football_team_logo")
            
            self.secondTeamFlag.image = UIImage.init(named: "placeholder_football_team_logo")
            
            if type == .next  {
                
                self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatchFootball?.joiningLastTime?.lowercased() ?? "" )
                
            }else if type == .upcomingContest{
                
                navTitleLabel.text = "JOINED CONTESTS".localized
                infoButton.isHidden = true
                cashInfoButton.isHidden = true
                self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatchFootball?.joiningLastTime?.lowercased() ?? "" )
                
                
            }else if type == .liveContest{
                
                navTitleLabel.text = "JOINED CONTESTS".localized
                infoButton.isHidden = true
                cashInfoButton.isHidden = true
                self.statusLabel.text = "In Progress".localized
                
            }else if type == .completedContest{
                
                navTitleLabel.text = "JOINED CONTESTS".localized
                infoButton.isHidden = true
                cashInfoButton.isHidden = true
                self.statusLabel.text = "Completed".localized
            }
            
            if self.parentMatchFootball?.teams.item(at: 0).logo != nil{
                
                let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatchFootball?.teams.item(at: 0).logo ?? "")")
                self.firstTeamFlag.kf.setImage(with: url1)
            }
            if self.parentMatchFootball?.teams.item(at: 1).logo != nil{
                
                let url2 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(self.parentMatchFootball?.teams.item(at: 1).logo ?? "")")
                
                print("logo.............",url2)
                self.secondTeamFlag.kf.setImage(with: url2)
                
            }
            
        }
        
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backShadeView.addGestureRecognizer(tap)
    }
    

    
    @objc private func refreshData(_ sender: Any) {
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            if type == .next{
                
                APIManager.manager.getActiveContestList(matchId: "\(parentMatch?.matchId ?? 0)") { (status, cm, msg) in
                    if status{
                        if cm != nil{
                            
                            // self.fill(u)
                            self.activeContestList = (cm?.contests)!
                            self.contestTableView.reloadData()
                        }
                    }
                    else{
                        //  self.showStatus(status, msg: msg)
                    }
                }
            }
            getData()
            
        }else{
            if type == .next{
                
                APIManager.manager.getActiveFootBallContestList(matchId: "\(self.parentMatchFootball?.matchId ?? 0)") { (status, cm, msg) in
                    if status{
                        if cm != nil{
                            
                            // self.fill(u)
                            self.activeContestList = (cm?.contests)!
                            self.contestTableView.reloadData()
                            
                            
                        }
                    }
                }
            }
            
            getFootballData()
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            getData()
            
            self.backShadeView.isHidden = true
            prizeRankView.isHidden = true
            signUpView.isHidden = true
            addCoinView.isHidden = true
            paymentView.isHidden = true
            
           
            
            //       self.tabBarController?.tabBar.isHidden = false
            
            
            if type == .next {
                
                print("type ..",type)
                
                APIManager.manager.getMatchSquad(matchId: "\(parentMatch?.matchId ?? 0)") { (status, matchSquad, msg) in
                    
                    print("msg.....................",msg!)
                    if status{
                        if matchSquad != nil{
                            
                            self.createTeamButton.isEnabled = true
                            self.createTeamButton.isHidden = false
                            
                            self.squadData = matchSquad
                            
                        }
                    }
                    //                else{
                    //                    self.showStatus(status, msg: msg)
                    //                }
                }
                
                
                if AppSessionManager.shared.authToken != nil{
                    //user's team
                    
                    APIManager.manager.getTeamForMatch(matchId: "\(parentMatch?.matchId ?? 0)") { (status, createdTeam, msg) in
                        if status{
                            
                            if createdTeam != nil{
                                self.createdTeamList = (createdTeam?.teams)!
                                
                                if self.createdTeamList.count > 0
                                {
                                    self.stateView.isHidden = false
                                    self.createTeamButton.isHidden = true
                                    self.footerView.isHidden = false
                                    
                                    if Language.language == Language.english{
                                        
                                        self.teamCount.text = String.init(format: "%d",self.createdTeamList.count)
                                    }else{
                                        
                                        let bnNumberString = self.formatter.string(for: self.createdTeamList.count )
                                        self.teamCount.text = String.init(format: "%@",bnNumberString!)
                                    }
                                    
                                }
                                
                            }
                        }
                        else{
                            
                            self.stateView.isHidden = true
                            self.footerView.isHidden = false
                            self.createTeamButton.isHidden = false
                            
                            // self.showStatus(status, msg: msg)
                        }
                    }
                }
                else
                {
                    self.footerView.isHidden = true
                    
                }
            }else{
                
                self.footerView.isHidden = true
                
            }
            
        }
        else{
            
            getFootballData()
            
            self.backShadeView.isHidden = true
            prizeRankView.isHidden = true
            signUpView.isHidden = true
            addCoinView.isHidden = true
            paymentView.isHidden = true
            
            //       self.tabBarController?.tabBar.isHidden = false
            
            
            if type == .next {
                
                print("type ..",type)
                
                APIManager.manager.getFootballMatchSquad(matchId: "\(parentMatchFootball?.matchId ?? 0)") { (status, matchSquad, msg) in
                    
                    print("msg.....................",msg!)
                    if status{
                        if matchSquad != nil{
                            
                            self.createTeamButton.isEnabled = true
                            self.createTeamButton.isHidden = false
                            
                            self.squadData = matchSquad
                            
                        }
                    }
                    //                else{
                    //                    self.showStatus(status, msg: msg)
                    //                }
                }
                
                
                if AppSessionManager.shared.authToken != nil{
                    //user's team
                    
                    APIManager.manager.getTeamForFootballMatch(matchId: "\(parentMatchFootball?.matchId ?? 0)") { (status, createdTeam, msg) in
                        if status{
                            
                            if createdTeam != nil{
                                self.createdTeamListFootball = (createdTeam?.teams)!
                                
                                if self.createdTeamListFootball.count > 0
                                {
                                    self.stateView.isHidden = false
                                    self.createTeamButton.isHidden = true
                                    self.footerView.isHidden = false
                                    
                                    if Language.language == Language.english{
                                        
                                        self.teamCount.text = String.init(format: "%d",self.createdTeamListFootball.count)
                                    }else{
                                        
                                        let bnNumberString = self.formatter.string(for: self.createdTeamListFootball.count )
                                        self.teamCount.text = String.init(format: "%@",bnNumberString!)
                                    }
                                    
                                }
                                
                            }
                        }
                        else{
                            
                            self.stateView.isHidden = true
                            self.footerView.isHidden = false
                            self.createTeamButton.isHidden = false
                            
                            // self.showStatus(status, msg: msg)
                        }
                    }
                }
                else
                {
                    self.footerView.isHidden = true
                    
                }
            }else{
                
                self.footerView.isHidden = true
                
            }
            
        }
        
    }
    
    
    func getData(){
        
        print("get data called")
        
        
        if AppSessionManager.shared.authToken != nil{
            
            //get joinned contest list
            APIManager.manager.getJoinedActiveContestList(matchId: "\(parentMatch?.matchId ?? 0)") { (status, cm, msg) in
                if status{
                    if cm != nil{
                        
                        if self.type == .upcomingContest || self.type == .liveContest || self.type == .completedContest{
                            
                            self.activeContestList = (cm?.contests)!
                            self.contestTableView.reloadData()
                            
                        }else{
                            
                            self.joinedContestList = (cm?.contests)!
                            self.joinedContestCount = (cm?.contests.count)!
                            if Language.language == Language.english{
                                
                                self.contestCount.text = String.init(format: "%d",self.joinedContestCount)
                            }else{
                                
                                let bnNumberString = self.formatter.string(for: self.joinedContestCount )
                                self.contestCount.text = String.init(format: "%@",bnNumberString!)
                            }
                            
                        }
                        
                    }
                }
                else{
                    // self.showStatus(status, msg: msg)
                }
                
                self.refreshControl.endRefreshing()
            }
            
            
            
            APIManager.manager.getMyProfile { (status, um, msg) in
                if status{
                    
                    AppSessionManager.shared.currentUser = um
                    AppSessionManager.shared.save()
                }
            }
        }
        
    }
    
    func getFootballData(){
        
        print("get football data called")
        
        
        if AppSessionManager.shared.authToken != nil{
            
            //get joinned contest list
            APIManager.manager.getJoinedActiveFootballContestList(matchId: "\(parentMatchFootball?.matchId ?? 0)") { (status, cm, msg) in
                if status{
                    if cm != nil{
                        
                        if self.type == .upcomingContest || self.type == .liveContest || self.type == .completedContest{
                            
                            self.activeContestList = (cm?.contests)!
                            self.contestTableView.reloadData()
                            
                        }else{
                            
                            self.joinedContestList = (cm?.contests)!
                            self.joinedContestCount = (cm?.contests.count)!
                            if Language.language == Language.english{
                                
                                self.contestCount.text = String.init(format: "%d",self.joinedContestCount)
                            }else{
                                
                                let bnNumberString = self.formatter.string(for: self.joinedContestCount )
                                self.contestCount.text = String.init(format: "%@",bnNumberString!)
                            }
                            
                        }
                        
                    }
                }
                else{
                    // self.showStatus(status, msg: msg)
                }
                
                self.refreshControl.endRefreshing()
            }
            
            
            
            APIManager.manager.getMyProfile { (status, um, msg) in
                if status{
                    
                    AppSessionManager.shared.currentUser = um
                    AppSessionManager.shared.save()
                }
            }
        }
        
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
            return activeContestList.count
        }else{
            
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == contestTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier:"contestCell") as! ContestTableViewCell
            
            let contest = activeContestList[indexPath.section]
            cell.setInfo(contest)
            
            //        if (type != .next)
            //        {
            //            cell.joinedButton.isHidden = true
            //        }
            //        else
            //        {
            
            cell.joinedButton.isHidden = false
            cell.joinedButton.tag = contest.id ?? 0
            cell.joinedButton.addTarget(self, action: #selector(teamSelectAction(_:)), for: .touchUpInside)
            //    }
            
            print("contest type",contest.contestType)
            
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
                bnHighRankString = String(singlePrize.hignRank!)
                bnPrizeAmountString = String(singlePrize.amount!)
         
               
            }else{
               
                bnLowRankString = self.formatter.string(for: singlePrize.lowRank! )
                bnHighRankString = self.formatter.string(for: singlePrize.hignRank! )
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if let cell = cell as? ContestTableViewCell{
            
            let contest = activeContestList[indexPath.section]
            
            if (contest.isJoined != 0)
            {
                
                cell.joinedButton.setBackgroundColor(UIColor.init(named: "on_green")!, for: UIControl.State.normal)
                
                cell.joinedButton.setTitle("JOINED".localized, for: UIControl.State.normal)
                cell.joinedButton.setTitleColor(UIColor.gray, for: .normal)
                cell.joinedButton.isUserInteractionEnabled = false
                
                
            }
            else
            {
                cell.joinedButton.setBackgroundColor(UIColor.init(named: "on_green")!, for: UIControl.State.normal)
                
                cell.joinedButton.setTitle("JOIN".localized, for: UIControl.State.normal)
                cell.joinedButton.setTitleColor(UIColor.white, for: .normal)
                cell.joinedButton.isUserInteractionEnabled = true
            }
            
            //            if contest.contestType == "free"{
            //
            //                cell.entryAmountLabel.textColor =  UIColor.init(named: "GreyTextColor")
            //
            //            }else{
            //                cell.entryAmountLabel.textColor =  UIColor.init(named: "GreenHighlight")
            //
            //            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelectRowAt ",self.tabBarController?.selectedIndex)
        
        if tableView == contestTableView{
            if  type == .next
            {
                let contest = activeContestList[indexPath.section]
                
                if contest.isJoined == 1{
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    
                    let VC = storyboard.instantiateViewController(withIdentifier: "ContestLeaderBoardViewController") as! ContestLeaderBoardViewController
                    
                    VC.contest_id = contest.id
                    if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        
                        VC.match_id = parentMatch?.matchId
                    }else{
                        
                        VC.match_id = parentMatchFootball?.matchId
                    }
                    VC.contestName = contest.name
                    
                    self.present(VC, animated: true) {
                        
                        print("open")
                    }
                }else{
                    
                    self.view.makeToast("You haven't joined this contest. You can see details of this Contest and LeaderBoard after joining this Contest before Match begins.".localized)
                    
                }
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                let VC = storyboard.instantiateViewController(withIdentifier: "ContestLeaderBoardViewController") as! ContestLeaderBoardViewController
                
                let contest = activeContestList[indexPath.section]
                
                print("parentMatch?.matchId",parentMatch?.matchId ?? 0)
                
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
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == contestTableView{
            let contest = activeContestList[indexPath.section]
            
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
    @IBAction func teamCreateAction(_ sender: Any) {
        
        if let um = AppSessionManager.shared.currentUser {
            
            if um.isBlocked == 1{
                
                print("Blocked...............")
                
                backShadeView.isHidden = false
                blockSuggestionView.isHidden = false
                
            }else{
                
                if squadData != nil && squadData.playersList.count > 0
                {
                    
                    if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamCreateViewController") as? TeamCreateViewController
                        
                        popupVC?.squadData = squadData
                        popupVC?.timeLeft = self.parentMatch?.joiningLastTime
                        
                        self.navigationController?.pushViewController(popupVC ?? self, animated: true)
                    }else{
                        
                        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamCreateFootballViewController") as? TeamCreateFootballViewController
                        
                        popupVC?.squadData = squadData
                        popupVC?.timeLeft = self.parentMatchFootball?.joiningLastTime
                        
                        self.navigationController?.pushViewController(popupVC ?? self, animated: true)
                        
                    }
                    
                    
                }
                else
                {
                    self.view.makeToast("No Squad Found, Please Refresh".localized )
                    
                }
            }
        }
        
        //        self.present(popupVC!, animated: true) {
        //            print("")
        //        }
    }
    @IBAction func teamSelectAction(_ sender: UIButton) {
        
        if AppSessionManager.shared.authToken == nil {
            
            loginSuggestionLabel.text = "You have to Login or Sign Up to join any contest. Before joining contests you can create your own Fantasy Team. Please Login or Sign Up to prove your skill.".localized
            self.backShadeView.isHidden = false
            self.signUpView.isHidden = false
            
        }
        else
        {
            
            
            print("........teamSelectAction............")
            
            if let um = AppSessionManager.shared.currentUser {
                
                if um.isBlocked == 1{
                    
                    print("Blocked...............")
                    backShadeView.isHidden = false
                    blockSuggestionView.isHidden = false
                    
                    
                }else{
                    
                    if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        
                        if self.createdTeamList.count > 0
                        {
                            
                            for contest in activeContestList{
                                
                                if sender.tag == contest.id{
                                    
                                    selectedContest = contest
                                }
                            }
                            
                            if selectedContest!.total_user_joined! < selectedContest!.teamsCapacity!{
                                
                                APIManager.manager.getWalletInfo { (dataDic) in
                                    
                                    let freeContestCount = dataDic["referral_contest_unlocked"]! as! Int
                                    
                                    if self.selectedContest!.is_free_allowed! == 1 && (freeContestCount > 0) {
                                        
                                        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                                        
                                        popupVC?.modalPresentationStyle = .overCurrentContext
                                        popupVC?.modalTransitionStyle = .crossDissolve
                                        popupVC?.teams = self.createdTeamList
                                        popupVC?.contestId = sender.tag
                                        popupVC?.delegate = self
                                        
                                        self.present(popupVC!, animated: true) {
                                            
                                            
                                        }
                                        
                                        
                                    }else{
                                        let totalCoin = dataDic["total_coins"]! as! Int
                                        
                                        if  totalCoin < self.selectedContest!.entryAmount!{
                                            
                                            print("not enough coin")
                                            
                                            self.backShadeView.isHidden = false
                                            self.buyCoinView.isHidden = false
                                            
                                            if Language.language == Language.english{
                                                
                                                self.totalCoinCountLabel2.text = String.init(format: "Your total coins = %@",String(totalCoin ))
                                                self.freeContestCountLabel2.text = String.init(format: "Available free contests = %@",String( freeContestCount ))
                                                self.entryAmountLabel2.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                
                                                
                                                self.freeAmountLabel2.text = "- 0"
                                                self.applyFreeLabel2.textColor = UIColor.lightGray
                                                self.applyFreeButton2.isUserInteractionEnabled = false
                                                print("free contest not allowed")
                                                
                                                let payAmount = self.selectedContest!.entryAmount! / 50
                                                self.payAmountLabel2.text = String.init(format:"%d", payAmount)
                                                
                                                
                                                
                                            }else{
                                                
                                                let bnNumberString = self.formatter.string(for: totalCoin )
                                                let bnNumberString2 = self.formatter.string(for: freeContestCount )
                                                let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                                                
                                                self.totalCoinCountLabel2.text = String.init(format: "Your total coins = %@".localized, bnNumberString!)
                                                self.freeContestCountLabel2.text = String.init(format: "Available free contests = %@".localized,bnNumberString2!)
                                                
                                                self.entryAmountLabel2.text = String.init(format:"%@",bnNumberString3!)
                                                
                                                
                                                
                                                self.freeAmountLabel2.text = "- ০"
                                                
                                                let payAmount = self.selectedContest!.entryAmount! / 50
                                                let bnNumberString4 = self.formatter.string(for: payAmount)
                                                
                                                self.applyFreeLabel2.textColor = UIColor.lightGray
                                                self.applyFreeButton2.isUserInteractionEnabled = false
                                                print("free contest not allowed")
                                                
                                                self.payAmountLabel2.text = String.init(format:"%@",bnNumberString4!)
                                                
                                                
                                                
                                            }
                                            
                                        }else{
                                            
                                            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                                            
                                            popupVC?.modalPresentationStyle = .overCurrentContext
                                            popupVC?.modalTransitionStyle = .crossDissolve
                                            popupVC?.teams = self.createdTeamList
                                            popupVC?.contestId = sender.tag
                                            popupVC?.delegate = self
                                            
                                            self.present(popupVC!, animated: true) {
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }
                            }else{
                                
                                self.view.makeToast("Contest is full" )
                            }
                            
                        }else{
                            
                            //self.view.makeToast("No team created".localized)
                            
                            for contest in activeContestList{
                                
                                if sender.tag == contest.id{
                                    
                                    selectedContest = contest
                                }
                            }
                            if selectedContest!.total_user_joined! < selectedContest!.teamsCapacity!{
                                
                                if squadData != nil && squadData.playersList.count > 0
                                {
                                    let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamCreateViewController") as? TeamCreateViewController
                                    
                                    popupVC?.squadData = squadData
                                    popupVC?.timeLeft = self.parentMatch?.joiningLastTime
                                    
                                    self.navigationController?.pushViewController(popupVC ?? self, animated: true)
                                }
                                else
                                {
                                    self.view.makeToast("No Squad Found, Please Refresh".localized )
                                    
                                }
                            }else{
                                
                                self.view.makeToast("Contest is full" )
                                
                            }
                        }
                        
                    }else{
                        
                        if self.createdTeamListFootball.count > 0
                        {
                            
                            for contest in activeContestList{
                                
                                if sender.tag == contest.id{
                                    
                                    selectedContest = contest
                                }
                            }
                            
                            if selectedContest!.total_user_joined! < selectedContest!.teamsCapacity!{
                                
                                APIManager.manager.getWalletInfo { (dataDic) in
                                    
                                    let freeContestCount = dataDic["referral_contest_unlocked"]! as! Int
                                    
                                    if self.selectedContest!.is_free_allowed! == 1 && (freeContestCount > 0) {
                                        
                                        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                                        
                                        popupVC?.modalPresentationStyle = .overCurrentContext
                                        popupVC?.modalTransitionStyle = .crossDissolve
                                        popupVC?.teamsFootball = self.createdTeamListFootball
                                        popupVC?.contestId = sender.tag
                                        popupVC?.delegate = self
                                        
                                        self.present(popupVC!, animated: true) {
                                            
                                            
                                        }
                                        
                                        
                                    }else{
                                        let totalCoin = dataDic["total_coins"]! as! Int
                                        
                                        if  totalCoin < self.selectedContest!.entryAmount!{
                                            
                                            print("not enough coin")
                                            
                                            self.backShadeView.isHidden = false
                                            self.buyCoinView.isHidden = false
                                            
                                            if Language.language == Language.english{
                                                
                                                self.totalCoinCountLabel2.text = String.init(format: "Your total coins = %@",String(totalCoin ))
                                                self.freeContestCountLabel2.text = String.init(format: "Available free contests = %@",String( freeContestCount ))
                                                self.entryAmountLabel2.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                
                                                
                                                self.freeAmountLabel2.text = "- 0"
                                                self.applyFreeLabel2.textColor = UIColor.lightGray
                                                self.applyFreeButton2.isUserInteractionEnabled = false
                                                print("free contest not allowed")
                                                
                                                let payAmount = self.selectedContest!.entryAmount! / 50
                                                self.payAmountLabel2.text = String.init(format:"%d", payAmount)
                                                
                                                
                                                
                                            }else{
                                                
                                                let bnNumberString = self.formatter.string(for: totalCoin )
                                                let bnNumberString2 = self.formatter.string(for: freeContestCount )
                                                let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                                                
                                                self.totalCoinCountLabel2.text = String.init(format: "Your total coins = %@".localized, bnNumberString!)
                                                self.freeContestCountLabel2.text = String.init(format: "Available free contests = %@".localized,bnNumberString2!)
                                                
                                                self.entryAmountLabel2.text = String.init(format:"%@",bnNumberString3!)
                                                
                                                
                                                
                                                self.freeAmountLabel2.text = "- ০"
                                                
                                                let payAmount = self.selectedContest!.entryAmount! / 50
                                                let bnNumberString4 = self.formatter.string(for: payAmount)
                                                
                                                self.applyFreeLabel2.textColor = UIColor.lightGray
                                                self.applyFreeButton2.isUserInteractionEnabled = false
                                                print("free contest not allowed")
                                                
                                                self.payAmountLabel2.text = String.init(format:"%@",bnNumberString4!)
                                                
                                                
                                                
                                            }
                                            
                                        }else{
                                            
                                            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                                            
                                            popupVC?.modalPresentationStyle = .overCurrentContext
                                            popupVC?.modalTransitionStyle = .crossDissolve
                                            popupVC?.teamsFootball = self.createdTeamListFootball
                                            popupVC?.contestId = sender.tag
                                            popupVC?.delegate = self
                                            
                                            self.present(popupVC!, animated: true) {
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }
                            }else{
                                
                                self.view.makeToast("Contest is full" )
                            }
                            
                        }else{
                            
                            //self.view.makeToast("No team created".localized)
                            
                            for contest in activeContestList{
                                
                                if sender.tag == contest.id{
                                    
                                    selectedContest = contest
                                }
                            }
                            if selectedContest!.total_user_joined! < selectedContest!.teamsCapacity!{
                                
                                if squadData != nil && squadData.playersList.count > 0
                                {
                                    let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamCreateFootballViewController") as? TeamCreateFootballViewController
                                    
                                    popupVC?.squadData = squadData
                                    popupVC?.timeLeft = self.parentMatchFootball?.joiningLastTime
                                    
                                    self.navigationController?.pushViewController(popupVC ?? self, animated: true)
                                }
                                else
                                {
                                    self.view.makeToast("No Squad Found, Please Refresh".localized )
                                    
                                }
                            }else{
                                
                                self.view.makeToast("Contest is full" )
                                
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
        
    }
    
    @IBAction func teamEditAction(_ sender: Any) {
        if let um = AppSessionManager.shared.currentUser {
            
            if um.isBlocked == 1{
                
                print("Blocked...............")
                backShadeView.isHidden = false
                blockSuggestionView.isHidden = false
                
            }else{
                
                let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyTeamViewController") as? MyTeamViewController
                
                // popupVC?.teams = self.createdTeamList
                //  popupVC?.squadData = squadData
                if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                    
                    popupVC?.parentMatch = parentMatch
                }else{
                    
                    popupVC?.parentMatchFootball = parentMatchFootball
                }
                
                self.navigationController?.pushViewController(popupVC ?? self, animated: true)
                
            }
        }
    }
    
    func selectedTeam(team: CreatedTeam,contestId: Int) {
        
        
        for contest in activeContestList{
            
            if contestId == contest.id{
                
                selectedContest = contest
            }
        }
        
        APIManager.manager.getWalletInfo { (dataDic) in
            
            let freeContestCount = dataDic["referral_contest_unlocked"]! as! Int
            let totalCoin = dataDic["total_coins"]! as! Int
            
            if self.selectedContest!.is_free_allowed! == 1 && freeContestCount > 0 {
                
                self.backShadeView.isHidden = false
                self.confirmationView.isHidden = false
                
                self.selectedTeamId = team.userTeamId ?? 0
                self.selectedContestId = contestId
                
                if Language.language == Language.english{
                    
                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin))
                    self.freeContestCountLabel.text = String.init(format: "Available free contests = %@",String( freeContestCount))
                    self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                    
                    print("free contest allowed")
                    
                    
                    self.freeAmountLabel.text = String.init(format:"- %d",self.selectedContest?.entryAmount ?? 0)
                    self.payAmountLabel.text = "0"
                    self.applyFreeButton.isSelected = true
                    
                }else{
                    
                    let bnNumberString = self.formatter.string(for: totalCoin )
                    let bnNumberString2 = self.formatter.string(for: freeContestCount )
                    let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                    
                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, bnNumberString!)
                    self.freeContestCountLabel.text = String.init(format: "Available free contests = %@".localized,bnNumberString2! )
                    self.entryAmountLabel.text = String.init(format:"%@",bnNumberString3!)
                    
                    
                    let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                    
                    self.freeAmountLabel.text = String.init(format:"- %@",bnNumberString4!)
                    
                    self.payAmountLabel.text = "০"
                    self.applyFreeButton.isSelected = true
                    
                }
                
            }else{
                
                
                //                        if um!.metadata!.totalCoins! < self.selectedContest!.entryAmount!{
                //
                //                            print("not enough coin")
                //
                //                            self.backShadeView.isHidden = false
                //                            self.buyCoinView.isHidden = false
                //
                //                            if Language.language == Language.english{
                //
                //                                self.totalCoinCountLabel2.text = String.init(format: "Your total coins = %@",String(um!.metadata?.totalCoins ?? 0))
                //                                self.freeContestCountLabel2.text = String.init(format: "Available free contests = %@",String( um!.metadata?.referral_contest_unlocked ?? 0))
                //                                self.entryAmountLabel2.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                //
                //
                //                                    self.freeAmountLabel2.text = "- 0"
                //                                    self.applyFreeLabel2.textColor = UIColor.lightGray
                //                                    self.applyFreeButton2.isUserInteractionEnabled = false
                //                                    print("free contest not allowed")
                //
                //                                    let payAmount = self.selectedContest!.entryAmount! / 50
                //                                    self.payAmountLabel2.text = String.init(format:"%d", payAmount)
                //
                //
                //
                //                            }else{
                //
                //                                let bnNumberString = self.formatter.string(for: um!.metadata?.totalCoins ?? 0 )
                //                                let bnNumberString2 = self.formatter.string(for: um!.metadata?.referral_contest_unlocked ?? 0 )
                //                                let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                //
                //                                self.totalCoinCountLabel2.text = String.init(format: "Your total coins = %@".localized, bnNumberString!)
                //                                self.freeContestCountLabel2.text = String.init(format: "Available free contests = %@".localized,bnNumberString2!)
                //
                //                                self.entryAmountLabel2.text = String.init(format:"%@",bnNumberString3!)
                //
                //
                //
                //                                    self.freeAmountLabel2.text = "- ০"
                //
                //                                    let payAmount = self.selectedContest!.entryAmount! / 50
                //                                    let bnNumberString4 = self.formatter.string(for: payAmount)
                //
                //                                    self.applyFreeLabel2.textColor = UIColor.lightGray
                //                                    self.applyFreeButton2.isUserInteractionEnabled = false
                //                                    print("free contest not allowed")
                //
                //                                    self.payAmountLabel2.text = String.init(format:"%@",bnNumberString4!)
                //
                //
                //
                //                            }
                //
                //                        }else{
                
                self.backShadeView.isHidden = false
                self.confirmationView.isHidden = false
                
                self.selectedTeamId = team.userTeamId ?? 0
                self.selectedContestId = contestId
                
                if Language.language == Language.english{
                    
                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin ?? 0))
                    self.freeContestCountLabel.text = String.init(format: "Available free contests = %@",String( freeContestCount))
                    self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                    
                    
                    self.freeAmountLabel.text = "- 0"
                    self.applyFreeLabel.textColor = UIColor.lightGray
                    self.applyFreeButton.isUserInteractionEnabled = false
                    print("free contest not allowed")
                    
                    self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                    
                    
                    
                }else{
                    
                    let bnNumberString = self.formatter.string(for: totalCoin )
                    let bnNumberString2 = self.formatter.string(for: freeContestCount)
                    let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                    
                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, bnNumberString!)
                    self.freeContestCountLabel.text = String.init(format: "Available free contests = %@".localized,bnNumberString2! )
                    self.entryAmountLabel.text = String.init(format:"%@",bnNumberString3!)
                    
                    self.freeAmountLabel.text = "- ০"
                    
                    let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                    
                    self.applyFreeLabel.textColor = UIColor.lightGray
                    self.applyFreeButton.isUserInteractionEnabled = false
                    print("free contest not allowed")
                    
                    self.payAmountLabel.text = String.init(format:"%@",bnNumberString4!)
                    
                }
            }
        }
        
    }
    
    func selectedTeamFootball(team: CreatedTeamFootball, contestId: Int) {
        
        
        for contest in activeContestList{
            
            if contestId == contest.id{
                
                selectedContest = contest
            }
        }
        
        APIManager.manager.getWalletInfo { (dataDic) in
            
            let freeContestCount = dataDic["referral_contest_unlocked"]! as! Int
            let totalCoin = dataDic["total_coins"]! as! Int
            
            if self.selectedContest!.is_free_allowed! == 1 && freeContestCount > 0 {
                
                self.backShadeView.isHidden = false
                self.confirmationView.isHidden = false
                
                self.selectedTeamId = team.userTeamId ?? 0
                self.selectedContestId = contestId
                
                if Language.language == Language.english{
                    
                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin))
                    self.freeContestCountLabel.text = String.init(format: "Available free contests = %@",String( freeContestCount))
                    self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                    
                    print("free contest allowed")
                    
                    
                    self.freeAmountLabel.text = String.init(format:"- %d",self.selectedContest?.entryAmount ?? 0)
                    self.payAmountLabel.text = "0"
                    self.applyFreeButton.isSelected = true
                    
                }else{
                    
                    let bnNumberString = self.formatter.string(for: totalCoin )
                    let bnNumberString2 = self.formatter.string(for: freeContestCount )
                    let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                    
                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, bnNumberString!)
                    self.freeContestCountLabel.text = String.init(format: "Available free contests = %@".localized,bnNumberString2! )
                    self.entryAmountLabel.text = String.init(format:"%@",bnNumberString3!)
                    
                    
                    let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                    
                    self.freeAmountLabel.text = String.init(format:"- %@",bnNumberString4!)
                    
                    self.payAmountLabel.text = "০"
                    self.applyFreeButton.isSelected = true
                    
                }
                
            }else{
                
                self.backShadeView.isHidden = false
                self.confirmationView.isHidden = false
                
                self.selectedTeamId = team.userTeamId ?? 0
                self.selectedContestId = contestId
                
                if Language.language == Language.english{
                    
                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin ?? 0))
                    self.freeContestCountLabel.text = String.init(format: "Available free contests = %@",String( freeContestCount))
                    self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                    
                    
                    self.freeAmountLabel.text = "- 0"
                    self.applyFreeLabel.textColor = UIColor.lightGray
                    self.applyFreeButton.isUserInteractionEnabled = false
                    print("free contest not allowed")
                    
                    self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                    
                    
                    
                }else{
                    
                    let bnNumberString = self.formatter.string(for: totalCoin )
                    let bnNumberString2 = self.formatter.string(for: freeContestCount)
                    let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                    
                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, bnNumberString!)
                    self.freeContestCountLabel.text = String.init(format: "Available free contests = %@".localized,bnNumberString2! )
                    self.entryAmountLabel.text = String.init(format:"%@",bnNumberString3!)
                    
                    self.freeAmountLabel.text = "- ০"
                    
                    let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                    
                    self.applyFreeLabel.textColor = UIColor.lightGray
                    self.applyFreeButton.isUserInteractionEnabled = false
                    print("free contest not allowed")
                    
                    self.payAmountLabel.text = String.init(format:"%@",bnNumberString4!)
                    
                }
            }
        }
        
    }
    
    @IBAction func freeContestButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            if Language.language == Language.english{
                
                self.freeAmountLabel.text = String.init(format:"-%d",self.selectedContest?.entryAmount ?? 0)
                self.payAmountLabel.text = "0"
                
            }else{
                let bnNumberString = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                
                self.freeAmountLabel.text = String.init(format:"-%@",bnNumberString!)
                self.payAmountLabel.text = "০"
            }
            
            
            
        }else{
            
            if Language.language == Language.english{
                
                self.freeAmountLabel.text = "-0"
                self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
            }else{
                let bnNumberString = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                
                self.freeAmountLabel.text = "-০"
                self.payAmountLabel.text = String.init(format:"%@",bnNumberString!)
            }
            
        }
        
    }
    
    
    
    @IBAction func joinContestButtonAction(_ sender: Any) {
        
        joinContestButton.isUserInteractionEnabled = false
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            APIManager.manager.joinInContestWith(contestId: String.init(format: "%d", selectedContestId), teamId: String.init(format: "%d", selectedTeamId), withCompletionHandler: { (status, msg) in
                if status{
                    self.joinContestButton.isUserInteractionEnabled = true
                    
                    print("Team submitted")
                    
                    //update contest list
                    APIManager.manager.getActiveContestList(matchId: "\(self.parentMatch?.matchId ?? 0)") { (status, cm, msg) in
                        if status{
                            if cm != nil{
                                
                                // self.fill(u)
                                self.activeContestList = (cm?.contests)!
                                self.contestTableView.reloadData()
                                
                                self.confirmationView.isHidden = true
                                self.backShadeView.isHidden = true
                                
                            }
                        }
                    }
                    //update joined contest
                    APIManager.manager.getJoinedActiveContestList(matchId: "\(self.parentMatch?.matchId ?? 0)") { (status, cm, msg) in
                        if status{
                            if cm != nil{
                                
                                if self.type == .upcomingContest || self.type == .liveContest || self.type == .completedContest{
                                    
                                    self.activeContestList = (cm?.contests)!
                                    
                                }else{
                                    
                                    self.joinedContestList = (cm?.contests)!
                                    self.joinedContestCount = (cm?.contests.count)!
                                    if Language.language == Language.english{
                                        
                                        self.contestCount.text = String.init(format: "%d",self.joinedContestCount)
                                    }else{
                                        
                                        let bnNumberString = self.formatter.string(for: self.joinedContestCount )
                                        self.contestCount.text = String.init(format: "%@",bnNumberString!)
                                    }
                                    //                                        self.contestCount.text = String.init(format: "%d",self.joinedContestCount)
                                }
                                
                            }
                        }
                    }
                }
                else{
                    
                    self.joinContestButton.isUserInteractionEnabled = true
                    
                    self.view.makeToast(msg!)
                }
            })
            
        }else{
            
            APIManager.manager.joinInFootballContestWith(contestId: String.init(format: "%d", selectedContestId), teamId: String.init(format: "%d", selectedTeamId), withCompletionHandler: { (status, msg) in
                if status{
                    self.joinContestButton.isUserInteractionEnabled = true
                    
                    print("Team submitted football")
                    
                    //update contest list
                    APIManager.manager.getActiveFootBallContestList(matchId: "\(self.parentMatchFootball?.matchId ?? 0)") { (status, cm, msg) in
                        if status{
                            if cm != nil{
                                
                                // self.fill(u)
                                self.activeContestList = (cm?.contests)!
                                self.contestTableView.reloadData()
                                
                                self.confirmationView.isHidden = true
                                self.backShadeView.isHidden = true
                                
                            }
                        }
                    }
                    //update joined contest
                    APIManager.manager.getJoinedActiveFootballContestList(matchId: "\(self.parentMatchFootball?.matchId ?? 0)") { (status, cm, msg) in
                        if status{
                            if cm != nil{
                                
                                if self.type == .upcomingContest || self.type == .liveContest || self.type == .completedContest{
                                    
                                    self.activeContestList = (cm?.contests)!
                                    
                                }else{
                                    
                                    self.joinedContestList = (cm?.contests)!
                                    self.joinedContestCount = (cm?.contests.count)!
                                    if Language.language == Language.english{
                                        
                                        self.contestCount.text = String.init(format: "%d",self.joinedContestCount)
                                    }else{
                                        
                                        let bnNumberString = self.formatter.string(for: self.joinedContestCount )
                                        self.contestCount.text = String.init(format: "%@",bnNumberString!)
                                    }
                                    //                                        self.contestCount.text = String.init(format: "%d",self.joinedContestCount)
                                }
                                
                            }
                        }
                    }
                }
                else{
                    
                    self.joinContestButton.isUserInteractionEnabled = true
                    
                    self.view.makeToast(msg!)
                }
            })
            
        }
        
    }
    
    @IBAction func closeConfirmationView(_ sender: Any) {
        
        confirmationView.isHidden = true
        self.backShadeView.isHidden = true
    }
    
    @IBAction func showJoinedContestList(_ sender: Any) {
        
        if joinedContestCount > 0 {
            
            
            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "JoinedContestListViewController") as? JoinedContestListViewController
            
            popupVC?.joinedContestList = joinedContestList
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                
                popupVC?.parentMatch = parentMatch
                
            }else{
                popupVC?.parentMatchFootball = parentMatchFootball
            }
            
            self.navigationController?.pushViewController(popupVC ?? self, animated: true)
            
        }
        
    }
    
    //    override func backButtonAction() {
    //        self.navigationController?.dismiss(animated: true
    //            , completion: nil)
    //    }
    
    
    
    
    //
    
    @IBAction func prizeCalculation(_ sender: UIButton) {
        
        //        if self.type == .upcomingContest || self.type == .liveContest || self.type == .completedContest{
        //
        //        }else{
        //
        //
        //        }
        
        self.prizeFilteredArray = []
        
        let selectedContest = activeContestList[sender.tag]
        
        if selectedContest.contestType == "free"{
            
            isFreeContest = 1
            taxlabel.isHidden = true
            
        }else{
            
            isFreeContest = 0
            taxlabel.isHidden = true
            
        }
        
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
        self.backShadeView.isHidden = false
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
        
        if prizeRankViewHeight.constant >  UIScreen.main.bounds.height - 50{
            
            prizeRankViewHeight.constant = UIScreen.main.bounds.height - 150
        }
        
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        backShadeView.isHidden = true
        prizeRankView.isHidden = true
        signUpView.isHidden = true
        addCoinView.isHidden = true
        paymentView.isHidden = true
        confirmationView.isHidden = true
        buyCoinView.isHidden = true
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
        
        self.navigationController?.pushViewController(popupVC!, animated: true)
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = true
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        
        self.navigationController?.pushViewController(popupVC!, animated: true)
        
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        
        var urlString = ""
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            urlString = "https://www.gameof11.com/what-is-contest"
        }else{
            urlString = "https://www.gameof11.com/football/what-is-contest"
        }
        
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
        
    }
    
    @IBAction func cashInfoButtonAction(_ sender: Any) {
        
        if AppSessionManager.shared.authToken != nil{
            
            APIManager.manager.getWalletInfo { (infoDic) in
                
                
                print("?????????????",infoDic)
                
                
                //  if let um = AppSessionManager.shared.currentUser {
                self.addCoinView.isHidden = false
                self.backShadeView.isHidden = false
                self.addCoinView.frame = CGRect(x: 0, y:self.view.frame.height, width: self.addCoinView.frame.width, height: self.addCoinView.frame.height)
                
                let bottonSpace = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 1.0
                
                if Language.language == Language.english{
                    
                    self.coinCountLabel.text = String.init(format: "%d", infoDic["total_coins"] as! Int)
                    self.tkCountLabel.text = String.init(format: "%.2f", infoDic["total_cash"] as! Float)
                }else{
                    
                    let bnNumberString = self.formatter.string(for: infoDic["total_coins"] as! Int )
                    let bnNumberString2 = self.formatter.string(for: infoDic["total_cash"] as! Float )
                    
                    self.coinCountLabel.text = String.init(format: "%@", bnNumberString!)
                    self.tkCountLabel.text = String.init(format: "%@",bnNumberString2! )
                    
                }
                
                
                
                UIView.animate(withDuration:0.2, animations: {
                    
                    
                    self.addCoinView.frame = CGRect(x: 0, y:self.view.frame.height - self.addCoinView.frame.height - bottonSpace, width: self.addCoinView.frame.width, height: self.addCoinView.frame.height)
                    
                }) { _ in
                    
                    
                }
                
                
                
            }
        }else{
            
            loginSuggestionLabel.text = "You have to Login to view your own wallet. Please Login or Sign Up to prove your skill.".localized
            
            self.backShadeView.isHidden = false
            self.signUpView.isHidden = false
            
            
        }
        
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        
        backShadeView.isHidden = true
        blockSuggestionView.isHidden = true
        
    }
    
    @IBAction func closeBuyView(_ sender: Any) {
        
        buyCoinView.isHidden = true
        self.backShadeView.isHidden = true
        
    }
    
    @IBAction func buyCoinButtonAction(_ sender: Any) {
        
        
        buyCoinView.isHidden = true
        
        self.paymentView.isHidden = false
        self.backShadeView.isHidden = false
        self.paymentView.frame = CGRect(x: 0, y:self.view.frame.height, width: self.paymentView.frame.width, height: self.paymentView.frame.height)
        
        let bottonSpace = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 1.0
        
        
        UIView.animate(withDuration:0.2, animations: {
            
            
            self.paymentView.frame = CGRect(x: 0, y:self.view.frame.height - self.paymentView.frame.height - bottonSpace, width: self.paymentView.frame.width, height: self.paymentView.frame.height)
            
        }) { _ in
            
            
        }
    }
    
    
    @IBAction func selectBkashButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if selectCardButton.isSelected{
            
            selectCardButton.isSelected = false
        }
    }
    
    @IBAction func selectCardbuttonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if selectBkashButton.isSelected{
            
            selectBkashButton.isSelected = false
        }
    }
    
    @IBAction func selectTermButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func termButtonAction(_ sender: Any) {
        
        let urlString = "https://www.gameof11.com/terms-and-conditions"
        
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
    }
    
    @IBAction func payNowButtonAction(_ sender: Any) {
        
        print("contest id",selectedContest?.id)
        
        if selectTermButton.isSelected{
            
            let tkAmount = (payAmountLabel2.text! as NSString).floatValue
            
            var type = "ghoori"
            if selectBkashButton.isSelected{
                
                type = "ghoori"
                
            }else if selectCardButton.isSelected{
                
                type = "foster"
            }
            
            print("tkAmount and type ",tkAmount,type)
            
            APIManager.manager.getInvoice(amount: tkAmount,type:type) { (status, id,url,msg) in
                
                print("getInvoice msg",msg!)
                
                if status{
                    self.view.makeToast(msg!)
                    
                    print("getInvoice id",id ?? "??",url!)
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BkashPaymentViewController") as? BkashPaymentViewController
                    
                    vc?.urlString = url!
                    vc?.selectedContestId = self.selectedContest!.id!
                    vc?.createdTeamList = self.createdTeamList
                    
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                }
                else{
                    self.view.makeToast(msg!)
                }
                
            }
            
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        //  self.navigationController?.popViewController(animated: true)
        
        self.navigationController?.dismiss(animated: true, completion: {
            
            
        })
    }
    
    
    @IBAction func addMoreCoinButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DepositCoinViewController") as? DepositCoinViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    
    
    
    
    @objc func paymentSuccessful(_ notification: NSNotification) {
        
        if let contestId = notification.userInfo?["contestId"] as? Int {
            
            if let teams = notification.userInfo?["teams"] as? [CreatedTeam] {
                
                let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                
                popupVC?.modalPresentationStyle = .overCurrentContext
                popupVC?.modalTransitionStyle = .crossDissolve
                popupVC?.teams = teams
                popupVC?.contestId = contestId
                popupVC?.delegate = self
                
                self.present(popupVC!, animated: true) {
                    
                    
                }
                
            }
            print("contestId...........",contestId)
            
            
        }
        
        
        //        let alertVC = UIAlertController(title: nil, message: "Your payment to buy Coins was Successful. Now please choose from your created Teams and join contest".localized, preferredStyle: .alert)
        //        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (aciton) in
        //        })
        //
        //        alertVC.addAction(okAction)
        //        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    
}

class PrizeRankCal{
    
    var lowRank:Int!
    var hignRank:Int!
    var amount:Int!
    
    func prizeCalculation(lowRank:Int,highRank:Int, amount:Int ) {
        
        self.lowRank = lowRank
        self.hignRank = highRank
        self.amount = amount
    }
}
