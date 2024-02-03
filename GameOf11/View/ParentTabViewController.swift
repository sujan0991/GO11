//
//  ParentTabViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 1/9/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class ParentTabViewController: UITabBarController {
    
    
    override var selectedIndex: Int {
        didSet {
            guard let selectedViewController = viewControllers?[selectedIndex] else {
                return
            }
            selectedViewController.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.heavy)], for: .normal)
        }
    }
    
    override var selectedViewController: UIViewController? {
        didSet {
            
            guard let viewControllers = viewControllers else {
                return
            }
            
            for viewController in viewControllers {
                
                if viewController == selectedViewController {
                    
                    let selected: [NSAttributedString.Key: AnyObject] =
                        [.font: UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.heavy)]
                    
                    viewController.tabBarItem.setTitleTextAttributes(selected, for: .normal)
                } else {
                    
                    let normal: [NSAttributedString.Key: AnyObject] =
                        [.font: UIFont.systemFont(ofSize: 12)]
                    
                    viewController.tabBarItem.setTitleTextAttributes(normal, for: .normal)
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load")
        
        self.tabBar.tintColor = UIColor.init(named: "brand_red")
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.masksToBounds = false
        
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

        //Home
        
        let vc1 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        
        let icon1 = UITabBarItem(title: "Home".localized, image: UIImage(named: "homeDeselected.png"), selectedImage: UIImage(named: "homeSelected.png"))
        
        
        let nav1 = UINavigationController(rootViewController: vc1!)
        nav1.navigationBar.isHidden = true
        nav1.tabBarItem = icon1
        
        //MyContest
        
        let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyContestViewController") as? MyContestViewController
        
        let icon2 = UITabBarItem(title: "My Contest".localized, image: UIImage(named: "contestDeselected.png"), selectedImage: UIImage(named: "contestSelected.png"))
        
        
        let nav2 = UINavigationController(rootViewController: vc2!)
        nav2.navigationBar.isHidden = true
        nav2.tabBarItem = icon2
        
        //Profile
        
        let vc3 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        
        let icon3 = UITabBarItem(title: "Profile".localized, image: UIImage(named: "profileDeselected.png"), selectedImage: UIImage(named: "profileSelected.png"))
        
        
        let nav3 = UINavigationController(rootViewController: vc3!)
        nav3.navigationBar.isHidden = true
        nav3.tabBarItem = icon3
        
        //More
        
        let vc4 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MoreViewController") as? MoreViewController
        
        let icon4 = UITabBarItem(title: "More".localized, image: UIImage(named: "moreDeselected.png"), selectedImage: UIImage(named: "moreSelected.png"))
        
        
        let nav4 = UINavigationController(rootViewController: vc4!)
        nav4.navigationBar.isHidden = true
        nav4.tabBarItem = icon4
        
        let tabBarList = [nav1,nav2,nav3,nav4]
        
        viewControllers = tabBarList
        
    }
    
    
//        override func viewWillAppear(_ animated: Bool) {
//    
//            print("view will appear.....")
//        }
    //
    //    override func viewDidAppear(_ animated: Bool) {
    //
    //        print("view did appear.....")
    //    }
    
}
