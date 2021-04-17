//
//  MyContestViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit


class MyContestViewController: BaseViewController,DTSegmentedControlProtocol,DTPagerControllerDelegate {
    
    var selectedSegmentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("viewDidLoad in my contest")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("AppSessionManager.shared.authToken",AppSessionManager.shared.authToken)

            
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
        
        self.tabBarController?.tabBar.isHidden = false
        
        if AppSessionManager.shared.authToken == nil{
            
            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UnSignedProfileViewController") as? UnSignedProfileViewController
            
            self.navigationController?.pushViewController(popupVC ?? self, animated: true)
            
        }
        else
        {
            placeNavBar(withTitle: "MY CONTESTS".localized, isBackBtnVisible: false,isLanguageBtnVisible: false, isGameSelectBtnVisible: true,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
            
            // Do any additional setup after loading the view.
            
            placeContainer()
            
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let fixtureVC = storyboard.instantiateViewController(withIdentifier: "MatchViewController") as! MatchViewController
            fixtureVC.title = "Upcoming"
            fixtureVC.type = .upcomingContest
            
            let liveVC = storyboard.instantiateViewController(withIdentifier: "MatchViewController") as! MatchViewController
            liveVC.title = "Live"
            liveVC.type = .liveContest
            
            
            let resultVC = storyboard.instantiateViewController(withIdentifier: "MatchViewController")as! MatchViewController
            resultVC.title = "Completed"
            resultVC.type = .completedContest
            
            
            let pagerController = DTPagerController(viewControllers: [fixtureVC, liveVC,resultVC])
            customizeSegment(pagerController: pagerController)
            
            pagerController.delegate = self
            
            addChild(pagerController)
            pagerController.view.frame = containerView.bounds
            containerView.addSubview(pagerController.view)
            pagerController.didMove(toParent: self)
        }
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
        pagerController.scrollIndicator.backgroundColor = UIColor.init(named: "on_green")
        pagerController.pageSegmentedControl.backgroundColor = UIColor.init(named: "header_color")
        pagerController.view.backgroundColor = UIColor.init(named: "header_color")
        
        if UserDefaults.standard.object(forKey: "selectedMyContest") as? String == "upcoming"{
            
            pagerController.selectedPageIndex = 0
            
        }else if UserDefaults.standard.object(forKey: "selectedMyContest") as? String == "live"{
            
            pagerController.selectedPageIndex = 1
            
        }else if UserDefaults.standard.object(forKey: "selectedMyContest") as? String == "completed"{
            
            pagerController.selectedPageIndex = 2
        }
        
        
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
        
        print("didChangeSelectedPageIndex",index)
        
        if index == 0{
            
            UserDefaults.standard.set("upcoming", forKey: "selectedMyContest")
            
        }else if index == 1{
            
            UserDefaults.standard.set("live", forKey: "selectedMyContest")
            
        }else if index == 2{
            
            UserDefaults.standard.set("completed", forKey: "selectedMyContest")
            
        }
    }
    
    
}
