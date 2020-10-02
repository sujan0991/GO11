//
//  HomeViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import DTPagerController


class HomeViewController: UIViewController,DTSegmentedControlProtocol,DTPagerControllerDelegate {
    
    var selectedSegmentIndex: Int = 0
    var popId: Int = 0
    
    //var containerView: UIView!
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var languageButton: UIButton!
    
    @IBOutlet weak var announcementCountLabel: UILabel!
    @IBOutlet weak var announcementButton: UIButton!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var popupCloseButton: UIButton!
    @IBOutlet weak var ruleView: UIView!
    @IBOutlet weak var newsLetterImage: UIImageView!
    
    @IBOutlet weak var newsLetterText: UILabel!
    @IBOutlet weak var newsLetterTitleText: UILabel!
    
    @IBOutlet weak var newsLetterButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var updatebutton: UIButton!
    @IBOutlet weak var updatemsgLabel: UILabel!
    
    @IBOutlet weak var languageShadowView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var banglabutton: UIButton!
    @IBOutlet weak var changeLanguageLabel: UILabel!
    
    
    var announcementArray:[Any] = []
    
    
    var newAnnouncementCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        
        //        placeNavBar(withTitle: "GAME OF 11", isBackBtnVisible: false,isLanguageBtnVisible: true, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: true, isCountLabelVisible: false)
        //
        //       placePagerContainer()
       
        newsLetterButton.setTitle("GOT IT".localized, for: .normal)
        updatemsgLabel.text = "New update is available.".localized
        skipButton.setTitle("SKIP".localized, for: .normal)
        updatebutton.setTitle("UPDATE".localized, for: .normal)
        announcementCountLabel.makeCircular(borderWidth: 1, borderColor: UIColor.white )
        
        if Language.language == Language.bangla{
            
            banglabutton.setTitleColor(UIColor.white, for: .normal)
            banglabutton.backgroundColor = UIColor.init(named: "on_green")!
            
            englishButton.backgroundColor = UIColor.white
            englishButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
        }else{
            banglabutton.backgroundColor = UIColor.white
            banglabutton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
            
            englishButton.backgroundColor = UIColor.init(named: "on_green")!
            englishButton.setTitleColor(UIColor.white, for: .normal)
            
        }

        //Localize
        changeLanguageLabel.text = "Change Language".localized
        
        englishButton.layer.borderWidth = 0.5
        englishButton.layer.borderColor = UIColor.lightGray.cgColor
        banglabutton.layer.borderWidth = 0.5
        banglabutton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let fixtureVC = storyboard.instantiateViewController(withIdentifier: "MatchViewController") as! MatchViewController
        fixtureVC.title = "Fixtures"
        fixtureVC.type = .next
        
        //        let liveVC = storyboard.instantiateViewController(withIdentifier: "MatchViewController") as! MatchViewController
        //        liveVC.title = "Live"
        //        liveVC.type = .live
        
        //
        //        let resultVC = storyboard.instantiateViewController(withIdentifier: "MatchViewController")as! MatchViewController
        //        resultVC.title = "Results"
        //        resultVC.type = .completed
        
        
        let pagerController = DTPagerController(viewControllers: [fixtureVC])
        customizeSegment(pagerController: pagerController)
        
        pagerController.delegate = self
        
        print("//////////////////////",containerView.frame)
        print("navView........",navView.frame)
        
        addChild(pagerController)
        pagerController.view.frame = containerView.bounds
        print(pagerController.view)
        containerView.addSubview(pagerController.view)
        pagerController.didMove(toParent: self)
        
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkVersion(_:)), name: NSNotification.Name(rawValue: "versionCheck"), object: nil)
        
        
        APIManager.manager.getAnnouncement { (announcementList) in
            
            self.newAnnouncementCount = 0
            
            if announcementList.isEmpty{
                
                
            }else{
                
                self.announcementArray = announcementList
                
                //                for singleAnnouncement in self.announcementArray{
                //
                //                    let temp = singleAnnouncement as! Dictionary<String,Any>
                //
                //                    let calendar = Calendar.current
                //                    let dateFormatter = DateFormatter()
                //                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                //                    let dateFromString :Date = dateFormatter.date(from: ((temp["created_at"]! as! String)))!
                //
                //                    if calendar.isDateInToday(dateFromString) {
                //
                //                        self.newAnnouncementCount = self.newAnnouncementCount + 1
                //                    }
                //                }
                //                print("newAnnouncementCount........",self.newAnnouncementCount)
                //
                //                let dataDict:[String: Int] = ["count": self.newAnnouncementCount]
                //                NotificationCenter.default.post(name: Notification.Name("newAnnouncement"), object: nil, userInfo: dataDict)
                //
                
                for announcement in self.announcementArray{
                    let temp = announcement as! Dictionary<String,Any>
                    if temp["type"] as! String == "popup" {
                        
                        print(UserDefaults.standard.value(forKey: "popupID") as? Int ?? 0 )
                        self.popId = temp["id"] as! Int
                        
                        if self.popId != UserDefaults.standard.value(forKey: "popupID") as? Int ?? 0
                        {
                            self.ruleView.isHidden = false
                            self.shadowView.isHidden = false
                            self.popupCloseButton.isHidden = false
                     
                            self.newsLetterTitleText.text = temp["title"] as? String ?? ""
                            self.newsLetterText.text = temp["description"] as? String ?? ""
                            
                            let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(temp["image_path"] ?? "")")
                            
                            self.newsLetterImage.kf.setImage(with: url1)
                            if url1 == nil{
                                self.newsLetterImage.image = UIImage.init(named: "")
                            }
                        }
                    }
                }
            }
        }
        
   
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        languageShadowView.addGestureRecognizer(tap)
    }
    

    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        languageShadowView.isHidden = true
        languageView.isHidden = true
    }
    
    
    
    @objc func checkVersion(_ notification: NSNotification) {
        
        let currentVersion = UserDefaults.standard.value(forKey: "currentVersionNumber") as! String
        
        print("currentVersion.............",currentVersion)
        let storeVersion = UserDefaults.standard.value(forKey: "storeVersionNumber") as! String
        
        if storeVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
            print("store version is newer")
            
            self.tabBarController?.tabBar.isHidden = true
            
            shadowView.isHidden = false
            alertView.isHidden = false
            self.view.bringSubviewToFront(shadowView)
            self.view.bringSubviewToFront(alertView)
            
            if UserDefaults.standard.integer(forKey: "shouldUpdate") == 1{
                
                skipButton.isHidden = true
                
            }else{
                
                skipButton.isHidden = false
            }
            
        }else{
            
            print("store version is same or lower")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("view will appear.....home")
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
        
        print("view did appear.....home")
        
         
    }
    
    
    func customizeSegment(pagerController: DTPagerController)
    {
        
        pagerController.preferredSegmentedControlHeight = 44
        //   pagerController.font = UIFont.systemFont(ofSize: 15)
        //   pagerController.selectedFont = UIFont.boldSystemFont(ofSize: 15)
        pagerController.textColor = UIColor.white
        pagerController.selectedTextColor = UIColor.white
        
        pagerController.perferredScrollIndicatorHeight = 2
        pagerController.scrollIndicator.layer.cornerRadius = pagerController.scrollIndicator.frame.height/2
        pagerController.scrollIndicator.backgroundColor = UIColor.init(named: "brand_orange")
        pagerController.pageSegmentedControl.backgroundColor = UIColor.init(named: "on_green")
        
    }
    func setImage(_ image: UIImage?, forSegmentAt segment: Int) {
        // Custom page control does not support
        
    }
    
    func setTitle(_ title: String?, forSegmentAt segment: Int) {
        // Custom page control does not support
        
        
    }
    func setTitleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State) {
        //
    }
    
    func pagerController(_ pagerController: DTPagerController, didChangeSelectedPageIndex index: Int) {
        
        print(index)
    }
    
    @IBAction func updatebuttonAction(_ sender: Any) {
        
        //https://apps.apple.com/us/app/gameof11/id1482806407?ls=1
        UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/gameof11/id1482806407?ls=1")!, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        shadowView.isHidden = true
        alertView.isHidden = true
    }
    
    @IBAction func languageButtonAction(_ sender: Any) {
        
        if let currentVC = UIApplication.topViewController() as? HomeViewController {
            
            languageShadowView.isHidden = false
            languageView.isHidden = false
            
        }
    }
    
    @IBAction func announcementButtonAction(_ sender: Any) {
        
        print("announcement button action...........")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnnouncementViewController") as? AnnouncementViewController
        
        vc?.announcementArray = announcementArray
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func englishButtonAction(_ sender: Any) {
        
        Language.language = Language.english
    }
    
    @IBAction func banglaButtonAction(_ sender: Any) {
        
        print("bangla.........")
        Language.language = Language.bangla
    }
    
    @IBAction func popupUpdate(_ sender: Any) {
        self.ruleView.isHidden = true
        self.shadowView.isHidden = true
        self.popupCloseButton.isHidden = true
        UserDefaults.standard.setValue(self.popId, forKey: "popupID")
    }
    @IBAction func dismissRuleView(_ sender: Any) {
        self.ruleView.isHidden = true
        self.shadowView.isHidden = true
        self.popupCloseButton.isHidden = true
    }
    
}
