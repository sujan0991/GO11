//
//  ReferalViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 21/5/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import SafariServices

class ReferalViewController: BaseViewController {
    
    
    @IBOutlet weak var suggestionLabel: UILabel!
    
    @IBOutlet weak var codeTitleLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var shareCodeButton: UIButton!
    
    @IBOutlet weak var howItWorkLabel: UILabel!
    
    @IBOutlet weak var stepOneLabel: UILabel!
    @IBOutlet weak var stepOneDetailLabel: UILabel!
    
    @IBOutlet weak var stepTwoLabel: UILabel!
    @IBOutlet weak var stepTwoDetaillabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  self.view.setGradientBackground(colorTop:UIColor.white , colorBottom: UIColor.init(named: "light_blue_transparent")!)
        
        
        placeNavBar(withTitle: "MY REFERRALS".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        self.tabBarController?.tabBar.isHidden = true;
        
        
        suggestionLabel.text = "Share your referral code with your friends and get your offer".localized
        
        shareCodeButton.setTitle("Share Your Code".localized, for: .normal)
        howItWorkLabel.text = "How it Works?".localized
        stepOneLabel.text = "STEP 01".localized
        stepOneDetailLabel.text = "Share your referral code with your friends. Encourage to use your code when signing up in GO11.".localized
        stepTwoLabel.text = "STEP 02".localized
        stepTwoDetaillabel.text = "When your friend sign up with your referral code and join in a paid contest you will get a chance to join a paid contest completely free. Your available free contests will be shown in your profile and contest list.".localized
        
        if let um = AppSessionManager.shared.currentUser {
            
            print("code",um.referralCode ?? "no code")
            codeLabel.text = um.referralCode ?? "no code"
            
        }
    }
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        
        if let um = AppSessionManager.shared.currentUser {
            
            let vc = UIActivityViewController(activityItems: [um.referralMessage!], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func howWorkButtonAction(_ sender: Any) {
        
        let urlString = "https://www.gameof11.com/referral-system"
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
        
    }
    
    
}
