//
//  SignUpViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 2/3/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//



// ********************************This class is not in use anymore***************
import UIKit
import SafariServices

import Lottie

import Mixpanel

class SignUpViewController: BaseViewController,UITextFieldDelegate {
    
    
    let animationView = AnimationView()
    
    var phoneNo:String!
    
    @IBOutlet weak var animView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeDetailLabel: UILabel!
    @IBOutlet weak var letsPlayButton: UIButton!
    
    
    @IBOutlet weak var phoneNoTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    @IBOutlet weak var referralTextField: UITextField!
    
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var alreadyAccountLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var thikButton: UIButton!
    
    @IBOutlet weak var animationContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationContainerView.isHidden = true
        
        placeNavBar(withTitle: "SIGN UP".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        
        
        //        signUpButton.setBackgroundColor(UIColor.init(named: "HighlightGrey")!, for: UIControl.State.normal)
        //        signUpButton.isUserInteractionEnabled = false
        //
        
        
        
        let animation = Animation.named("sign_up_dialog_anim_2", subdirectory: nil)
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animView.addSubview(animationView)
        
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.topAnchor.constraint(equalTo: animView.layoutMarginsGuide.topAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: animView.leadingAnchor).isActive = true
        
        animationView.bottomAnchor.constraint(equalTo: animView.layoutMarginsGuide.bottomAnchor, constant:0).isActive = true
        animationView.trailingAnchor.constraint(equalTo: animView.trailingAnchor).isActive = true
        animationView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        
        
        /// *** Keypath Setting
        
        let redValueProvider = ColorValueProvider(Color(r: 1, g: 0.2, b: 0.3, a: 1))
        animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "Switch Outline Outlines.**.Fill 1.Color"))
        animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "Checkmark Outlines 2.**.Stroke 1.Color"))
        
        
        self.phoneNoTextField.text = phoneNo
        
        
        nameTextField.placeholder = "Name".localized
        emailTextField.placeholder = "Email Address".localized
        passWordTextField.placeholder = "Password".localized
        confirmPassTextField.placeholder = "Confirm Password".localized
        referralTextField.placeholder = "Referral Code (Optional)".localized
        agreeLabel.text = "I Agree with GO11".localized
        
        verifyButton.setTitle("Verify Mobile Number", for: .normal)
        alreadyAccountLabel.text = "Already have account?".localized
        
        signUpButton.setTitle("Sign Up".localized, for: .normal)
        loginButton.setTitle("Login".localized, for: .normal)
        
        
        welcomeLabel.text = "Welcome to Game of 11".localized
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if #available(iOS 13, *) {
                  if UserDefaults.standard.bool(forKey: "DarkMode"){
                      
                      overrideUserInterfaceStyle = .dark
                      
                  }else{
                      overrideUserInterfaceStyle = .light
                  }
              
              }else{
                  
              }

    }
    
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //
    //        if textField == confirmPassTextField {
    //
    //            if confirmPassTextField.text != passWordTextField.text{
    //
    //                showConfimationAlert("Password are not same")
    //            }
    //        }
    //    }
    
    @IBAction func termsSelectionButtonAction(_ sender: UIButton) {
        
        
        sender.isSelected = !sender.isSelected
        
        //        if sender.isSelected{
        //
        //            signUpButton.setBackgroundColor(UIColor.init(named: "GreenHighlight")!, for: UIControl.State.normal)
        //            signUpButton.isUserInteractionEnabled = true
        //
        //        }else{
        //            signUpButton.setBackgroundColor(UIColor.init(named: "HighlightGrey")!, for: UIControl.State.normal)
        //            signUpButton.isUserInteractionEnabled = false
        //        }
    }
    
    
    @IBAction func termsButtonAction(_ sender: Any) {
        
        let urlString = "https://www.gameof11.com/terms-and-conditions"
        
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
        
    }
    
    
    
    @IBAction func verifyButtonAction(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignupOTPViewController") as? SignupOTPViewController
        
        self.navigationController?.pushViewController(popupVC!, animated: true)
    }
    
    
    
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        if thikButton.isSelected{
            
            let vmsg = ValidationManager.manager.validateRegisterForm(userName: nameTextField.text!, email: emailTextField.text!, password:passWordTextField.text!,phone:phoneNoTextField.text!)
            
            if !vmsg.isEmpty{
                showConfimationAlert(vmsg)
                return
            }
            
            if confirmPassTextField.text != passWordTextField.text{
                
                showConfimationAlert("Password are not same")
                
                return
            }
            
            let phn = String.init(format: "+88%@", self.phoneNoTextField.text!)
            
            print("..................",phn)
            
            APIManager.manager.signup(phone: phn, userName: self.nameTextField.text!,email:self.emailTextField.text!,password: self.passWordTextField.text!,code: self.referralTextField.text!) { (status, token, msg) in
                
                print("...........",status,msg ?? "no msg")
                
                if token != nil {
                    //                self.showStatus(status, msg: msg)
                    
                    
                  
                    
                    Mixpanel.mainInstance().track(event: "complete_sign_up")// set complete_sign_up event in mixpanel
                    
                    //set alias
                    
                    //https://help.mixpanel.com/hc/en-us/articles/115004497803-Identity-Management-Best-Practices
                    
                    if UserDefaults.standard.bool(forKey: "isAliasSet") == false{
                        
                        Mixpanel.mainInstance().createAlias(phn, distinctId: Mixpanel.mainInstance().distinctId)
                        
                        UserDefaults.standard.set(true, forKey: "isAliasSet")
                        
                        Mixpanel.mainInstance().identify(distinctId: phn)
                        
                    }
                    
                    
                    AppSessionManager.shared.authToken = token
                    AppSessionManager.shared.save()
                    
                    var oldToken = ""
                    if let oldFcmToken = AppSessionManager.shared.fcmToken{
                        oldToken = oldFcmToken
                    }
                    APIManager.manager.sendFCMToken(old_token: "", new_token: oldToken, action_type: "signup") { (status, msg) in
                        if status{
                            print(msg ?? "")
                        }
                        else{
                            print(msg ?? "")
                        }
                    }
                    
                    APIManager.manager.getUserOffer(completion: { (status,isOffer,offerMsg,msg) in
                        
                        if status{
                            
                            self.welcomeDetailLabel.attributedText = offerMsg?.htmlToAttributedString
                            self.animationContainerView.isHidden = false
                            //  self.welcomeDetailLabel.text = String.init(format:"%@",offerMsg!)
                            
                            self.animationView.play(fromProgress: 0,
                                                    toProgress: 1,
                                                    loopMode: LottieLoopMode.repeat(5.0),
                                                    completion: { (finished) in
                                                        
                                                        print("animationView.play............")
                                                        if finished {
                                                            print("Animation Complete")
                                                        } else {
                                                            print("Animation cancelled")
                                                        }
                            })
                            
                            
                        }else{
                            
                            print("................",msg)
                        }
                        
                    })
                    
                }
                else{
                    self.view.makeToast("Phone number or email has already been taken".localized)
                }
                
            }
            
        }else{
            
            
        }
    }
    
    @IBAction func letsPlayButtonAction(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginOTPViewController") as? LoginOTPViewController
        
        //        popupVC?.modalPresentationStyle = .overCurrentContext
        //        popupVC?.modalTransitionStyle = .crossDissolve
        //
        //        self.present(popupVC!, animated: true) {
        //
        //
        //        }
        self.navigationController?.pushViewController(popupVC!, animated: false)
        
    }
    
}



extension String {
    var htmlToAttributedString: NSAttributedString? {
        
        
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
