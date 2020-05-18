//
//  BaseViewController.swift
//  Welltravel
//
//  Created by Amit Sen on 11/21/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import UIKit


public enum MatchType:Int {
    case next = 0           //Upcoming match in Home
    case live = 1
    case completed = 2
    case upcomingContest = 3 //JOINED CONTESTS
    case liveContest = 4     //JOINED CONTESTS
    case completedContest = 5 //JOINED CONTESTS
}


class BaseViewController: UIViewController,NavigationBarDelegate {
    
    
    
    
    // Private variables
    
    private var navBar: CustomNavigationBar!
    var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.newAnnouncement(_:)), name: NSNotification.Name(rawValue: "newAnnouncement"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // private methods
    private func extraTop() -> CGFloat {
        var top: CGFloat = 0
        if #available(iOS 11.0, *) {
            if let t = UIApplication.shared.keyWindow?.safeAreaInsets.top {
                if t > 0 {
                    top = t - 20.0
                } else {
                    top = t
                }
            }
        }
        return top
    }
    
    private func onSlideMenuButtonPressed(_ sender: UIButton) {
        if sender.tag == 10 {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1)
            
            sender.tag = 0
            
            let viewMenuBack: UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (_) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        
    }
    
    private func openViewControllerBasedOnIdentifier(_ strIdentifier: String, storyboard: UIStoryboard) {
        let destViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController: UIViewController = self.navigationController!.topViewController!
        
        if topViewController.restorationIdentifier! == destViewController.restorationIdentifier! {
            print("Same View Controller")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    // public methods
    open func placeNavBar(withTitle title: String, isBackBtnVisible visible: Bool,isLanguageBtnVisible lnVisible: Bool,isGameSelectBtnVisible isGameBtnVisible: Bool,isAnnouncementBtnVisible: Bool,isCountLabelVisible: Bool) {
        
        print("extraTop..........",extraTop())
        navBar = CustomNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64.0 + extraTop()))
        
        navBar.delegate = self
        
        navBar.activateBtn(navBarTitle: title,
                           isBackBtnVisible: visible, isLanguageBtnVisible: lnVisible, isGameSelectBtnVisible: isGameBtnVisible,isAnnouncementBtnVisible: isAnnouncementBtnVisible,isCountLabelVisible: isCountLabelVisible) { btn in
                            
                            
                            //            if visible {
                            //                self.onSlideMenuButtonPressed(btn)
                            //            } else {
                            //                _ = self.navigationController?.popViewController(animated: true)
                            //            }
        }
        self.view.addSubview(navBar)
    }
    
    
    open func placeContainer()
    {
        let someFloat = CGFloat(self.view.frame.height)
        
        containerView = UIView(frame: CGRect(x: 0, y: navBar.frame.height ,width: UIScreen.main.bounds.size.width,height: someFloat - navBar.frame.height ))
        containerView.backgroundColor = UIColor.init(named: "brand_bg_color")
        
        
        self.view.addSubview(containerView)
        
    }
    // Delegates
    // SlideMenuDelegate
    func slideMenuItemSelectedAtIndex(_ index: Int) {
        let topViewController: UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch index {
        case 0:
            print("EditProfileViewController\n", terminator: "")
            //            self.openViewControllerBasedOnIdentifier("EditProfileViewController", 
            //                                                     storyboard: UIStoryboard(name: App.sharedInstance.routes.profile,
            //                                                                              bundle: nil))
            
        default:
            print("default\n", terminator: "")
        }
    }
    
    func languageButtonAction(){
        
        
        
        print("languageButtonAction in base")
        
        // Post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "languageChange"), object: nil, userInfo: nil)
        
        
    }
    
    //    func announcementButtonAction() {
    //
    //         print("announcementButtonAction in base")
    //        // Post a notification
    //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "announcement"), object: nil, userInfo: nil)
    //
    //
    //    }
    
    //    func gameSelectAction(isSelected:Bool){
    //        
    //        
    //        print("gameSelectAction in base........",isSelected)
    //        
    ////        gameChange()
    //        
    //        // Post a notification
    //        let dataDict:[String: Bool] = ["isSelected": isSelected]
    //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gameChange"), object: nil, userInfo: dataDict)
    //        
    //        
    //    }
    
    //    func gameChange(){
    //
    //        print("gameChangeAction in base.........")
    //    }
    
    @objc func newAnnouncement(_ notification: NSNotification) {
        
        
        let count = notification.userInfo!["count"]! as! Int
        
        print("noti info.........count..",count)
        
        navBar.announcement(count: count)
    }
    
    func backButtonAction() {
        if (self.navigationController != nil)
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.dismiss(animated: true) {
                print("Dismiss")
            }
        }
    }
    
}
