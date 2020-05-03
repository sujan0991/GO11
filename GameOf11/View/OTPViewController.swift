//
//  OTPViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 9/2/20.
//  Copyright © 2020 Tanvir Palash. All rights reserved.
//

import UIKit

//protocol BackFromOTPView {
//
//    func backFromOTP(phone: String)
//}

class OTPViewController: UIViewController,UITextFieldDelegate {

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
        
        phoneNumberTextField.becomeFirstResponder()
        
        
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
        
        print("otpString......",otpString)
            


            APIManager.manager.OTPVerification(phone: self.phoneNumberTextField.text!, otp: otpString) { (status, msg) in

                if status{

                    let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
                    
                    popupVC?.phoneNo = self.phoneNumberTextField.text!
                    self.navigationController?.pushViewController(popupVC!, animated: true)

            }

        }

    }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        navigationController?.popViewController(animated: true)
        
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
