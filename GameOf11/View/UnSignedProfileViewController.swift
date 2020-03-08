//
//  UnSignedProfileViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 2/3/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit


class UnSignedProfileViewController: UIViewController {

    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var suggestionLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // placeNavBar(withTitle: "Sign UP", isBackBtnVisible: true)
        
        // initialize Account Kit
//        if _accountKit == nil {
//            _accountKit = AKFAccountKit(responseType: .accessToken)
//        }
//        
        
        signUpButton.decorateButtonRound(5, borderWidth: 0.5, borderColor: "#30B847")
        
        suggestionLabel.text = "You are not logged in. You have to Login or Sign Up to perform your desired action.".localized
        
        signUpButton.setTitle("Sign Up".localized, for: .normal)
        loginButton.setTitle("Login".localized, for: .normal)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear in UnSignedProfileViewController")
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
         print("viewDidAppear in UnSignedProfileViewController")
        if AppSessionManager.shared.authToken != nil{
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    func prepareFBLoginViewController(loginViewController: AKFViewController) {
//
//        loginViewController.delegate = self
//        loginViewController.whitelistedCountryCodes = ["BD"]
//
//        // Optionally, you may set up backup verification methods.
//        loginViewController.enableSendToFacebook = true
//        loginViewController.enableGetACall = true
//
//        //UI Theming - Optional
//        loginViewController.uiManager = AKFSkinManager(skinType: .classic, primaryColor: UIColor.init(named: "GreenHighlight"))
//
//
//    }
//
    @IBAction func signUpButtonAction(_ sender: Any) {

        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController

       self.navigationController?.pushViewController(popupVC!, animated: true)

//        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
//
//        popupVC?.phoneNo = "01768431957"
//        self.navigationController?.pushViewController(popupVC!, animated: true)
    }
//
    @IBAction func logInButtonAction(_ sender: Any) {

        self.tabBarController?.tabBar.isHidden = true

        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController



        self.navigationController?.pushViewController(popupVC!, animated: true)


    }
//
//
//    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
//
//                print("did complete login with access token \(accessToken.tokenString) state \(String(describing: state))")
//
//                print("Login successful")
//
//        _accountKit.requestAccount{
//            (account, error) -> Void in
//            if let phoneNumber = account?.phoneNumber{
//
//                print("phone number..........",phoneNumber.phoneNumber)
//
//                self.tabBarController?.tabBar.isHidden = true
//
//                let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
//
//                popupVC?.phoneNo = phoneNumber.phoneNumber
//                self.navigationController?.pushViewController(popupVC!, animated: true)
//
//            }
//
//        }
//
//    }
//
//
//
//
//
//    //handle a failed
//    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
//        // ... implement appropriate error handling ...
//        print("\(String(describing: viewController)) did fail with error: \(error.localizedDescription)")
//    }
//
//    //or canceled login
//    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
//        // ... handle user cancellation of the login process ...
//    }
    
    
    //for logout
    //accountKit.logOut()
    
}
