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
        phoneField.text = "+8801686443334"
        passwordField.text = "palash0802"
            
        
        signinButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        if let currentToken = AppSessionManager.shared.authToken{
            print(currentToken)
        }
        
        
    }
    

    @IBAction func signinAction(_ sender: Any) {
        
        APIManager.manager.login(userName: phoneField.text!, password: passwordField.text!) { (status, token, msg) in
           
            if status{
                SVProgressHUD.showSuccess(withStatus: msg)
                AppSessionManager.shared.authToken = token
                AppSessionManager.shared.save()
                
               self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                SVProgressHUD.showError(withStatus: msg)
            }
            
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
