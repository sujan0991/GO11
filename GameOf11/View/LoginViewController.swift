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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       // phoneField.text = "+8801715257212"
        phoneField.text = "+8801676330929"
        passwordField.text = "123456"
            
        
        signinButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        if let currentToken = AppSessionManager.shared.authToken{
            print(currentToken)
        }
        
        
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signinAction(_ sender: Any) {
        
        APIManager.manager.login(userName: phoneField.text!, password: passwordField.text!) { (status, token, msg) in
           
            if status{
                self.showStatus(status, msg: msg)
                
                AppSessionManager.shared.authToken = token
                AppSessionManager.shared.save()
                
               self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                self.showStatus(false, msg: msg)
            }
            
        }
        
        
    }
   

}
