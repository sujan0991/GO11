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
import Mixpanel

protocol BackFromTeamSelect {
    func selectedTeam(team: CreatedTeam,contestId: Int, isDerectJoinApplicable: Bool)
    func selectedTeamFootball(team: CreatedTeamFootball,contestId: Int, isDerectJoinApplicable: Bool)
    
}

class ContestListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BackFromTeamSelect,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
    @IBOutlet weak var contestNameLabelInConfirmationView: UILabel!
    @IBOutlet weak var tcLabel: UILabel!
    @IBOutlet weak var toPayLabel: UILabel!
    @IBOutlet weak var totalCoinCountLabel: UILabel!
    @IBOutlet weak var entryAmountLabel: UILabel!
    @IBOutlet weak var applyBonusCoinLabel: UILabel!
    @IBOutlet weak var applyBonusCoinButton: UIButton!
    @IBOutlet weak var appliedBonusAmountLabel: UILabel!
    
    @IBOutlet weak var bonusCoinView: UIView!
    
    @IBOutlet weak var bonusCoinViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bonusCoinListCollectionView: UICollectionView!
    @IBOutlet weak var bonusCoinPackListTableView: UITableView!
    
    
    @IBOutlet weak var payAmountLabel: UILabel!
    @IBOutlet weak var joinContestButton: UIButton!
    
    
 
    
    @IBOutlet weak var buyCoinButton: UIButton!
    
    @IBOutlet weak var paymentView: UIView!
    

    @IBOutlet weak var selectTermButton: UIButton!
    @IBOutlet weak var paymentMethodsLabel: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var paymentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var paymentChannelTableView: UITableView!
    
    
    
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
    
    var availableBonusCoinPack:[Any] = []
    
    var applicableBonusCoinList = [200,300,400,500,750]
    
    var amountLeft = 0
    var bonus_coin_id = 0
    var appliedBonusCoinAmount = 0
    var userTotalCoin = 0
    var toPayAmount = 0
    
    struct Channels {
        let name: String
        let channelName: String
        let max: Int
        let min: Int
        let icon: String
        var selected: Bool
    }
    
    var channelList: [Channels] = []
    
    
    private var selectedPaymentMethod: Int? {
        didSet {
            paymentChannelTableView.reloadData()
        }
    }
    
    var selectedChannelType = "None"
    
    var channels:[PaymentChannels] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        
        
        self.tabBarController?.tabBar.isHidden = true
        
        // placeNavBar(withTitle: "CONTESTS", isBackBtnVisible: true)
        
        navTitleLabel.text = "CONTESTS".localized
        
        prizeListLabel.text = "Prize List".localized
      //  taxlabel.text = "Tax Msg".localized
        
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        
        
        vsLabel.makeCircular(borderWidth: 1, borderColor: UIColor.init(named: "HighlightGrey")!)
        //  createTeamButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        createTeamButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        createTeamButton.layer.shadowColor = UIColor.gray.cgColor
        createTeamButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        createTeamButton.layer.shadowRadius = 2
        createTeamButton.layer.shadowOpacity = 0.5
        createTeamButton.layer.masksToBounds = false
        
        signUpButton.buttonRound(5, borderWidth: 0.5, borderColor: UIColor.init(named: "brand_red")!)
        loginButton.buttonRound(5, borderWidth: 0.5, borderColor: UIColor.init(named: "brand_red")!)
        
        contestTableView.register(UINib(nibName: "ContestTableViewCell", bundle: nil), forCellReuseIdentifier: "contestCell")
        
      
        
        contestTableView.delegate = self
        contestTableView.dataSource = self
        contestTableView.removeEmptyCells()
        
        prizeRankTableView.delegate = self
        prizeRankTableView.dataSource = self
        prizeRankTableView.removeEmptyCells()
        
        bonusCoinPackListTableView.delegate = self
        bonusCoinPackListTableView.dataSource = self
        bonusCoinPackListTableView.removeEmptyCells()
        
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
        applyBonusCoinLabel.text = "Apply Bonus Coin".localized
        toPayLabel.text = "To Pay".localized
        

        buyCoinButton.setTitle("BUY COINS".localized, for: .normal)
        joinContestButton.setTitle("JOIN CONTEST".localized, for: .normal)
        
        blockSuggestionTextView.text = "Your profile has been blocked! To know about reason of blocking or to resolve the matter please message to our facebook page https://www.facebook.com/gameof11/ . GO11 support team will guide you for further procedure.".localized
        
        

        
        blockSuggestionTextView.isEditable = false;
        blockSuggestionTextView.dataDetectorTypes = UIDataDetectorTypes.all;
        
        
        
        contestTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData(_:)), name: NSNotification.Name(rawValue: "updateContestDetails"), object: nil)
        
        // Register to receive notification in your class
              NotificationCenter.default.addObserver(self, selector: #selector(self.paymentSuccessful(_:)), name: NSNotification.Name(rawValue: "paymentFromContestList"), object: nil)
        //paymentFromContestListMaxPanel
        NotificationCenter.default.addObserver(self, selector: #selector(self.paymentSuccessfulMaxPanel(_:)), name: NSNotification.Name(rawValue: "paymentFromContestListMixpanel"), object: nil)
              
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
            
            if type == .next  { // normal contest list view after match selection
                
                self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatch?.joiningLastTime?.lowercased() ?? "" )
                
            }else if type == .upcomingContest{ // for mycontest
                
                navTitleLabel.text = "JOINED CONTESTS".localized
                infoButton.isHidden = true
                cashInfoButton.isHidden = true
                self.statusLabel.text = String.init(format: "%@ Left".localized,self.parentMatch?.joiningLastTime?.lowercased() ?? "" )
                
                
            }else if type == .liveContest{ // for mycontest
                
                navTitleLabel.text = "JOINED CONTESTS".localized
                infoButton.isHidden = true
                cashInfoButton.isHidden = true
                self.statusLabel.text = "In Progress".localized
                
            }else if type == .completedContest{ // for mycontest
                
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
            
            if type == .next  { // normal contest list view after match selection
                
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
            
            print("match type", type)
            
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
        

        
        paymentMethodsLabel.text = "Payment Methods".localized
        payButton.setTitle("PAY NOW".localized, for: .normal)
        //get payment channel
        
      //  getPaymentChannel()
       
        bonusCoinListCollectionView.delegate = self
        bonusCoinListCollectionView.dataSource = self

        paymentChannelTableView.delegate = self
        paymentChannelTableView.dataSource = self
        paymentChannelTableView.tableFooterView = UIView()
        paymentChannelTableView.register(UINib(nibName: "PaymentChannelCell", bundle: nil), forCellReuseIdentifier: "paymentChannelCell")

        //at the biginning
        self.bonusCoinViewHeightConstraint.constant = 0
        self.bonusCoinView.isHidden = true

        //get bonus coin
        
        availableBonusCoin()
    }
    
    
    
    @objc private func refreshData(_ sender: Any) {
        
        
        print("refreshData called................")
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            if type == .next{
                
                // normal contest list view after match selection
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
                
                // normal contest list view after match selection
                    
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
        
        if selectedPaymentMethod != nil{
            
            selectedPaymentMethod = nil
            selectedChannelType = "None"
            
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
        
        
        print("viewdidappear..........................")
     
        
    }
    
    func availableBonusCoin(){
        
        // available bonus coin
        
        var lang = "en"
        
        if Language.language == Language.bangla{
            
            lang = "bn"
            
        }
        
        APIManager.manager.getAvailableBonusCoin(lang: lang) { (logArray) in
            
            if logArray.isEmpty{
                
                print("availableBonusCoinPack is empty")
                
            }else{
                
                self.availableBonusCoinPack = logArray
                print("availableBonusCoinPack",self.availableBonusCoinPack)
                self.bonusCoinPackListTableView.reloadData()
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
                    
                    //set mixpanel profile
                    
//                    Mixpanel.mainInstance().identify(distinctId: um?.phone ?? "0")
//
//                    let p: Properties = ["Phone": um?.phone ?? "",
//                                         "Name": um?.name ?? "",
//                                         "Email": um?.email ?? "",
//                                         "Address": um?.address ?? "",
//                                         "Created_At": um?.created_at ?? ""]
//
//                    Mixpanel.mainInstance().people.set(properties: p)
                    //BD5CD4C4-63FD-4D85-93E1-9A167CC23953
                    
                  
                    
                }
            }
        }else{
            
            self.refreshControl.endRefreshing()
            
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
                    
                    
                    //set mixpanel profile
                    
//                    Mixpanel.mainInstance().identify(distinctId: um?.phone ?? "0")
//
//                    let p: Properties = ["Phone": um?.phone ?? "",
//                                         "Name": um?.name ?? "",
//                                         "Email": um?.email ?? "",
//                                         "Address": um?.address ?? "",
//                                         "Created_At": um?.created_at ?? ""]
//
//                    Mixpanel.mainInstance().people.set(properties: p)
                    //BD5CD4C4-63FD-4D85-93E1-9A167CC23953
                   
                }
            }
        }else{
            
            self.refreshControl.endRefreshing()
            
        }
        
    }
    
    //Bonus coin collectionview in confirmationview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return applicableBonusCoinList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bonusCoinCell", for: indexPath) as! BonusCoinCollectionViewCell
        
        //coinAmountLabel
        cell.coinAmountLabel.text = String(describing: applicableBonusCoinList[indexPath.item])
        
        let amount  = Int(cell.coinAmountLabel.text ?? "0")!
        let entryAmount = Int(self.entryAmountLabel.text ?? "0")!
       
        print("amount...........",amount)
        
        
        
        if  amount > amountLeft{
            
            print("no interaction.........if choose big amount then coin left in pack ")
            cell.isUserInteractionEnabled = false
            
            
            
        }else{
            
            cell.isUserInteractionEnabled = true
            
            if amount > entryAmount{
                
                print("no interaction.........if choose big amount then entry")
                cell.isUserInteractionEnabled = false
                
            }else{
                
                cell.isUserInteractionEnabled = true
            }
        }
        


        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.size.height + 30, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("didSelectItemAt")
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        
        if let cell = cell as? BonusCoinCollectionViewCell{
        //
            let amount  = Int(cell.coinAmountLabel.text ?? "0")!
            let entryAmount = Int(self.entryAmountLabel.text ?? "0")!
            let toPay = entryAmount - amount
            
            appliedBonusCoinAmount = amount
            print("amount...........appliedBonusCoinAmount",amount,entryAmount,toPay,appliedBonusCoinAmount)
            
            if toPay == 0 {
                
                self.buyCoinButton.isHidden = true
                self.joinContestButton.isHidden = false
            }else{
                if toPay > userTotalCoin{
                    
                self.buyCoinButton.isHidden = false
                self.joinContestButton.isHidden = true
                }else{
                    self.buyCoinButton.isHidden = true
                    self.joinContestButton.isHidden = false

                }

            }
            
 //           if Language.language == Language.english{
                
                self.appliedBonusAmountLabel.text = String.init(format:"-%d",amount)
                
                self.payAmountLabel.text = String.init(format:"%d",toPay)
                
//            }else{
//                let bnNumberString = self.formatter.string(for: amount)
//                let bnNumberString1 = self.formatter.string(for: toPay)
//
//                self.appliedBonusAmountLabel.text = String.init(format:"-%@",bnNumberString!)
//                self.payAmountLabel.text = String.init(format:"%@",bnNumberString1!)
//            }


            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.contestTableView{
            return 1
        }else if tableView == self.paymentChannelTableView{
            return channelList.count
        }else if tableView == self.bonusCoinPackListTableView{
            return 1
        }else{
            
            return prizeFilteredArray.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == self.contestTableView{
            return activeContestList.count
        }else if tableView == self.paymentChannelTableView{
            return 1
        }else if tableView == self.bonusCoinPackListTableView{
            return availableBonusCoinPack.count
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
            
           // cell.joinedButton.addTarget(self, action: #selector(teamSelectAction(_:)), for: .touchUpInside)
            
            //added this invisible button,so that user can interect properly
            cell.joinedShadowButton.tag = contest.id ?? 0
            cell.joinedShadowButton.addTarget(self, action: #selector(teamSelectAction(_:)), for: .touchUpInside)
            
            //    }
            
            cell.editButton.tag = contest.id ?? 0
            cell.editButton.addTarget(self, action: #selector(teamEditInJoinedContestAction(_:)), for: .touchUpInside)
            
            
            
            
            print("contest type",contest.contestType)
            
            cell.totalWinnerButton.tag = indexPath.section
            
            cell.totalWinnerButton.addTarget(self, action: #selector(prizeCalculation(_:)), for: .touchUpInside)
            
            return cell
        }else if tableView == self.paymentChannelTableView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"paymentChannelCell") as! PaymentChannelCell

            
            // 2
            cell.selectionStyle = .none
            // 3
            let method = channelList[indexPath.row]
            
            // 4
            let currentIndex = indexPath.row
            // 5
            let selected = currentIndex == selectedPaymentMethod
            // 6
            //cell.configure(method.name,method.icon)
            cell.configure(method.name)
           
            // 7
            cell.isSelected(selected)
            // 8
            return cell
        }else if tableView == self.bonusCoinPackListTableView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"bonusCoinPackCell") as! BonusCoinTableViewCell
            
            let singlePack = availableBonusCoinPack[indexPath.section] as! Dictionary<String,Any>
            
            cell.bonusPackNameLabel.text = String(describing: singlePack["title"]!)
            cell.bonusAmountLabel.text = String(describing: singlePack["available_coin"]!)
            cell.dateLabel.text = String(describing: singlePack["expiry_date"]!)
            
            print("singlePac.......",singlePack)
            
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        print("type...............",type)
        
        if let cell = cell as? ContestTableViewCell{
            
            let contest = activeContestList[indexPath.section]
            cell.joinedButton.setTitleColor(UIColor.white, for: .normal)
            
            if (contest.isJoined != 0)
            {
                
                cell.joinedButton.setBackgroundColor(UIColor.init(named: "red_light")!, for: UIControl.State.normal)
                cell.joinedButton.setTitle("JOINED".localized, for: UIControl.State.normal)
                cell.joinedButton.isUserInteractionEnabled = false
                cell.joinedButton.isEnabled = false
                cell.joinedShadowButton.isUserInteractionEnabled = false
                if type == .liveContest || type == .completedContest{
                    
                    cell.editButton.isHidden = true
                    
                }else{
                    
                    cell.editButton.isHidden = false
                }
                
            }
            else
            {
                cell.joinedButton.setBackgroundColor(UIColor.init(named: "brand_red")!, for: UIControl.State.normal)
                cell.joinedButton.setTitle("JOIN".localized, for: UIControl.State.normal)
                cell.joinedButton.isUserInteractionEnabled = true
                cell.joinedShadowButton.isUserInteractionEnabled = true
                cell.editButton.isHidden = true
                
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
        }else if tableView == self.bonusCoinPackListTableView{
            
            print("cell selected.........")
            let singlePack = self.availableBonusCoinPack[indexPath.section] as! Dictionary<String,Any>
            
            amountLeft = singlePack["available_coin"]! as! Int
            
            bonus_coin_id = singlePack["bonus_coin_id"]! as! Int
            
            
            let entryAmount = Int(self.entryAmountLabel.text ?? "0")!

            print(" did select amountLeft", amountLeft,bonus_coin_id)
            
            // change previous selection
 //           if Language.language == Language.english{
                
                self.appliedBonusAmountLabel.text = "- 0"
                //let payAmount = entryAmount / 50  // convert coin to tk, 1tk = 50 coin
                self.payAmountLabel.text = String.init(format:"%d",entryAmount)
                
//            }else{
//                //let payAmount = entryAmount / 50
//                let bnNumberString1 = self.formatter.string(for: entryAmount)
//
//                self.appliedBonusAmountLabel.text =  "- ০"
//
//                self.payAmountLabel.text = String.init(format:"%@",bnNumberString1!)
//            }

            
            self.bonusCoinListCollectionView.reloadData()
            self.bonusCoinListCollectionView.isHidden = false
           
            
        }else if tableView == paymentChannelTableView{
            
            updateSelectedIndex(indexPath.row)
            

            let method = channelList[indexPath.row]
            
            selectedChannelType = method.channelName

            
            
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
        }else if tableView == bonusCoinPackListTableView{
            
            return 55
        } else{
            
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == self.bonusCoinPackListTableView{
            
            return 5
        }else{
            return 0;
            
        }
        
    }
    
    
    private func updateSelectedIndex(_ index: Int) {
        
        selectedPaymentMethod = index
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
                        popupVC?.isLineUpOut = self.parentMatch?.isLineUpOut ?? 0
                        
                        self.navigationController?.pushViewController(popupVC ?? self, animated: true)
                    }else{
                        
                        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamCreateFootballViewController") as? TeamCreateFootballViewController
                        
                        popupVC?.squadData = squadData
                        popupVC?.timeLeft = self.parentMatchFootball?.joiningLastTime
                        popupVC?.isLineUpOut = self.parentMatchFootball?.isLineUpOut ?? 0
                        
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
    
    //after clicking join button
    @IBAction func teamSelectAction(_ sender: UIButton) {
        
        if AppSessionManager.shared.authToken == nil {
            
            loginSuggestionLabel.text = "You have to Login or Sign Up to join any contest. Before joining contests you can create your own Fantasy Team. Please Login or Sign Up to prove your skill.".localized
            self.backShadeView.isHidden = false
            self.signUpView.isHidden = false
            
        }
        else
        {
            
            
            
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
                                
                                if selectedContest!.contestType == "free"{
                                    
                                    let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                                    
                                    popupVC?.modalPresentationStyle = .overCurrentContext
                                    popupVC?.modalTransitionStyle = .crossDissolve
                                    popupVC?.teams = self.createdTeamList
                                    popupVC?.contestId = sender.tag
                                    popupVC?.delegate = self
                                    
                                    self.present(popupVC!, animated: true) {
                                        
                                        
                                    }
                                    
                                }else{
                                    
                                    APIManager.manager.getWalletInfo{ (dataDic) in
                                        
                                     
                                            let totalCoin = dataDic["total_coins"]! as! Int
                                            self.userTotalCoin = totalCoin
                                            
                                            if  totalCoin < self.selectedContest!.entryAmount!{
                                                
                                                print("not enough coin")
                                                
                                                if self.availableBonusCoinPack.count > 0 {
                                                    
                                                    self.backShadeView.isHidden = false
                                                    self.confirmationView.isHidden = false
                                                    self.applyBonusCoinButton.isSelected = false
                                                    self.bonusCoinListCollectionView.isHidden = true
                                                    self.bonusCoinViewHeightConstraint.constant = 0
                                                    self.joinContestButton.isHidden = true
                                                    self.buyCoinButton.isHidden = false
                                                    self.applyBonusCoinLabel.textColor =  UIColor.init(named: "brand_txt_color_black")!
                                                    self.applyBonusCoinButton.isUserInteractionEnabled = true


                                                    
                                                    if Language.language == Language.english{
                                                        
                                                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin))
                                                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                                                        
                                                        
                                                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                        
                                                        print("free contest allowed")
                                                        
                                                        self.appliedBonusAmountLabel.text = "- 0"
                                                        //let payAmount = self.selectedContest!.entryAmount! / 50  // convert coin to tk, 1tk = 50 coin
                                                                                                       
                                                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                       
                                                    }else{
                                                        
                                                        let bnNumberString = self.formatter.string(for: totalCoin )
                                                        let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                                                        
//                                                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, bnNumberString!)
                                                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, String(totalCoin))
                                                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                                                        

                                                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                        
                                                       // self.appliedBonusAmountLabel.text = "- ০"
                                                        self.appliedBonusAmountLabel.text = "- 0"
                                                        
                                                       // let payAmount = self.selectedContest!.entryAmount! / 50
                                                        let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                                                      
                                                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                        
                                                    }
                                                    
                                                }else{
                                                    
                                                    self.backShadeView.isHidden = false
                                                    self.confirmationView.isHidden = false
                                                    self.applyBonusCoinButton.isSelected = false
                                                    self.bonusCoinListCollectionView.isHidden = true
                                                    self.bonusCoinViewHeightConstraint.constant = 0

                                                    self.joinContestButton.isHidden = true
                                                    self.buyCoinButton.isHidden = false
                                                    
                                                    if Language.language == Language.english{
                                                        
                                                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin ?? 0))
                                                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                                                        

                                                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                        
                                                        
                                                        self.appliedBonusAmountLabel.text = "- 0"
                                                        self.applyBonusCoinLabel.textColor = UIColor.lightGray
                                                        self.applyBonusCoinButton.isUserInteractionEnabled = false
                                                        print("No bonus coin pack")
                                                        
                                                       // let payAmount = self.selectedContest!.entryAmount! / 50
                                                                                                       
                                                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                       

                                                    }else{
                                                        
                                                        let bnNumberString = self.formatter.string(for: totalCoin )
                                                        let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                                                        
                                                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, String(totalCoin ?? 0))
                                                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                                                        

                                                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                        
                                                        //self.appliedBonusAmountLabel.text = "- ০"
                                                        self.appliedBonusAmountLabel.text = "- 0"
                                                        
                                                    
                                                        self.applyBonusCoinLabel.textColor = UIColor.lightGray
                                                        self.applyBonusCoinButton.isUserInteractionEnabled = false
                                                        print("free contest not allowed")
                                                        
                                                      //  let payAmount = self.selectedContest!.entryAmount! / 50
                                                        let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                                                      
                                                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                        
                                                    }
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
                        
                        //Football...........
                        
                        if self.createdTeamListFootball.count > 0
                        {
                            
                            for contest in activeContestList{
                                
                                if sender.tag == contest.id{
                                    
                                    selectedContest = contest
                                }
                            }
                            
                            if selectedContest!.total_user_joined! < selectedContest!.teamsCapacity!{
                                
                                if selectedContest!.contestType == "free"{
                                    
                                    let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                                    
                                    popupVC?.modalPresentationStyle = .overCurrentContext
                                    popupVC?.modalTransitionStyle = .crossDissolve
                                    popupVC?.teamsFootball = self.createdTeamListFootball
                                    popupVC?.contestId = sender.tag
                                    popupVC?.delegate = self
                                    
                                    self.present(popupVC!, animated: true) {
                                        
                                        
                                    }
                                    
                                }else{
                                
                                APIManager.manager.getWalletInfo { (dataDic) in
                                    
                                 
                                        let totalCoin = dataDic["total_coins"]! as! Int
                                        self.userTotalCoin = totalCoin
                                    
                                        if  totalCoin < self.selectedContest!.entryAmount!{
                                            
                                            print("not enough coin")
                                            
                                            if self.availableBonusCoinPack.count > 0 {
                                                
                                                self.backShadeView.isHidden = false
                                                self.confirmationView.isHidden = false
                                                self.applyBonusCoinButton.isSelected = false
                                                self.bonusCoinListCollectionView.isHidden = true
                                                self.bonusCoinViewHeightConstraint.constant = 0

                                                self.joinContestButton.isHidden = true
                                                self.buyCoinButton.isHidden = false
                                                self.applyBonusCoinLabel.textColor =  UIColor.init(named: "brand_txt_color_black")!
                                                self.applyBonusCoinButton.isUserInteractionEnabled = true


                                                if Language.language == Language.english{
                                                    
                                                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin))
                                                    self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                                                    

                                                    self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                    
                                                    print("free contest allowed")
                                                    
                                                    self.appliedBonusAmountLabel.text = "- 0"
                                                    
                                                    self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                   
                                                }else{
                                                    
                                                    let bnNumberString = self.formatter.string(for: totalCoin )
                                                    let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                                                    
                                                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, String(totalCoin))
                                                    self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                                                    

                                                    self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                    
                                                    self.appliedBonusAmountLabel.text = "- 0"
                                                    
                                                    
                                                    let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                                                                    
                                                    self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                    
                                                }
                                                
                                            }else{
                                                
                                                self.backShadeView.isHidden = false
                                                self.confirmationView.isHidden = false
                                                self.applyBonusCoinButton.isSelected = false
                                                self.bonusCoinListCollectionView.isHidden = true
                                                self.bonusCoinViewHeightConstraint.constant = 0

                                                self.joinContestButton.isHidden = true
                                                self.buyCoinButton.isHidden = false
                                                
                                                if Language.language == Language.english{
                                                    
                                                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin ?? 0))
                                                    self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                                                    

                                                    self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                    
                                                    
                                                    self.appliedBonusAmountLabel.text = "- 0"
                                                    self.applyBonusCoinLabel.textColor = UIColor.lightGray
                                                    self.applyBonusCoinButton.isUserInteractionEnabled = false
                                                    print("No bonus coin pack")
                                                    
                                                    self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                    
                                                    
                                                    
                                                }else{
                                                    
                                                    let bnNumberString = self.formatter.string(for: totalCoin )
                                                    let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                                                    
                                                    self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, String(totalCoin ?? 0))
                                                    self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                                                    

                                                    self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                    
                                                    self.appliedBonusAmountLabel.text = "- ০"
                                                    
                                                    let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                                                    
                                                    self.applyBonusCoinLabel.textColor = UIColor.lightGray
                                                    self.applyBonusCoinButton.isUserInteractionEnabled = false
                                                    print("free contest not allowed")
                                                    
                                                    self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                                                    
                                                }
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
    
    @IBAction func teamEditInJoinedContestAction(_ sender: UIButton) {
        
        if AppSessionManager.shared.authToken == nil {
            
            loginSuggestionLabel.text = "You have to Login or Sign Up to join any contest. Before joining contests you can create your own Fantasy Team. Please Login or Sign Up to prove your skill.".localized
            self.backShadeView.isHidden = false
            self.signUpView.isHidden = false
            
        }
        else
        {
            if let um = AppSessionManager.shared.currentUser {
                
                if um.isBlocked == 1{
                    print("Blocked...............")
                    backShadeView.isHidden = false
                    blockSuggestionView.isHidden = false
                    
                }else{
                    for contest in activeContestList{
                        if sender.tag == contest.id{
                            selectedContest = contest
                        }
                    }
                    let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                    popupVC?.modalPresentationStyle = .overCurrentContext
                    popupVC?.modalTransitionStyle = .crossDissolve
                    popupVC?.contestId = sender.tag
                    popupVC?.delegate = self
                    popupVC?.forTeamChange = true
                    
                    if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        
                        //                        if let index = self.createdTeamList.firstIndex(where: {$0.userTeamId == selectedContest?.userTeamId}){
                        //                            popupVC?.selectedIndex = index;
                        //                            print("selected team id index.........",selectedContest?.userTeamId,index)
                        //                        }
                        
                        let index = self.createdTeamList.filter({($0 as CreatedTeam).userTeamId == selectedContest?.userTeamId})
                        for team in index
                        {
                            popupVC?.selectedTeamId = team.userTeamId
                            print("selected team id index.........",selectedContest?.userTeamId,team.userTeamId)
                            
                        }
                        popupVC?.teams = self.createdTeamList
                        
                        if (self.createdTeamList.count != 0)
                        {
                            self.present(popupVC!, animated: true) {
                            }
                        }
                    }else{
                        
                        let index = self.createdTeamListFootball.filter({($0 as CreatedTeamFootball).userTeamId == selectedContest?.userTeamId})
                        for team in index
                        {
                            popupVC?.selectedTeamId = team.userTeamId
                            print("selected team id index.........",selectedContest?.userTeamId,team.userTeamId)
                            
                        }
                        popupVC?.teamsFootball = self.createdTeamListFootball
                        if (self.createdTeamListFootball.count != 0)
                        {
                            self.present(popupVC!, animated: true) {
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
    
    //back from team select
    func selectedTeam(team: CreatedTeam,contestId: Int, isDerectJoinApplicable: Bool) {
        
        
        for contest in activeContestList{
            
            if contestId == contest.id{
                
                selectedContest = contest
                
                print("contestId..............",contestId)
            }
        }
        
        print("isDerectJoinApplicable......",isDerectJoinApplicable)
        
        if isDerectJoinApplicable{
            
            print("derect join")
            
            self.backShadeView.isHidden = true
            self.confirmationView.isHidden = true
            self.selectedTeamId = team.userTeamId ?? 0
            self.selectedContestId = contestId
            
            self.joinContestButtonAction(nil)


        }else{
            
            APIManager.manager.getWalletInfo{ (dataDic) in
                
                
                let totalCoin = dataDic["total_coins"]! as! Int
                self.userTotalCoin = totalCoin
                
                if self.selectedContest?.contestType == "free"{
                    
                    
                    self.backShadeView.isHidden = false
                    self.confirmationView.isHidden = false
                    self.applyBonusCoinButton.isSelected = false
                    self.bonusCoinListCollectionView.isHidden = true
                    self.bonusCoinViewHeightConstraint.constant = 0

                    self.joinContestButton.isHidden = false
                    self.buyCoinButton.isHidden = true

                    
                    self.selectedTeamId = team.userTeamId ?? 0
                    self.selectedContestId = contestId
                    
                    if Language.language == Language.english{
                        
                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin ?? 0))
                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                        

                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        
                        self.appliedBonusAmountLabel.text = "- 0"
                        self.applyBonusCoinLabel.textColor = UIColor.lightGray
                        self.applyBonusCoinButton.isUserInteractionEnabled = false
                        
                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        
                        
                    }else{
                        
                        let bnNumberString = self.formatter.string(for: totalCoin )
                        
                        let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                        
                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, String(totalCoin ?? 0))
                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                        

                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        self.appliedBonusAmountLabel.text = "- 0"
                        
                        let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                        
                        self.applyBonusCoinLabel.textColor = UIColor.lightGray
                        self.applyBonusCoinButton.isUserInteractionEnabled = false
                        
                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                    }
                }else{
                    
                    
                    if self.availableBonusCoinPack.count > 0 {
                        
                        self.backShadeView.isHidden = false
                        self.confirmationView.isHidden = false
                        self.applyBonusCoinButton.isSelected = false
                        self.bonusCoinListCollectionView.isHidden = true
                        self.bonusCoinViewHeightConstraint.constant = 0

                        self.joinContestButton.isHidden = false
                        self.buyCoinButton.isHidden = true
                        
                        self.applyBonusCoinLabel.textColor =  UIColor.init(named: "brand_txt_color_black")!
                        self.applyBonusCoinButton.isUserInteractionEnabled = true

                        
                        self.selectedTeamId = team.userTeamId ?? 0
                        self.selectedContestId = contestId
                        
                        if Language.language == Language.english{
                            
                            self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin))
                            self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                            

                            self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                            
                            print("free contest allowed")
                            
                            self.appliedBonusAmountLabel.text = "- 0"
                            
                            self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                           
                        }else{
                            
                            let bnNumberString = self.formatter.string(for: totalCoin )
                           
                            let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                            
                            self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, String(totalCoin))
                            self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                            

                            self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                            
                            self.appliedBonusAmountLabel.text = "- 0"
                            
                            
                            let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                                            
                            self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                            
                        }
                        
                    }else{
                        
                     
                        self.backShadeView.isHidden = false
                        self.confirmationView.isHidden = false
                        self.applyBonusCoinButton.isSelected = false
                        self.bonusCoinListCollectionView.isHidden = true
                        self.bonusCoinViewHeightConstraint.constant = 0

                        self.joinContestButton.isHidden = false
                        self.buyCoinButton.isHidden = true

                        
                        self.selectedTeamId = team.userTeamId ?? 0
                        self.selectedContestId = contestId
                        
                        if Language.language == Language.english{
                            
                            self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin ?? 0))
                            self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                            

                            self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                            
                            
                            self.appliedBonusAmountLabel.text = "- 0"
                            self.applyBonusCoinLabel.textColor = UIColor.lightGray
                            self.applyBonusCoinButton.isUserInteractionEnabled = false
                            print("No bonus coin pack")
                            
                            self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                            
                            
                            
                        }else{
                            
                            let bnNumberString = self.formatter.string(for: totalCoin )
                            
                            let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                            
                            self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, String(totalCoin ?? 0))
                            self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                            

                            self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                            
                            self.appliedBonusAmountLabel.text = "- 0"
                            
                            let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                            
                            self.applyBonusCoinLabel.textColor = UIColor.lightGray
                            self.applyBonusCoinButton.isUserInteractionEnabled = false
                            print("free contest not allowed")
                            
                            self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                            
                        }
                    }
                }
                
            }

        }
        

       
    }
    
    ////back from team select

    func selectedTeamFootball(team: CreatedTeamFootball, contestId: Int, isDerectJoinApplicable: Bool) {
        
        
        for contest in activeContestList{
            
            if contestId == contest.id{
                
                selectedContest = contest
            }
        }
        
        if isDerectJoinApplicable{
            
            print("derect join")
            self.backShadeView.isHidden = true
            self.confirmationView.isHidden = true
            self.selectedTeamId = team.userTeamId ?? 0
            self.selectedContestId = contestId
            
            self.joinContestButtonAction(nil)

            
        }else{
            
            APIManager.manager.getWalletInfo { (dataDic) in
                
                
                let totalCoin = dataDic["total_coins"]! as! Int
                self.userTotalCoin = totalCoin
                
                if self.selectedContest?.contestType == "free"{
                    
                    
                    self.backShadeView.isHidden = false
                    self.confirmationView.isHidden = false
                    self.applyBonusCoinButton.isSelected = false
                    self.bonusCoinListCollectionView.isHidden = true
                    self.bonusCoinViewHeightConstraint.constant = 0

                    self.joinContestButton.isHidden = false
                    self.buyCoinButton.isHidden = true

                    
                    self.selectedTeamId = team.userTeamId ?? 0
                    self.selectedContestId = contestId
                    
                    if Language.language == Language.english{
                        
                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin ?? 0))
                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                        

                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        
                        self.appliedBonusAmountLabel.text = "- 0"
                        self.applyBonusCoinLabel.textColor = UIColor.lightGray
                        self.applyBonusCoinButton.isUserInteractionEnabled = false
                        
                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        
                        
                    }else{
                        
                        let bnNumberString = self.formatter.string(for: totalCoin )
                        
                        let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                        
                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, String(totalCoin ?? 0))
                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                        

                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        self.appliedBonusAmountLabel.text = "- 0"
                        
                        let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                        
                        self.applyBonusCoinLabel.textColor = UIColor.lightGray
                        self.applyBonusCoinButton.isUserInteractionEnabled = false
                        
                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                    }
                }else{
                
                if self.availableBonusCoinPack.count > 0 {
                    
                    self.backShadeView.isHidden = false
                    self.confirmationView.isHidden = false
                    self.applyBonusCoinButton.isSelected = false
                    self.bonusCoinListCollectionView.isHidden = true
                    self.bonusCoinViewHeightConstraint.constant = 0

                    self.joinContestButton.isHidden = false
                    self.buyCoinButton.isHidden = true
                    
                    self.applyBonusCoinLabel.textColor =  UIColor.init(named: "brand_txt_color_black")!
                    self.applyBonusCoinButton.isUserInteractionEnabled = true


                    
                    self.selectedTeamId = team.userTeamId ?? 0
                    self.selectedContestId = contestId
                    
                    if Language.language == Language.english{
                        
                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin))
                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                        

                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        print("free contest allowed")
                        
                        self.appliedBonusAmountLabel.text = "- 0"
                        
                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                       
                    }else{
                        
                        let bnNumberString = self.formatter.string(for: totalCoin )
                       
                        let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                        
                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, String(totalCoin))
                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                        

                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        self.appliedBonusAmountLabel.text = "- 0"
                        
                        
                        let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                                        
                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                    }
                    
                }else{
                    
                 
                    self.backShadeView.isHidden = false
                    self.confirmationView.isHidden = false
                    self.applyBonusCoinButton.isSelected = false
                    self.bonusCoinListCollectionView.isHidden = true
                    self.bonusCoinViewHeightConstraint.constant = 0

                    self.joinContestButton.isHidden = false
                    self.buyCoinButton.isHidden = true

                    
                    self.selectedTeamId = team.userTeamId ?? 0
                    self.selectedContestId = contestId
                    
                    if Language.language == Language.english{
                        
                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@",String(totalCoin ?? 0))
                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                        

                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        
                        self.appliedBonusAmountLabel.text = "- 0"
                        self.applyBonusCoinLabel.textColor = UIColor.lightGray
                        self.applyBonusCoinButton.isUserInteractionEnabled = false
                        print("No bonus coin pack")
                        
                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        
                        
                    }else{
                        
                        let bnNumberString = self.formatter.string(for: totalCoin )
                        
                        let bnNumberString3 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0 )
                        
                        self.totalCoinCountLabel.text = String.init(format: "Your total coins = %@".localized, String(totalCoin ?? 0))
                        self.contestNameLabelInConfirmationView.text = String.init(format:"%@",self.selectedContest?.name ?? "")
                        

                        self.entryAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                        self.appliedBonusAmountLabel.text = "- 0"
                        
                        let bnNumberString4 = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
                        
                        self.applyBonusCoinLabel.textColor = UIColor.lightGray
                        self.applyBonusCoinButton.isUserInteractionEnabled = false
                        print("No bonus coin pack")
                        
                        self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
                        
                    }
                }
            }
            }
        }
        
      
        
    }
    
    @IBAction func applyBonusCoinButtonAction(_ sender: UIButton) {
        
        self.bonusCoinListCollectionView.isHidden = true
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            

            UIView.animate(withDuration: 0.2, animations: {
                
                self.bonusCoinViewHeightConstraint.constant = 290
                self.bonusCoinView.isHidden = false
                self.view.layoutIfNeeded()
            })
            
            

//            if Language.language == Language.english{
//
//                self.appliedBonusAmountLabel.text = String.init(format:"-%d",self.selectedContest?.entryAmount ?? 0)
//                self.payAmountLabel.text = "0"
//
//            }else{
//                let bnNumberString = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
//
//                self.appliedBonusAmountLabel.text = String.init(format:"-%@",bnNumberString!)
//                self.payAmountLabel.text = "০"
//            }
//
            
            
        }else{
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.bonusCoinViewHeightConstraint.constant = 0
                self.bonusCoinView.isHidden = true
                
                self.view.layoutIfNeeded()
            })
            
//            if Language.language == Language.english{
//
//                self.appliedBonusAmountLabel.text = "-0"
//                self.payAmountLabel.text = String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
//            }else{
//                let bnNumberString = self.formatter.string(for: self.selectedContest?.entryAmount ?? 0)
//
//                self.appliedBonusAmountLabel.text = "-০"
//                self.payAmountLabel.text = String.init(format:"%@",bnNumberString!)
//            }
            
        }
        
    }
    
    
    
    @IBAction func joinContestButtonAction(_ sender: Any?) {
        
        
        print("selectedContestId........",selectedContestId,selectedTeamId)
        
        if selectedTeamId != 0{
            
            joinContestButton.isUserInteractionEnabled = false
           
            var params:[String:String] = [:]
           
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                
                if appliedBonusCoinAmount != 0{
                    
                    params = ["contest_id":String.init(format: "%d", selectedContestId),
                              "user_team_id":String.init(format: "%d", selectedTeamId),
                              "bonus_coin_id":String.init(format: "%d", bonus_coin_id),
                              "coin_amount":String.init(format: "%d", appliedBonusCoinAmount)
                    ]

                }else{
                    
                    params = ["contest_id":String.init(format: "%d", selectedContestId),
                              "user_team_id":String.init(format: "%d", selectedTeamId)
                             ]

                }
                 
                
                print("joinContestButtonAction .........params",params)
                APIManager.manager.joinInContestWith(params:params, withCompletionHandler: { (status, msg) in
                    if status{
                        self.joinContestButton.isUserInteractionEnabled = true

                        //so that old value become 0
                        self.selectedTeamId = 0
                        self.selectedContestId = 0
                        
                        //to remove old value
                        if self.appliedBonusCoinAmount != 0{
                            
                            self.appliedBonusCoinAmount = 0
                            self.bonus_coin_id = 0
                        }
                        
                        
                        self.bonusCoinListCollectionView.reloadData()
                        self.bonusCoinPackListTableView.reloadData()

                        self.availableBonusCoin()

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





                        if self.selectedContest?.contestType == "free"{
                            var isUnlimited = "yes"
                            if self.selectedContest?.is_league == 1{

                                isUnlimited = "no"
                            }
                            //set joined_free_contest_cricket event in mixpanel
                            let p: Properties = ["contest_name": self.selectedContest?.name ?? "",
                                                 "contest_id": self.selectedContest?.id ?? "",
                                                 "total_winning_rank": self.selectedContest?.prizes.count ?? 0,
                                                 "entry_fee": self.selectedContest?.entryAmount ?? "",
                                                 "total_spot": self.selectedContest?.teamsCapacity ?? "",
                                                 "isUnlimited": isUnlimited ]
                            Mixpanel.mainInstance().track(event: "joined_free_contest_cricket", properties: p)//


                        }else{

                            var isUnlimited = "yes"
                            if self.selectedContest?.is_league == 1{

                                isUnlimited = "no"
                            }
                            //set joined_paid_contest_cricket event in mixpanel
                            let p: Properties = ["contest_name": self.selectedContest?.name ?? "",
                                                 "contest_id": self.selectedContest?.id ?? "",
                                                 "prize_money": self.selectedContest?.winningAmount ?? "",
                                                 "total_winning_rank": self.selectedContest?.prizes.count ?? 0,
                                                 "entry_fee": self.selectedContest?.entryAmount ?? "",
                                                 "total_spot": self.selectedContest?.teamsCapacity ?? "",
                                                 "isUnlimited": isUnlimited ]
                            Mixpanel.mainInstance().track(event: "joined_paid_contest_cricket", properties: p)//

                        }


                    }
                    else{

                        self.joinContestButton.isUserInteractionEnabled = true

                        self.view.makeToast(msg!)
                    }
                })
                
            }else{
                
                if appliedBonusCoinAmount != 0{
                    
                    params = ["contest_id":String.init(format: "%d", selectedContestId),
                              "user_team_id":String.init(format: "%d", selectedTeamId),
                              "bonus_coin_id":String.init(format: "%d", bonus_coin_id),
                              "coin_amount":String.init(format: "%d", appliedBonusCoinAmount)
                    ]

                }else{
                    
                    params = ["contest_id":String.init(format: "%d", selectedContestId),
                              "user_team_id":String.init(format: "%d", selectedTeamId)
                             ]

                }
                
                APIManager.manager.joinInFootballContestWith(params:params, withCompletionHandler: { (status, msg) in
                    if status{
                        self.joinContestButton.isUserInteractionEnabled = true
                        
                        //so that old value become 0
                        self.selectedTeamId = 0
                        self.selectedContestId = 0
                        
                        //to remove old value
                        if self.appliedBonusCoinAmount != 0{
                            
                            self.appliedBonusCoinAmount = 0
                            self.bonus_coin_id = 0
                        }

                        self.bonusCoinListCollectionView.reloadData()
                        self.bonusCoinPackListTableView.reloadData()
                        
                        self.availableBonusCoin()

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
                        
                        
                        if self.selectedContest?.contestType == "free"{
                            
                            var isUnlimited = "yes"
                            if self.selectedContest?.is_league == 1{
                                 
                                isUnlimited = "no"
                            }
                            //set joined_free_contest_football event in mixpanel
                            let p: Properties = ["contest_name": self.selectedContest?.name ?? "",
                                                 "contest_id": self.selectedContest?.id ?? "",
                                                 "total_winning_rank": self.selectedContest?.prizes.count ?? 0,
                                                 "entry_fee": self.selectedContest?.entryAmount ?? "",
                                                 "total_spot": self.selectedContest?.teamsCapacity ?? "",
                                                 "isUnlimited": isUnlimited ]
                            Mixpanel.mainInstance().track(event: "joined_free_contest_football", properties: p)//
                           
                            
                        }else{
                            var isUnlimited = "yes"
                            if self.selectedContest?.is_league == 1{
                                 
                                isUnlimited = "no"
                            }
                            
                            //set joined_paid_contest_football event in mixpanel
                            let p: Properties = ["contest_name": self.selectedContest?.name ?? "",
                                                 "contest_id": self.selectedContest?.id ?? "",
                                                 "prize_money": self.selectedContest?.winningAmount ?? "",
                                                 "total_winning_rank": self.selectedContest?.prizes.count ?? 0,
                                                 "entry_fee": self.selectedContest?.entryAmount ?? "",
                                                 "total_spot": self.selectedContest?.teamsCapacity ?? "",
                                                 "isUnlimited": isUnlimited ]
                            Mixpanel.mainInstance().track(event: "joined_paid_contest_football", properties: p)//
                           
                        }
                    }
                    else{
                        
                        self.joinContestButton.isUserInteractionEnabled = true
                        
                        self.view.makeToast(msg!)
                    }
                })
              
                
            }
            
        }else{
            
            joinContestButton.isUserInteractionEnabled = true
           
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                
                let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                
                popupVC?.modalPresentationStyle = .overCurrentContext
                popupVC?.modalTransitionStyle = .crossDissolve
                popupVC?.teams = self.createdTeamList
                popupVC?.contestId = self.selectedContest!.id!
                popupVC?.delegate = self
                popupVC?.isDerectJoinApplicable = true
                
                self.present(popupVC!, animated: true) {
                    
                    
                }
                
            }else{
                
                let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                
                popupVC?.modalPresentationStyle = .overCurrentContext
                popupVC?.modalTransitionStyle = .crossDissolve
                popupVC?.teamsFootball = self.createdTeamListFootball
                popupVC?.contestId = self.selectedContest!.id!
                popupVC?.delegate = self
                popupVC?.isDerectJoinApplicable = true
                
                self.present(popupVC!, animated: true) {
                    
                    
                }
            }
            
            
        }
        
        
       
        
    }
    
    
    
    @IBAction func closeConfirmationView(_ sender: Any) {
        
        confirmationView.isHidden = true
        self.backShadeView.isHidden = true
        
        //so that old value become 0
        selectedTeamId = 0
        selectedContestId = 0
        self.joinContestButton.isUserInteractionEnabled = true
        
        self.bonusCoinListCollectionView.reloadData()
        self.bonusCoinPackListTableView.reloadData()
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
        
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignupOTPViewController") as? SignupOTPViewController
        
        self.navigationController?.pushViewController(popupVC!, animated: true)
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = true
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginOTPViewController") as? LoginOTPViewController
        
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
    

    
    @IBAction func buyCoinButtonAction(_ sender: Any) {
        
        getPaymentChannel()
        
        confirmationView.isHidden = true
        

    }
    
    func getPaymentChannel(){
        
        var lang = ""
        if Language.language == Language.english{
            lang = "EN"
        }else{
            lang = "BN"
        }
        APIManager.manager.getPaymentChannelList(lang: lang) { (status, msg, channelList) in
            
            if status{
                
                self.channels = channelList
                
                self.paymentView.isHidden = false
                self.backShadeView.isHidden = false
                
                //remove all before inserting
                self.channelList.removeAll()
                
                for channel in self.channels{
                    
                    let name = channel.english_name!
                    let channelName = channel.channel_name!
                    let icon = channel.icon!
                    let maxPay = channel.max_pay_amount!
                    let minPay = channel.min_pay_amount!
                    
                    let tkAmount = (self.payAmountLabel.text! as NSString).intValue
                    let payAmount = tkAmount/50
                    print("method.min amount payAmount.....", payAmount)
                   
//                    if payAmount >= minPay && payAmount <= maxPay{
//
//                        //add in methodlist
//                       // let new = Channels(name: name, channelName: channelName,max:maxPay ,min: minPay,icon: icon, selected: false)
//                        let new = Channels(name: name, channelName: channelName,max:maxPay ,min: minPay, selected: false)
//
//
//                        self.channelList.append(new)
//
//                    }else{
                        
                        //add in methodlist
                        let new = Channels(name: name, channelName: channelName,max:maxPay ,min: minPay,icon: icon ?? "", selected: false)
                        
                        self.channelList.append(new)


                 //   }

                }
                
                print("self.channelList.count....", self.channelList.count)
                
                self.paymentChannelTableView.reloadData()
                
                // set view height based on tableview height
                self.paymentViewHeight.constant = self.paymentChannelTableView.contentSize.height + 180
                
                
                
                
                self.paymentView.frame = CGRect(x: 0, y:self.view.frame.height, width: self.paymentView.frame.width, height: self.paymentView.frame.height)
                
                let bottonSpace = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 1.0
                
                
                UIView.animate(withDuration:0.2, animations: {
                    
                    
                    self.paymentView.frame = CGRect(x: 0, y:self.view.frame.height - self.paymentView.frame.height - bottonSpace, width: self.paymentView.frame.width, height: self.paymentView.frame.height)
                    
                }) { _ in
                    
                    
                }
                
                
            }else{
                
                print("no channel.......")
                
                let alertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                   // self.GoBack()
                    
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
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
            
            var tkAmount = (payAmountLabel.text! as NSString).floatValue
            
            var payAmount = (tkAmount/50).rounded(.up)
            
            print("payNowButtonAction.........payAmount",payAmount)
            
            if payAmount < 10{

                payAmount = 10
            }
            
            if selectedChannelType != "None"{
            
                APIManager.manager.getInvoice(amount: payAmount,type:selectedChannelType) { (status, id,url,msg) in
                    
                    print("getInvoice msg",msg!)
                    
                    if status{
                        self.view.makeToast(msg!)
                        
                        print("getInvoice id",id ?? "??",url!)
                        
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BkashPaymentViewController") as? BkashPaymentViewController
                        
                        vc?.urlString = url!
                        vc?.selectedContestId = self.selectedContest!.id!
                        if UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                        vc?.createdTeamList = self.createdTeamList
                        }else{
                            vc?.createdFootballTeamList = self.createdTeamListFootball
                        }
                        vc?.isFromDipositCoin = "no"
                        
                        //for Mixpanel
                        
                        let amount = String(tkAmount)
                        vc?.rechargAmount = amount
                        vc?.selectedChannelType = self.selectedChannelType
                        vc?.isCoinPack = "no"
                        
                        
                        self.navigationController?.pushViewController(vc!, animated: true)
                        
                    }
                    else{
                        self.view.makeToast(msg!)
                    }
                    
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
        
        print("paymentSuccessful..contest list")
        
        if let contestId = notification.userInfo?["contestId"] as? Int {
            
            if UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                
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

            }else{
                
                if let teams = notification.userInfo?["teams"] as? [CreatedTeamFootball] {
                    
                    let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectViewController") as? TeamSelectViewController
                    
                    popupVC?.modalPresentationStyle = .overCurrentContext
                    popupVC?.modalTransitionStyle = .crossDissolve
                    popupVC?.teamsFootball = teams
                    popupVC?.contestId = contestId
                    popupVC?.delegate = self
                    
                    self.present(popupVC!, animated: true) {
                        
                        
                    }
                    
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
    
    @objc func paymentSuccessfulMaxPanel(_ notification: NSNotification) {
        
        if let channel = notification.userInfo?["channel"] as? String {
            
            if let isCoinPack = notification.userInfo?["isCoinPack"] as? String {
                
                if let amount = notification.userInfo?["amount"] as? String {
                    
                    let p: Properties = ["channel": channel,
                                         "isCoinPack": isCoinPack,
                                         "amount": amount]
                    
                    Mixpanel.mainInstance().track(event: "coin_purchase_done", properties: p)//

                    
                }
                
            }
            
        }

        
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
