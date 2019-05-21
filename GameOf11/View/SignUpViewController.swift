//
//  SignUpViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 2/3/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var phoneNoTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    @IBOutlet weak var referralTextField: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.isEnabled = false
        

        
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
        
        let vmsg = ValidationManager.manager.validateRegisterForm(userName: nameTextField.text!, email: emailTextField.text!, password:passWordTextField.text!,phone:phoneNoTextField.text!)

        if !vmsg.isEmpty{
            showConfimationAlert(vmsg)
            return
        }

        if confirmPassTextField.text != passWordTextField.text{

            showConfimationAlert("Password are not same")

            return
        }

        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{

            signUpButton.isEnabled = true
        }else{
            signUpButton.isEnabled = false

        }
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
        
        
        
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        APIManager.manager.signup(phone: self.phoneNoTextField.text!, userName: self.nameTextField.text!,email:self.emailTextField.text!,password: self.passWordTextField.text!,code: self.referralTextField.text!) { (status, token, msg) in
            
            print("...........",status,msg ?? "no msg")
            
            if token != nil {
//                self.showStatus(status, msg: msg)

                AppSessionManager.shared.authToken = token
                AppSessionManager.shared.save()

                self.navigationController?.popToRootViewController(animated: true)
            }
            else{
               // self.showStatus(false, msg: msg)
            }
        
         }
    }
    

    @IBAction func loginButtonAction(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
