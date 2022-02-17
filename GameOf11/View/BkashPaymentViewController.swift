//
//  BkashPaymentViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 21/5/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class BkashPaymentViewController: BaseViewController,WKNavigationDelegate {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlString = ""
    
    var selectedChannelType = "None"
    var rechargAmount = "0"
    var isCoinPack = "no"
    
    var selectedContestId = 0
    var createdTeamList: [CreatedTeam] = []
    
    var isFromDipositCoin = "yes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeNavBar(withTitle: "COIN PURCHASE".localized, isBackBtnVisible: true, isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        self.webView.navigationDelegate = self
        
        self.tabBarController?.tabBar.isHidden = true;
        
        print("url string",urlString)
        
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 13, *) {
            if UserDefaults.standard.bool(forKey: "DarkMode"){
                
                overrideUserInterfaceStyle = .dark
                
            }else{
                overrideUserInterfaceStyle = .light
            }
            
        }else{
            
        }
        
        if let vcStack = self.navigationController?.viewControllers
        {
            for vc in vcStack {
                if vc.isKind(of: ProfileViewController.self)
                {
                   
                    print("isfrom diposite coin", isFromDipositCoin)
                    print("amount", rechargAmount)

                    
                }else  if vc.isKind(of: ContestListViewController.self)
                {
                    print("isfrom diposite coin", isFromDipositCoin)
                    print("amount?????????/", rechargAmount)

                }
            }
        }
    }
    
    //MARK:- WKNavigationDelegate
    
    func webView(didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("finish to load")
        
        //        let contestDataDict:[String: Any] = ["contestId": selectedContestId,"teams" : createdTeamList]
        //        
        //        self.navigationController?.popViewController(animated: true)
        //        
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paymentFromContestList"), object: nil, userInfo: contestDataDict)
        //
        
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        print("didCommit....",webView.url ?? "no url")
        
        if webView.url?.absoluteString == "https://www.gameof11.com/payment/success"{
            
            print("got success url ")
            //self.view.makeToast("Payment successfull".localized)
            // self.showStatus(true, msg: "Payment successfull")
            
            if let vcStack = self.navigationController?.viewControllers
            {
                for vc in vcStack {
                    if vc.isKind(of: ProfileViewController.self)
                    {
                        self.navigationController?.popToViewController(vc, animated: true)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paymentFromProfile"), object: nil, userInfo: ["channel":selectedChannelType, "isCoinPack":isCoinPack, "amount":rechargAmount])
                        
                        break
                    }else  if vc.isKind(of: ContestListViewController.self)
                    {
                        if isFromDipositCoin == "no"{
                            
                            let contestDataDict:[String: Any] = ["contestId": selectedContestId,"teams" : createdTeamList]
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paymentFromContestList"), object: nil, userInfo: contestDataDict)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paymentFromContestListMixpanel"), object: nil, userInfo: ["channel":selectedChannelType, "isCoinPack":isCoinPack, "amount":rechargAmount])
                            
                        }else{
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paymentFromContestListMixpanel"), object: nil, userInfo: ["channel":selectedChannelType, "isCoinPack":isCoinPack, "amount":rechargAmount])
                        }
                        
                        self.navigationController?.popToViewController(vc, animated: true)
                       
                        
                        break
                    }
                }
            }
            
        }else if webView.url?.absoluteString == "https://www.gameof11.com/payment/failed"{
            
            self.view.makeToast("Something went wrong! Please try again".localized)
        }
    }
}
