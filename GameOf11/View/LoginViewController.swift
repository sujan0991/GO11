//
//  LoginViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 5/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: BaseViewController {
    
    
    
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var forgotPassButton: UIButton!
    
    @IBOutlet weak var shadoWView: UIView!
    @IBOutlet weak var languagEView: UIView!
    
    @IBOutlet weak var changeLanguageLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var banglaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "LOGIN".localized, isBackBtnVisible: true,isLanguageBtnVisible: true, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.languageChangeAction(_:)), name: NSNotification.Name(rawValue: "languageChange"), object: nil)
        
        if Language.language == Language.bangla{
            
            banglaButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
            banglaButton.backgroundColor = UIColor.init(named: "GreenHighlight")!
            
            englishButton.backgroundColor = UIColor.white
            englishButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
        }else{
            banglaButton.backgroundColor = UIColor.white
            banglaButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
            
            englishButton.backgroundColor = UIColor.init(named: "GreenHighlight")!
            englishButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
            
        }
        
        englishButton.layer.borderWidth = 0.5
        englishButton.layer.borderColor = UIColor.lightGray.cgColor
        banglaButton.layer.borderWidth = 0.5
        banglaButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        //        phoneField.text = "01676330929"
        //        passwordField.text = "123456"
        
        
        signinButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        if let currentToken = AppSessionManager.shared.authToken{
            print(currentToken)
        }
        
        phoneField.placeholder = "Phone Number".localized
        passwordField.placeholder = "Password".localized
        
        signUpButton.setTitle("Sign Up".localized, for: .normal)
        signinButton.setTitle("Login".localized, for: .normal)
        forgotPassButton.setTitle("Forgot Password?".localized, for: .normal)
        dontHaveAccountLabel.text = "Don't have any account?".localized
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        shadoWView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        shadoWView.isHidden = true
        languagEView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        languagEView.isHidden = true
        shadoWView.isHidden = true
        if #available(iOS 13, *) {
                  if UserDefaults.standard.bool(forKey: "DarkMode"){
                      
                      overrideUserInterfaceStyle = .dark
                      
                  }else{
                      overrideUserInterfaceStyle = .light
                  }
              
              }else{
                  
              }

    }
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController
        
        self.navigationController?.pushViewController(popupVC!, animated: true)
    }
    
    @IBAction func passSeenUnseenButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            passwordField.isSecureTextEntry = false
        }else{
            
            passwordField.isSecureTextEntry = true
        }
        
    }
    
    
    @IBAction func forgotPassButtonAction(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController
        
        self.navigationController?.pushViewController(popupVC!, animated: false)
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signinAction(_ sender: Any) {
        
        let phn = String.init(format: "+88%@", phoneField.text!)
        APIManager.manager.login(userName: phn, password: passwordField.text!) { (status, token, msg) in
            
            if status{
                self.view.makeToast( msg!)
                
                AppSessionManager.shared.authToken = token
                AppSessionManager.shared.save()
                
                //                let sb: UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                //                let vc = sb.instantiateInitialViewController()
                //
                //                if let window = UIApplication.shared.delegate?.window {
                //                    window?.rootViewController = vc
                //                }
                var oldToken = ""
                if let oldFcmToken = AppSessionManager.shared.fcmToken{
                    oldToken = oldFcmToken
                }
                APIManager.manager.sendFCMToken(old_token: "", new_token: oldToken, action_type: "login") { (status, msg) in
                    if status{
                        print(msg ?? "")
                    }
                    else{
                        print(msg ?? "")
                    }
                }
                
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            else{
                self.view.makeToast(msg!)
            }
            
        }
        
        
    }
    
    
    
    @IBAction func englishButtonAction(_ sender: Any) {
        Language.language = Language.english
    }
    
    @IBAction func banglaButtonAction(_ sender: Any) {
        Language.language = Language.bangla
    }
    
    @objc func languageChangeAction(_ notification: NSNotification) {
        
        phoneField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        print("baseLanguageButtonAction")
        if let currentVC = UIApplication.topViewController() as? LoginViewController {
            
            shadoWView.isHidden = false
            languagEView.isHidden = false
            
        }
        
    }
}
