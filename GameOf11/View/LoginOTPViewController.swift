//
//  LoginOTPViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 6/3/22.
//  Copyright © 2022 Tanvir Palash. All rights reserved.
//

import UIKit
import Mixpanel
import SafariServices

//protocol BackFromOTPView {
//
//    func backFromOTP(phone: String)
//}

class LoginOTPViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var otpView: UIView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var reSendButton: UIButton!
    //    var delegate: BackFromOTPView?
    
    
    @IBOutlet weak var loginWithPassButton: UIButton!
    
    @IBOutlet weak var verifyOTPButton: UIButton!
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBOutlet weak var thikButton: UIButton!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var alreadyAccountLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var countdownTimer: Timer!
    var totalTime = 60
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tabBarController?.tabBar.isHidden = true
        
        
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        textField5.delegate = self
        textField6.delegate = self
        
        //agreeLabel.text = "By verifying the number, I am agreeing the rules of GO11 and I assure that my age is 18+".localized
        
        verifyButton.setTitle("VERIFY NUMBER", for: .normal)
        //alreadyAccountLabel.text = "Already have account?".localized
        
        
        //loginButton.setTitle("Login".localized, for: .normal)
        
        
        
        phoneNumberTextField.becomeFirstResponder()
        
        verifyButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        verifyOTPButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        
        
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
        
        
        otpView.isHidden = true
        if countdownTimer != nil{
            countdownTimer.invalidate()
        }
        
        totalTime = 60
        
        textField1.text = ""
        textField2.text = ""
        textField3.text = ""
        textField4.text = ""
        textField5.text = ""
        textField6.text = ""
        
        timerLabel.text = "0 : 00"
    }
    
    @IBAction func termsSelectionButtonAction(_ sender: UIButton) {
        
        
        sender.isSelected = !sender.isSelected
        
        
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
    
    
    @IBAction func loginWithPassButtonAction(_ sender: Any) {
        
        let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        
        
        self.navigationController?.pushViewController(popupVC!, animated: true)
        
    }
    
    // verify number button
    @IBAction func nextButtonAction(_ sender: Any) {
        
        if phoneNumberTextField.text?.count != 0 && phoneNumberTextField.text?.count == 11{
            
            
            APIManager.manager.sendOTP(phone: phoneNumberTextField.text!) { (status, msg) in

                print("msg..........",msg!)

                if status{

                    self.otpView.isHidden = false
                    self.startTimer()
                    self.textField1.becomeFirstResponder()

                    self.topLabel.text = "We have sent you an OTP(One Time Password) at \(String(describing: self.phoneNumberTextField.text!))"

                }
            }
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if (textField.text!.count < 1) && (string.count > 0){
            
            if textField == textField1{
                
                textField2.becomeFirstResponder()
                
            }else if textField == textField2{
                
                textField3.becomeFirstResponder()
            }else if textField == textField3{
                
                textField4.becomeFirstResponder()
            }
            else if textField == textField4{
                
                textField5.becomeFirstResponder()
            }
            else if textField == textField5{
                
                textField6.becomeFirstResponder()
                
            }else if textField == textField6{
                
                textField6.resignFirstResponder()
            }
            
            textField.text = string
            
            return false
            
        }
        
        else if (textField.text!.count >= 1) && (string.count == 0){
            
            if textField == textField6{
                
                textField5.becomeFirstResponder()
                
            }else if textField == textField5{
                
                textField4.becomeFirstResponder()
            }else if textField == textField4{
                
                textField3.becomeFirstResponder()
            }else if textField == textField3{
                
                textField2.becomeFirstResponder()
            }else if textField == textField2{
                
                textField1.becomeFirstResponder()
            }else if textField == textField1{
                
                textField1.becomeFirstResponder()
            }
            
            textField.text = ""
            
            return false
        }
        
        else if (textField.text!.count >= 1){
            
            textField.text = string
            
            return false
        }
        
        return true
    }
    
    
    func startTimer() {
        timerLabel.isHidden = false
        reSendButton.isUserInteractionEnabled = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        timerLabel.isHidden = true
        reSendButton.isUserInteractionEnabled = true
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%01d:%02d", minutes, seconds)
    }
    
    @IBAction func reSendButtonAction(_ sender: Any) {
        
        APIManager.manager.sendOTP(phone: phoneNumberTextField.text!) { (status, msg) in
            
            print("msg..........",msg!)
            
            if status{
                
                self.textField1.text = ""
                self.textField2.text = ""
                self.textField3.text = ""
                self.textField4.text = ""
                self.textField5.text = ""
                self.textField6.text = ""
                
                self.countdownTimer.invalidate()
                self.totalTime = 60
                self.startTimer()
                self.textField1.becomeFirstResponder()
                
                
            }
        }
        
    }
    
    @IBAction func verifyButtonAction(_ sender: Any) {
        
        if (textField1.text?.count != 0) && (textField2.text?.count != 0) && (textField3.text?.count != 0) && (textField4.text?.count != 0) && (textField5.text?.count != 0) && (textField6.text?.count != 0) {
            
            let otpString = "\(String(describing: textField1.text!))\(String(describing: textField2.text!))\(String(describing: textField3.text!))\(String(describing: textField4.text!))\(String(describing: textField5.text!))\(String(describing: textField6.text!))"
            
           
            let phn = String.init(format: "+88%@", phoneNumberTextField.text!)
            
            var oldToken = ""
            if let oldFcmToken = AppSessionManager.shared.fcmToken{
                oldToken = oldFcmToken
            }
            print("otpString......",phn, oldToken, otpString)
           
            
            APIManager.manager.signin(phone: phn, otp: otpString, key: oldToken) { (status, token, msg) in
                
                if status{
                    self.view.makeToast( msg!)
                    
                    AppSessionManager.shared.authToken = token
                    AppSessionManager.shared.save()
                    
                    //set alias
                    
                    //https://help.mixpanel.com/hc/en-us/articles/115004497803-Identity-Management-Best-Practices
                    
                    if UserDefaults.standard.bool(forKey: "isAliasSet") == false{
                        
                        Mixpanel.mainInstance().createAlias(phn, distinctId: Mixpanel.mainInstance().distinctId)
                        
                        UserDefaults.standard.set(true, forKey: "isAliasSet")
                        
                        Mixpanel.mainInstance().identify(distinctId: phn)
                        
                    }
                    
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
                else{
                    self.view.makeToast(msg!)
                }
                
            }
            
            
        }
        
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        navigationController?.popViewController(animated: false)
        
    }
    
    
    @IBAction func backButtonOTPAction(_ sender: Any) {
        
        otpView.isHidden = true
        countdownTimer.invalidate()
        totalTime = 60
        
        textField1.text = ""
        textField2.text = ""
        textField3.text = ""
        textField4.text = ""
        textField5.text = ""
        textField6.text = ""
        
        textField1.resignFirstResponder()
        textField2.resignFirstResponder()
        textField3.resignFirstResponder()
        textField4.resignFirstResponder()
        textField5.resignFirstResponder()
        textField6.resignFirstResponder()
    }
    
    
}
