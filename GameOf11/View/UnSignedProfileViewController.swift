//
//  UnSignedProfileViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 2/3/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import AccountKit

class UnSignedProfileViewController: BaseViewController,AKFViewControllerDelegate {

    
    @IBOutlet weak var signUpButton: UIButton!
    
    var _accountKit: AKFAccountKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         placeNavBar(withTitle: "Sign UP", isBackBtnVisible: true)
        
        // initialize Account Kit
        if _accountKit == nil {
            _accountKit = AKFAccountKit(responseType: .accessToken)
        }
    }
    

    @IBAction func loginButtonAction(_ sender: Any) {
        
        
    }
    
    func prepareFBLoginViewController(loginViewController: AKFViewController) {
        
        loginViewController.delegate = self
        loginViewController.whitelistedCountryCodes = ["BD"]

        // Optionally, you may set up backup verification methods.
        loginViewController.enableSendToFacebook = true
        loginViewController.enableGetACall = true
        
        //UI Theming - Optional
        loginViewController.uiManager = AKFSkinManager(skinType: .classic, primaryColor: UIColor.init(named: "GreenHighlight"))
        
       
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        let vc = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: nil))!
        vc.enableSendToFacebook = true
        self.prepareFBLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
        
        
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
                print("did complete login with access token \(accessToken.tokenString) state \(String(describing: state))")
        
                print("Login successful")
        
                let VC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        
        
                self.navigationController?.pushViewController(VC!, animated: true)

    }
    
    
    
  
    
    //handle a failed
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        // ... implement appropriate error handling ...
        print("\(String(describing: viewController)) did fail with error: \(error.localizedDescription)")
    }
    
    //or canceled login
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        // ... handle user cancellation of the login process ...
    }
    
    
    //for logout
    //accountKit.logOut()
    
}
