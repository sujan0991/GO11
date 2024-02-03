//
//  ForgotPasswordViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 20/8/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitleLabel.text = "FORGOT PASSWORD".localized
        suggestionLabel.text = "Please write your GO11 registered email address to get generated password. You will be using it while Logging into GO11.".localized
        
        emailTextField.placeholder = "Email Address".localized
        
        resetButton.setTitle("Request to reset password".localized, for: .normal)
        resetButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if #available(iOS 13, *) {
                  if UserDefaults.standard.bool(forKey: "DarkMode"){
                      
                      overrideUserInterfaceStyle = .dark
                      
                  }else{
                      overrideUserInterfaceStyle = .light
                  }
              
              }else{
                  
              }
    }
    
    @IBAction func requestPasswordButtonAction(_ sender: Any) {
        
        self.emailTextField.resignFirstResponder()
        
        let vmsg = ValidationManager.manager.validateForgotPass(email: emailTextField.text!)
        
        if !vmsg.isEmpty{
            showConfimationAlert(vmsg)
            return
        }
        
        APIManager.manager.forgotPassword(email: emailTextField.text!) { (status, msg) in
            
            print("email sent.......")
            
            self.view.makeToast(msg!)
            
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
