//
//  SignUpViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 2/3/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var phoneNoTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func termsSelectionButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func termsButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func verifyButtonAction(_ sender: Any) {
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
    }
    

    @IBAction func loginButtonAction(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
