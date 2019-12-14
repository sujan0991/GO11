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
    
    @IBOutlet weak var freeContestLabel: UILabel!
    
    @IBOutlet weak var accountInfoLabel: UILabel!
    
    @IBOutlet weak var depositedCoinLabel: UILabel!
    @IBOutlet var depositedCoinCountLabel: UILabel!
    
    @IBOutlet weak var winningLabel: UILabel!
    @IBOutlet var winningAmountLabel: UILabel!
    
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet var pendingReqCountLabel: UILabel!
    
    @IBOutlet var addCoinButton: UIButton!
    @IBOutlet var withdrawButton: UIButton!
    @IBOutlet var redeemButton: UIButton!
    @IBOutlet weak var referButton: UIButton!
    
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
            
            self.navigationController?.pushViewController(popupVC ?? self, animated: true)
        }
        
//        placeNavBar(withTitle: "My Profile", isBackBtnVisible: false)

        addCoinButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#30B847")
        withdrawButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#30B847")
        redeemButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#30B847")
        
        imagePicker.delegate = self
        
        blockMessageLabel.text = "Your Profile Is Blocked!".localized
        suggestionTextView.text = "Your profile has been blocked! To know about reason of blocking or to resolve the matter please message to our facebook page https://www.facebook.com/gameof11/ . GO11 support team will guide you for further procedure.".localized
       // freeContestLabel.text = "Your available free contests = 0"
        accountInfoLabel.text = "Account Info".localized
        depositedCoinLabel.text = "Deposited Coins".localized
        winningLabel.text = "Winning Amount".localized
        pendingLabel.text = "Pending Withdraw".localized
        
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
    
        personalDetailLabel.text = "Personal Details".localized
        
        fullProfileButton.setTitle("Full Profile".localized, for: .normal)
        verifyButton.setTitle("Verify Your Profile!".localized, for: .normal)
        logoutButton.setTitle("Logout".localized, for: .normal)
        
        self.topView.layer.applySketchShadow(
            color: UIColor.lightGray,
            alpha: 1.0,
            x: 0,
            y: 2,
            blur: 4,
            spread: 0)
        self.accountInfoView.layer.applySketchShadow(
            color: UIColor.lightGray,
            alpha: 1.0,
            x: 0,
            y: 2,
            blur: 4,
            spread: 0)

        self.historyView.layer.applySketchShadow(
            color: UIColor.lightGray,
            alpha: 1.0,
            x: 0,
            y: 2,
            blur: 4,
            spread: 0)

    
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
        
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        shadowView.isHidden = false
        blockSuggestionView.isHidden = false
       
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
    @objc private func refreshData(_ sender: Any) {
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
               
       
        getData()
        
    }
    
    func getData(){
    
        if AppSessionManager.shared.authToken != nil{
            
            self.scrollView.isHidden = false
            
            APIManager.manager.getMyProfile { (status, um, msg) in
                if status{
                    if let u = um{
                        AppSessionManager.shared.currentUser = u
                        AppSessionManager.shared.save()
                        // self.fill(u)
                        
                        if let um = AppSessionManager.shared.currentUser {
                            
                            if um.isBlocked == 1{
                                
                                self.blockView.isHidden = false
                                self.blockViewHeight.constant = 40
                                
                            }else{
                                
                                self.blockView.isHidden = true
                                self.blockViewHeight.constant = 0

                            }
                            
                            self.phoneNoLabel.text = String.init(format: "%@", um.phone ?? "")
                            self.userNameLabel.text = String.init(format: "%@", um.name ?? "")
                            self.emailLabel.text = String.init(format: "%@", um.email ?? "")
                            
                            if Language.language == Language.english{
                                
                                self.depositedCoinCountLabel.text = String.init(format: "%d", um.metadata?.totalCoins ?? "")
                                self.winningAmountLabel.text = String.init(format: "%.2f", um.metadata?.totalCash ?? "")
                                self.pendingReqCountLabel.text = String.init(format: "%d", um.metadata?.totalPendingRequest ?? "")
                                
                                self.contestCountLabel.text = String.init(format: "%d", um.metadata?.totalContestParticipation ?? "")
                                self.topRankCountLabel.text = String.init(format: "%d", um.metadata?.highestRank ?? "")
                                self.matchCountLabel.text = String.init(format: "%d", um.metadata?.totalMatchParticipation ?? "")
                                
                                self.contestCountFootballLabel.text = String.init(format: "%d", um.metadata?.totalFootballContestParticipation ?? "")
                                self.topRankCountFootballLabel.text = String.init(format: "%d", um.metadata?.highestFootballRank ?? "")
                                self.matchCountFootbaLabel.text = String.init(format: "%d", um.metadata?.totalFootballMatchParticipation ?? "")
                                
                                self.freeContestLabel.text = String.init(format: "Your available free contests = %d", um.metadata?.referral_contest_unlocked ?? 0)
                            }else{
                                
                                self.depositedCoinCountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalCoins as NSNumber? ?? 0)!)
                                self.winningAmountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalCash as NSNumber? ?? 0)!)
                                self.pendingReqCountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalPendingRequest as NSNumber? ?? 0)!)
                                
                                self.contestCountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalContestParticipation as NSNumber? ?? 0)!)
                                self.topRankCountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.highestRank as NSNumber? ?? 0)!)
                                self.matchCountLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalMatchParticipation as NSNumber? ?? 0)!)
                                
                                self.contestCountFootballLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalFootballContestParticipation as NSNumber? ?? 0)!)
                                self.topRankCountFootballLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.highestFootballRank as NSNumber? ?? 0)!)
                                self.matchCountFootbaLabel.text = String.init(format: "%@", self.formatter.string(from: um.metadata?.totalFootballMatchParticipation as NSNumber? ?? 0)!)
                                
                                self.freeContestLabel.text = String.init(format: "আপনার অব্যবহৃত ফ্রি কন্টেস্ট = %@", self.formatter.string(from: um.metadata?.referral_contest_unlocked as NSNumber? ?? 0)!)
                                
                            }
                            

                            
                            if um.avatar != nil{
                                
                                let url = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(um.avatar?.imagePath ?? "")")
                                
                                self.profilePicImageView.kf.setImage(with: url)
                            }
                            
                            if um.isVerified == 1{
                                
                                self.verifyButton.setTitle("Verified Profile".localized, for: .normal)
                                self.verifyButton.setTitleColor(UIColor.init(named: "GreenHighlight")!, for: .normal)
                                self.verifyButton.isUserInteractionEnabled = false
                                self.verifyInfoButton.isUserInteractionEnabled = false
                                self.verifyInfoButton.setImage(UIImage(named: "selected_thick"), for: .normal)
                                
                            }else if um.isVerified == 2{
                                
                                self.verifyButton.setTitle("Profile Verification Pending!".localized, for: .normal)
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
            self.scrollView.isHidden = true
            
            self.performSegue(withIdentifier: "openSignUp", sender: self)
        }
        
        self.refreshControl.endRefreshing()
        
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        //getAvatarList
        APIManager.manager.getAvatarList { (avatars) in
           print(avatars)
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AvaterViewController") as? AvaterViewController
            vc?.avatars = avatars
            vc?.currentAvaterId = AppSessionManager.shared.currentUser?.avatarId
            
            self.present(vc!, animated: true) {
                
                print("open")
            }
        }
//
//        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
//            self.openCamera()
//        }))
//
//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//            self.openGallary()
//        }))
//
//        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
//
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = sender
//            alert.popoverPresentationController?.sourceRect = sender.bounds
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
//
//        self.present(alert, animated: true, completion: nil)
    
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
    
    
    //DepositCoinViewController
    @IBAction func addCoinButtonAction(_ sender: Any) {
        
     if AppSessionManager.shared.currentUser?.isBlocked != 1{
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DepositCoinViewController") as? DepositCoinViewController
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
        
        
    }
    
    @IBAction func withdrawButtonAction(_ sender: Any) {
        
    print("........................",AppSessionManager.shared.currentUser!.minWithdrawLimit)
      if AppSessionManager.shared.currentUser?.isBlocked != 1{
        if AppSessionManager.shared.currentUser?.isVerified == 1{
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WithdrawRequestViewController") as? WithdrawRequestViewController
            
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }else if AppSessionManager.shared.currentUser!.metadata!.totalCash! < AppSessionManager.shared.currentUser!.minWithdrawLimit ?? 250 {
            
            self.view.makeToast("You do not have enough money to withdraw.".localized)
            
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
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyAccountViewController") as? VerifyAccountViewController
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func referToFriendButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReferalViewController") as? ReferalViewController
       
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func pendingWithdrawButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PendingWithdrawViewController") as? PendingWithdrawViewController
        

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
        
        APIManager.manager.logOut { (status, msg) in
            
            AppSessionManager.shared.logOut()
            if status{
               // SVProgressHUD.showSuccess(withStatus: msg)
                self.view.makeToast( msg!)
 
            }
            else{
                self.view.makeToast("Something went wrong! Please try again".localized)
                
                //SVProgressHUD.showError(withStatus: msg)
            }
            
        }
    }
    
    //image picker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            self.profilePicImageView.image = image
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

