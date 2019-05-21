//
//  ReferalViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 21/5/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class ReferalViewController: BaseViewController {

    @IBOutlet weak var codeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

         placeNavBar(withTitle: "My Referrals", isBackBtnVisible: true)
        
        self.tabBarController?.tabBar.isHidden = true;
        
        
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
    

}
