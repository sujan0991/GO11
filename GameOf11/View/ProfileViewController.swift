//
//  ProfileViewController.swift
//  DropDown
//
//  Created by MacBook Pro Retina on 2/17/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit
import SVProgressHUD
import SafariServices
import Mixpanel

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var accountInfoView: UIView!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var blockMessageLabel: UILabel!
    @IBOutlet weak var blockViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var blockSuggestionView: UIView!
    @IBOutlet weak var suggestionTextView: UITextView!
    
    
    @IBOutlet var profilePicImageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var freeContestLabel: UILabel!
    
    @IBOutlet weak var accountInfoLabel: UILabel!
    
    @IBOutlet weak var depositedCoinLabel: UILabel!
    @IBOutlet var depositedCoinCountLabel: UILabel!
    
    @IBOutlet weak var bonusCoinLabel: UILabel!
    @IBOutlet weak var bonusCoinCountLabel: UILabel!
    
    @IBOutlet weak var winningLabel: UILabel!
    @IBOutlet var winningAmountLabel: UILabel!
    
    
    @IBOutlet var addCoinButton: UIButton!
    @IBOutlet var withdrawButton: UIButton!
    @IBOutlet var redeemButton: UIButton!
    @IBOutlet weak var referButton: UIButton!
    
    @IBOutlet weak var coinLogButton: UIButton!
    
    @IBOutlet weak var playingHistoryLabel: UILabel!
    
    @IBOutlet weak var contestLabel: UILabel!
    @IBOutlet var contestCountLabel: UILabel!
    
    @IBOutlet weak var topRanklabel: UILabel!
    @IBOutlet var topRankCountLabel: UILabel!
    
    
    @IBOutlet weak var matchlabel: UILabel!
    @IBOutlet var matchCountLabel: UILabel!
    
    @IBOutlet weak var contestFootballLabel: UILabel!
    @IBOutlet var contestCountFootballLabel: UILabel!
    
    @IBOutlet weak var topRankFootballlabel: UILabel!
    @IBOutlet var topRankCountFootballLabel: UILabel!
    
    
    @IBOutlet weak var matchFootballlabel: UILabel!
    @IBOutlet var matchCountFootbaLabel: UILabel!
    
    
    @IBOutlet weak var personalDetailLabel: UILabel!
    @IBOutlet weak var fullProfileButton: UIButton!
    
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var verifyInfoButton: UIButton!
    
    @IBOutlet weak var gameTypeImageView: UIImageView!
    
    @IBOutlet weak var verificationCancelReasonButton: UIButton!
    
    @IBOutlet weak var cancelReasonPopupView: UIView!
    
    @IBOutlet weak var cancelReasonLabel: UILabel!
    
    
    @IBOutlet weak var progressBarNIB: BRCircularProgressView!
    
    @IBOutlet weak var profileUpdateInfoView: UIView!
    
    @IBOutlet weak var updateInfoBackgroundImageView: UIImageView!
    @IBOutlet weak var updateInfoViewCoinLabel: UILabel!
    @IBOutlet weak var updateInfoViewCoinDetailLabel: UILabel!
    @IBOutlet weak var updateInfoFullNameButton: UIButton!
    @IBOutlet weak var updateInfoFullNameLabel: UILabel!
    @IBOutlet weak var updateInfoEmailButton: UIButton!
    
    @IBOutlet weak var updateInfoEmailLabel: UILabel!
    
    @IBOutlet weak var updateInfoPhoneButton: UIButton!
    
    @IBOutlet weak var updateInfoPhoneLabel: UILabel!
    
    @IBOutlet weak var updateInfoVerifyProfileButton: UIButton!
    @IBOutlet weak var updateInfoVerifyProfileLabel: UILabel!
    
    @IBOutlet weak var updateInfoProficePicButton: UIButton!
    @IBOutlet weak var updateInfoProfilePicLabel: UILabel!
    @IBOutlet weak var updateInfoGenderButton: UIButton!
    @IBOutlet weak var updateInfoGenderLabel: UILabel!
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var profileUpdatePercentButton: UIButton!
    @IBOutlet weak var profileCompleteLabel: UILabel!
    
    
    @IBOutlet weak var updateUserNameView: UIView!
    
    @IBOutlet weak var updateUserNameLabel: UILabel!
    
    @IBOutlet weak var updateUserNameInstructionLabel: UILabel!
    @IBOutlet weak var updateUsernameTextField: UITextField!
    @IBOutlet weak var updateUsernameButton: UIButton!
    
    
    
    @IBOutlet weak var historyScrollView: UIScrollView!{
        didSet{
            historyScrollView.delegate = self
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet var phoneNoLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    let formatter = NumberFormatter()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.height/2
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        suggestionTextView.isEditable = false;
        suggestionTextView.dataDetectorTypes = UIDataDetectorTypes.all;
        
        self.scrollView.isHidden = true
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.paymentSuccessful(_:)), name: NSNotification.Name(rawValue: "paymentFromProfile"), object: nil)
        
        
        
        if AppSessionManager.shared.authToken == nil{
            
            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UnSignedProfileViewController") as? UnSignedProfileViewController
            
            SVProgressHUD.dismiss()
            
            print("view did load - authToken == nil")
            self.navigationController?.pushViewController(popupVC ?? self, animated: true)
        }
        
        //        placeNavBar(withTitle: "My Profile", isBackBtnVisible: false)
        //buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        addCoinButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        withdrawButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        redeemButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        //   coinLogButton.buttonRound(0, borderWidth: 0.0, borderColor: UIColor.init(named: "brand_red")!)
        fullProfileButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        
        imagePicker.delegate = self
        
        blockMessageLabel.text = "Your Profile Is Blocked!".localized
        suggestionTextView.text = "Your profile has been blocked! To know about reason of blocking or to resolve the matter please message to our facebook page https://www.facebook.com/gameof11/ . GO11 support team will guide you for further procedure.".localized
        // freeContestLabel.text = "Your available free contests = 0"
        //accountInfoLabel.text = "Account Info".localized
        depositedCoinLabel.text = "Deposited Coins".localized
        winningLabel.text = "Winning Amount".localized
        
        addCoinButton.setTitle("ADD COINS".localized, for: .normal)
        withdrawButton.setTitle("WITHDRAW PRIZE".localized, for: .normal)
        redeemButton.setTitle("REDEEM COINS".localized, for: .normal)
        referButton.setTitle("REFER TO A FRIEND".localized, for: .normal)
        
        playingHistoryLabel.text = "Playing History".localized
        contestLabel.text = "Contests".localized
        topRanklabel.text = "Top Rank".localized
        matchlabel.text = "Matches".localized
        
        contestFootballLabel.text = "Contests".localized
        topRankFootballlabel.text = "Top Rank".localized
        matchFootballlabel.text = "Matches".localized
        
        //personalDetailLabel.text = "Personal Details".localized
        
        fullProfileButton.setTitle("Full Profile".localized, for: .normal)
        verifyButton.setTitle("Verify Your Profile!".localized, for: .normal)
        logoutButton.setTitle("Logout".localized, for: .normal)
       // coinLogButton.setTitle("COINS LOG".localized, for: .normal)
        
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapContestLabel))
        contestLabel.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapFootballContestLabel))
        contestFootballLabel.addGestureRecognizer(tap1)
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        let blocktap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blockView.addGestureRecognizer(blocktap)
        
        self.blockView.isHidden = true
        self.blockViewHeight.constant = 0
        
        
        
        historyScrollView.contentSize = CGSize(width: view.frame.width * 2.0, height: historyScrollView.frame.height)
        
        pageControl.currentPage = 0
        
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.closeShadowView(_:)))
        shadowView.addGestureRecognizer(tap2)
        
        updateInfoBackgroundImageView.layer.cornerRadius = 15
        
        let userNameTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.userNameEdit))
        userNameLabel.addGestureRecognizer(userNameTap)
        
        // set font sizr based on screen wodth
        if (self.view.frame.width == 320) {

            phoneNoLabel.font = UIFont(name: "OpenSans", size: 9)
            emailLabel.font = UIFont(name: "OpenSans", size: 9)
            depositedCoinLabel.font = UIFont(name: "OpenSans", size: 9)
            depositedCoinCountLabel.font = UIFont(name: "OpenSans-Bold", size: 9)
            bonusCoinLabel.font = UIFont(name: "OpenSans", size: 9)
            bonusCoinCountLabel.font = UIFont(name: "OpenSans-Bold", size: 9)
            

        } else if (self.view.frame.width == 375 || self.view.frame.width == 390 ) {

            phoneNoLabel.font = UIFont(name: "OpenSans", size: 11)
            emailLabel.font = UIFont(name: "OpenSans", size: 11)
            depositedCoinLabel.font = UIFont(name: "OpenSans", size: 11)
            depositedCoinCountLabel.font = UIFont(name: "OpenSans-Bold", size: 11)
            bonusCoinLabel.font = UIFont(name: "OpenSans", size: 11)
            bonusCoinCountLabel.font = UIFont(name: "OpenSans-Bold", size: 11)
            

        } else if (self.view.frame.width >= 414) {

            phoneNoLabel.font = UIFont(name: "OpenSans", size: 12)
            emailLabel.font = UIFont(name: "OpenSans", size: 12)
            depositedCoinLabel.font = UIFont(name: "OpenSans", size: 12)
            depositedCoinCountLabel.font = UIFont(name: "OpenSans-Bold", size: 12)
            bonusCoinLabel.font = UIFont(name: "OpenSans", size: 12)
            bonusCoinCountLabel.font = UIFont(name: "OpenSans-Bold", size: 12)
            

        }
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        shadowView.isHidden = false
        blockSuggestionView.isHidden = false
        
    }
    @objc func closeShadowView(_ sender: UITapGestureRecognizer? = nil) {
        
        shadowView.isHidden = true
        profileUpdateInfoView.isHidden = true
        updateUserNameView.isHidden = true
        
    }
    
    
    @objc func tapContestLabel(sender:UITapGestureRecognizer) {
        
        UserDefaults.standard.set("completed", forKey: "selectedMyContest")
        UserDefaults.standard.set("cricket", forKey: "selectedGameType")
        
        self.tabBarController?.selectedIndex = 1
        
    }
    @objc func tapFootballContestLabel(sender:UITapGestureRecognizer) {
        
        UserDefaults.standard.set("completed", forKey: "selectedMyContest")
        UserDefaults.standard.set("football", forKey: "selectedGameType")
        
        self.tabBarController?.selectedIndex = 1
        
    }
    
    @objc func userNameEdit(sender:UITapGestureRecognizer) {
        if let um = AppSessionManager.shared.currentUser {
            
            if um.is_username_updated == 1{
                
                self.view.makeToast("You already updated your user name")
                
            }else{
                
                shadowView.isHidden = false
                updateUserNameView.isHidden = false
                
            }
        }
        
       
    }
    
    @objc private func refreshData(_ sender: Any) {
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        if UserDefaults.standard.bool(forKey: "DarkMode"){
        //
        //        }else{
        //                    self.topView.layer.applySketchShadow(
        //                        color: .lightGray,
        //                        alpha: 1.0,
        //                        x: 0,
        //                        y: 2,
        //                        blur: 4,
        //                        spread: 0)
        //                    self.accountInfoView.layer.applySketchShadow(
        //                        color: .lightGray,
        //                        alpha: 1.0,
        //                        x: 0,
        //                        y: 2,
        //                        blur: 4,
        //                        spread: 0)
        //
        //                    self.historyView.layer.applySketchShadow(
        //                        color: .lightGray,
        //                        alpha: 1.0,
        //                        x: 0,
        //                        y: 2,
        //                        blur: 4,
        //                        spread: 0)
        //
        //        }
        
        
        progressBarNIB.setCircleStrokeWidth(3)
        
        progressBarNIB.setCircleStrokeColor(UIColor.clear, circleFillColor: UIColor.clear, progressCircleStrokeColor: UIColor.systemGreen, progressCircleFillColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.0))
        
        //        let completeProgress: CGFloat = 100
        //        var progressCompleted: CGFloat = 0
        //        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
        //            progressCompleted += 1
        //            self.progressBarNIB.progress = progressCompleted / completeProgress
        //            print("progressBarNIB.progress",self.progressBarNIB.progress)
        //            if progressCompleted == 100 {
        //               progressCompleted = 0
        //            }
        //        }
        
        
        self.tabBarController?.tabBar.isHidden = false
        
        if #available(iOS 13, *) {
            if UserDefaults.standard.bool(forKey: "DarkMode"){
                
                overrideUserInterfaceStyle = .dark
                self.tabBarController?.tabBar.backgroundColor = UIColor.init(named: "tab_dark_bg")
                self.tabBarController?.tabBar.unselectedItemTintColor = .white
                
            }else{
                overrideUserInterfaceStyle = .light
                self.tabBarController?.tabBar.backgroundColor = .white
                self.tabBarController?.tabBar.unselectedItemTintColor = .gray
                
            }
            
        }else{
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        getData()
        
        
    }
    
    func getData(){
        
        print("getData.............")
        if AppSessionManager.shared.authToken != nil{
            
            self.scrollView.isHidden = false
            
            APIManager.manager.getMyProfile { (status, um, msg) in
                if status{
                    if let u = um{
                        AppSessionManager.shared.currentUser = u
                        AppSessionManager.shared.save()
                        // self.fill(u)
                        
                        
                        //set mixpanel profile
                        
                        print("pnone//////.............",um?.phone ?? "0")
                        
                        Mixpanel.mainInstance().identify(distinctId: um?.phone ?? "0")
                        
                        let p: Properties = ["Phone": um?.phone ?? "",
                                             "Name": um?.name ?? "",
                                             "Email": um?.email ?? "",
                                             "Address": um?.address ?? "",
                                             "Created_At": um?.created_at ?? ""]
                        
                        Mixpanel.mainInstance().people.set(properties: p)
                        //BD5CD4C4-63FD-4D85-93E1-9A167CC23953
                        
                        
                        if let um = AppSessionManager.shared.currentUser {
                            
                            // print("um.paymentMethod?.ghoori",um.paymentMethod?.ghoori ?? 2)
                            
                            if um.isBlocked == 1{
                                
                                self.blockView.isHidden = false
                                self.blockViewHeight.constant = 40
                                
                            }else{
                                
                                self.blockView.isHidden = true
                                self.blockViewHeight.constant = 0
                                
                            }
                            
                            
                            self.phoneNoLabel.text = String.init(format: "%@", um.phone ?? "")
                            self.updateInfoPhoneButton.isSelected = true // phone number will always be there
                            self.updateInfoPhoneLabel.text = String.init(format: "%@", um.phone ?? "")
                            
                            if um.name != nil  && !(um.name?.isEmpty ?? true){
                                print("if........name")
                                self.fullNameLabel.text = String.init(format: "%@", um.name ?? "")
                                self.updateInfoFullNameLabel.text = String.init(format: "%@", um.name ?? "")
                                self.updateInfoFullNameButton.isSelected = true
                                
                            }else{
                                print("else........name")
                                self.fullNameLabel.text = "Update Name"
                                self.updateInfoFullNameLabel.text = "Full Name"
                                self.updateInfoFullNameButton.isSelected = false
                            }
                            
                            if um.email != nil && !(um.email?.isEmpty ?? true){
                                print("if........email")
                                self.emailLabel.text = String.init(format: "%@", um.email ?? "")
                                self.updateInfoEmailLabel.text = String.init(format: "%@", um.email ?? "")
                                self.updateInfoEmailButton.isSelected = true
                            }else{
                                print("else........email")
                                self.emailLabel.text = "Update Email Address"
                                self.updateInfoEmailLabel.text = "Email"
                                self.updateInfoEmailButton.isSelected = false
                            }
                            
                            if um.sex != nil{
                                
                                self.updateInfoGenderLabel.text = String.init(format: "%@", um.sex ?? "")
                                self.updateInfoGenderButton.isSelected = true
                            }else{
                                self.updateInfoGenderLabel.text = "Update Gender"
                                self.updateInfoGenderButton.isSelected = false
                                
                            }
                            
                            
                            if um.profile_completion_bonus != nil{
                                
                                self.updateInfoViewCoinLabel.text = String.init(format: "Get %d coins !!!", um.profile_completion_bonus ?? "")
                                self.updateInfoViewCoinDetailLabel.text = String.init(format: "Complete your profile and get %d coins right now. Lets play!", um.profile_completion_bonus ?? "")
                                
                            }else{
                                
                                self.updateInfoViewCoinLabel.text = ""
                                self.updateInfoViewCoinDetailLabel.text = ""
                                
                            }
                            
                            
                            
                            if um.is_username_updated == 1{
                                self.userNameLabel.text = String.init(format: "@%@", um.username ?? "")
                                
                            }else{
                                
                                if um.username != nil{
                                    self.userNameLabel.text = String.init(format: "@%@", um.username ?? "")
                                    self.userNameLabel.isUserInteractionEnabled = true
                                }else{
                                    self.userNameLabel.text = "@username"
                                    self.userNameLabel.isUserInteractionEnabled = true
                                }
                                
                            }
                            
                            
                            
                            // profile completion info
                            self.percentageLabel.text = String.init(format: "%@%%", um.profile_completion_percentage ?? "")
                            let progress = Float(um.profile_completion_percentage ?? "0") ?? 0
                            print("progress........",progress)
                            self.progressBarNIB.progress = CGFloat(progress/100)
                            
                            
                            
                            
                            if Language.language == Language.english{
                                
                                self.depositedCoinCountLabel.text = String.init(format: "%d", um.metadata?.totalCoins ?? "")
                                self.winningAmountLabel.text = String.init(format: "%.2f", um.metadata?.totalCash ?? "")
                                //    self.pendingReqCountLabel.text = String.init(format: "%d", um.metadata?.totalPendingRequest ?? "")
                                
                                self.contestCountLabel.text = String.init(format: "%d", um.metadata?.totalContestParticipation ?? "")
                                self.topRankCountLabel.text = String.init(format: "%d", um.metadata?.highestRank ?? "")
                                self.matchCountLabel.text = String.init(format: "%d", um.metadata?.totalMatchParticipation ?? "")
                                
                                self.contestCountFootballLabel.text = String.init(format: "%d", um.metadata?.totalFootballContestParticipation ?? "")
                                self.topRankCountFootballLabel.text = String.init(format: "%d", um.metadata?.highestFootballRank ?? "")
                                self.matchCountFootbaLabel.text = String.init(format: "%d", um.metadata?.totalFootballMatchParticipation ?? "")
                                
                               // self.freeContestLabel.text = String.init(format: "Your available free contests = %d", um.metadata?.referral_contest_unlocked ?? 0)
                            }else{
                                
                                self.depositedCoinCountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalCoins as NSNumber? ?? 0)!)
                                self.winningAmountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalCash as NSNumber? ?? 0)!)
                                
                                
                                self.contestCountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalContestParticipation as NSNumber? ?? 0)!)
                                self.topRankCountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.highestRank as NSNumber? ?? 0)!)
                                self.matchCountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalMatchParticipation as NSNumber? ?? 0)!)
                                
                                self.contestCountFootballLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalFootballContestParticipation as NSNumber? ?? 0)!)
                                self.topRankCountFootballLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.highestFootballRank as NSNumber? ?? 0)!)
                                self.matchCountFootbaLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalFootballMatchParticipation as NSNumber? ?? 0)!)
                                
                               // self.freeContestLabel.text = String.init(format: "আপনার অব্যবহৃত ফ্রি কন্টেস্ট = %@", self.formatter.string(from: um.metadata?.referral_contest_unlocked as NSNumber? ?? 0)!)
                                
                            }
                            
                            if um.profile_picture != nil{
                                
                                let url = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(um.profile_picture ?? "")")
                                
                                self.profilePicImageView.kf.setImage(with: url)
                                
                                self.updateInfoProfilePicLabel.text = "Profile Picture Updated"
                                self.updateInfoProficePicButton.isSelected = true
                                
                            }else{
                                if um.avatar != nil{
                                    
                                    let url = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(um.avatar?.imagePath ?? "")")
                                    
                                    self.profilePicImageView.kf.setImage(with: url)
                                }
                                self.updateInfoProfilePicLabel.text = "Updated Profile Picture"
                                self.updateInfoProficePicButton.isSelected = false

                                
                            }
                            
                            
                            if um.isVerified == 1{
                                
                                self.verifyButton.setTitle("Verified Profile".localized, for: .normal)
                                self.verifyButton.setTitleColor(UIColor.init(named: "on_green")!, for: .normal)
                                self.verifyButton.isUserInteractionEnabled = false
                                self.verifyInfoButton.isUserInteractionEnabled = false
                                self.verifyInfoButton.setImage(UIImage(named: "selected_thick"), for: .normal)
                                
                                self.updateInfoVerifyProfileLabel.text = "Verified Profile"
                                self.updateInfoVerifyProfileButton.isSelected = true
                                
                            }else if um.isVerified == 2{
                                
                                self.verifyButton.setTitle("Profile Verification Pending!".localized, for: .normal)
                                
                                self.updateInfoVerifyProfileLabel.text = "Verify Profile"
                                self.updateInfoVerifyProfileButton.isSelected = false
                                
                            }else{
                                
                                self.updateInfoVerifyProfileLabel.text = "Verify Profile"
                                self.updateInfoVerifyProfileButton.isSelected = false
                                
                                if um.metadata?.verification_cancel_reason != nil{
                                    self.verificationCancelReasonButton.isHidden = false
                                }
                            }
                            
                        }
                        else
                        {
                            
                        }
                    }
                }
                else{
                    
                    self.view.makeToast(msg!)
                    
                }
            }
            
            
            
        }
        else
        {
            //            self.scrollView.isHidden = true
            //
            //            self.performSegue(withIdentifier: "openSignUp", sender: self)
            
            print("get data-authToken == nil ")
        }
        
        self.refreshControl.endRefreshing()
        
    }
    
    @IBAction func profileUpdatePercentButtonAction(_ sender: Any) {
        
        shadowView.isHidden = false
        profileUpdateInfoView.isHidden = false
    }
    
    @IBAction func updateUserNameButtonAction(_ sender: Any) {
        
        var params:[String:String] = [:]
        if updateUsernameTextField.text!.count > 0{
            
            updateUsernameTextField.resignFirstResponder()
            
            params = ["username":updateUsernameTextField.text!]
            
            APIManager.manager.updateProfile(params: params) { (status, msg) in
                
                if status{
                    
                    self.view.makeToast(msg!)
                    self.userNameLabel.text = self.updateUsernameTextField.text
                    self.shadowView.isHidden = true
                    self.updateUserNameView.isHidden = true
                    
                    self.getData()
                }
                
            }
        }
        
        
    }
    
    
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        //getAvatarList
        //        APIManager.manager.getAvatarList { (avatars) in
        //            print(avatars)
        //
        //            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AvaterViewController") as? AvaterViewController
        //            vc?.avatars = avatars
        //            vc?.currentAvaterId = AppSessionManager.shared.currentUser?.avatarId
        //
        //            self.present(vc!, animated: true) {
        //
        //                print("open")
        //            }
        //        }
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func bonusCoinButtonAction(_ sender: Any) {
        
        print("bonus Coin ButtonAction")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BonusCoinViewController") as? BonusCoinViewController

        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    
    
    
    //DepositCoinViewController
    @IBAction func addCoinButtonAction(_ sender: Any) {
        
        if AppSessionManager.shared.currentUser?.isBlocked != 1{
            
            if let um = AppSessionManager.shared.currentUser {
                
                if um.email != nil && !(um.email?.isEmpty ?? true){
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DepositCoinViewController") as? DepositCoinViewController
                    
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                }else{
                    
                    self.view.makeToast("Please update your email address")
                    
                }
                
            }
            
        }
        
        
    }
    
    @IBAction func withdrawButtonAction(_ sender: Any) {
        
        
        if AppSessionManager.shared.currentUser?.isBlocked != 1{
            if AppSessionManager.shared.currentUser?.isVerified == 1{
                
                //                if AppSessionManager.shared.currentUser!.metadata!.totalCash! <= AppSessionManager.shared.currentUser!.minWithdrawLimit ?? 250 {
                //
                //                    self.view.makeToast("You do not have enough money to withdraw.".localized)
                //
                //                }else{
                
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WithdrawRequestViewController") as? WithdrawRequestViewController
                
                self.navigationController?.pushViewController(vc!, animated: true)
                //                }
                
            }
            else{
                
                self.view.makeToast("Please verify your profile first to withdraw your winnings".localized)
                
            }
        }
    }
    
    @IBAction func redeemButtonAction(_ sender: Any) {
        if AppSessionManager.shared.currentUser?.isBlocked != 1{
            if AppSessionManager.shared.currentUser!.metadata!.totalCash! <= 0  {
                
                self.view.makeToast("You do not have enough money to redeem".localized)
                
            }else{
                
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RedeemCoinViewController") as? RedeemCoinViewController
                
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    
    @IBAction func fullProfileButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func verifyButtonAction(_ sender: Any) {
        if let um = AppSessionManager.shared.currentUser {
            
            if um.name != nil && !(um.name?.isEmpty ?? true){
                
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyAccountViewController") as? VerifyAccountViewController
                
                
                self.navigationController?.pushViewController(vc!, animated: true)
                
                
            }else{
                
                self.view.makeToast("Please update your full name")
                
            }
            

        }
    }
    
    @IBAction func referToFriendButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReferalViewController") as? ReferalViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    
    @IBAction func freeContestInfoButtonAction(_ sender: Any) {
        
        let urlString = "https://gameof11.com/referral-system"
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
        
    }
    
    @IBAction func redeemInfoButtonAction(_ sender: Any) {
        
        let urlString = "https://gameof11.com/redeem-coin-and-withdraw-prize"
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
        
        
    }
    
    
    @IBAction func coinLogButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionViewController") as? TransactionViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    @IBAction func verifyAccountInfoButtonAction(_ sender: Any) {
        
        let urlString = "https://gameof11.com/verify-profile"
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
        
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        
        shadowView.isHidden = true
        blockSuggestionView.isHidden = true
        
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func verificationCancelReasonButtonAction(_ sender: Any) {
        
        if AppSessionManager.shared.currentUser?.metadata!.verification_cancel_reason != nil{
            
            cancelReasonLabel.text = AppSessionManager.shared.currentUser?.metadata!.verification_cancel_reason
        }
        shadowView.isHidden = false
        cancelReasonPopupView.isHidden = false
    }
    
    @IBAction func cancelReasonOkButtonAction(_ sender: Any) {
        
        shadowView.isHidden = true
        cancelReasonPopupView.isHidden = true
    }
    
    
    
    
    //image picker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            //resize
            
            //            ImageCompressor.compress(image: image!, maxByte: 100) { image in
            //
            //                guard let compressedImage = image else { return }
            //                // Use compressedImage
            //
            //            }
            
            let params = ["profile_pic":image!
            ] as [String : Any]
            
            APIManager.manager.postUploadProPic(params: params, withCompletionHandler: { (status, msg) in
                
                print("msg in post messege",msg!)
                if status{
                    
                    self.profilePicImageView.image = image
                    self.view.makeToast(msg!)
                    
                }else
                {
                    self.view.makeToast(msg!)
                    
                }
                
                
            })
            
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePicker.dismiss(animated: true) {
            
            
        }
    }
    
    
    @objc func paymentSuccessful(_ notification: NSNotification) {
        
        let alertVC = UIAlertController(title: nil, message: "Your payment to buy Coins was Successful.".localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (aciton) in
        })
        
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        
        //set coin_purchase_done event in mixpanel
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        if pageIndex == 0{
            gameTypeImageView.image = UIImage.init(named: "icon_cricket_placing")
        }else{
            gameTypeImageView.image = UIImage.init(named: "icon_football_placing")
        }
    }
    
    
}


//struct ImageCompressor {
//    static func compress(image: UIImage, maxByte: Int,
//                         completion: @escaping (UIImage?) -> ()) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            guard let currentImageSize = image.jpegData(compressionQuality: 1.0)?.count else {
//                return completion(nil)
//            }
//
//            var iterationImage: UIImage? = image
//            var iterationImageSize = currentImageSize
//            var iterationCompression: CGFloat = 1.0
//
//            while iterationImageSize > maxByte && iterationCompression > 0.01 {
//                let percantageDecrease = getPercantageToDecreaseTo(forDataCount: iterationImageSize)
//
//                let canvasSize = CGSize(width: image.size.width * iterationCompression,
//                                        height: image.size.height * iterationCompression)
//                UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
//                defer { UIGraphicsEndImageContext() }
//                image.draw(in: CGRect(origin: .zero, size: canvasSize))
//                iterationImage = UIGraphicsGetImageFromCurrentImageContext()
//
//                guard let newImageSize = iterationImage?.jpegData(compressionQuality: 1.0)?.count else {
//                    return completion(nil)
//                }
//                iterationImageSize = newImageSize
//                iterationCompression -= percantageDecrease
//            }
//            completion(iterationImage)
//        }
//    }
//
//    private static func getPercantageToDecreaseTo(forDataCount dataCount: Int) -> CGFloat {
//        switch dataCount {
//        case 0..<3000000: return 0.05
//        case 3000000..<10000000: return 0.1
//        default: return 0.2
//        }
//    }
//}
