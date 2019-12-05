//
//  BaseViewController.swift
//  Welltravel
//
//  Created by Amit Sen on 11/21/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import UIKit


public enum MatchType:Int {
    case next = 0
    case live = 1
    case completed = 2
    case upcomingContest = 3
    case liveContest = 4
    case completedContest = 5
}


class BaseViewController: UIViewController,NavigationBarDelegate {
   

    // Private variables
    
    private var navBar: CustomNavigationBar!
    var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    open func placeNavBar(withTitle title: String, isBackBtnVisible visible: Bool,isLanguageBtnVisible lnVisible: Bool) {
        
        print("extraTop..........",extraTop())
        navBar = CustomNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64.0 + extraTop()))
        
        navBar.delegate = self
        
        navBar.activateBtn(navBarTitle: title,
                           isBackBtnVisible: visible, isLanguageBtnVisible: lnVisible) { btn in
                            
                            
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
        containerView.backgroundColor = UIColor.init(named: "BackgroundColor")

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
