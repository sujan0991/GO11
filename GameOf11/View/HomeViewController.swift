//
//  HomeViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import DTPagerController


class HomeViewController: BaseViewController,DTSegmentedControlProtocol,DTPagerControllerDelegate {
    
    var selectedSegmentIndex: Int = 0
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var updatebutton: UIButton!
    @IBOutlet weak var updatemsgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        


        
    
        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "GAME OF 11", isBackBtnVisible: false,isLanguageBtnVisible: true, isGameSelectBtnVisible: false)
        placeContainer()
        
        
        updatemsgLabel.text = "New update is available.".localized
        skipButton.setTitle("SKIP".localized, for: .normal)
        updatebutton.setTitle("UPDATE".localized, for: .normal)
        
       
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
        
        print(containerView)
        addChild(pagerController)
        pagerController.view.frame = containerView.bounds
         print(pagerController.view)
        containerView.addSubview(pagerController.view)
        pagerController.didMove(toParent: self)
        

        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkVersion(_:)), name: NSNotification.Name(rawValue: "versionCheck"), object: nil)
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
        pagerController.scrollIndicator.backgroundColor = UIColor.init(named: "TabOrangeColor")
        pagerController.pageSegmentedControl.backgroundColor = UIColor.init(named: "GreenHighlight")

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
    
    
}
