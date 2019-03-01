//
//  EditProfileViewController.swift
//  DropDown
//
//  Created by MacBook Pro Retina on 2/18/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//
// [self.stackView.arrangedSubviews[_expandedViewIndex] setHidden: YES];

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var mailTextField: UITextField!
    
    @IBOutlet var phoneTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var oldPasswordTextFoeld: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    
    @IBOutlet var changePasswordButton: UIButton!
    @IBOutlet var dateOfbirthTextField: UITextField!
    
    @IBOutlet var maleButton: UIButton!
    
    @IBOutlet var femaleButton: UIButton!
    
    @IBOutlet var mailingAddressTextField: UITextField!
    
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var zipCodeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomView = stackView.arrangedSubviews[1]
        bottomView.isHidden = true
        
        maleButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#30B847")
        femaleButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#30B847")
        changePasswordButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#AEB2BB")
        //AEB2BB
    }
    

    @IBAction func changeButtonAction(_ sender: Any) {
        
       let bottomView = stackView.arrangedSubviews[1]
       
        UIView.animate(withDuration: 0.10) {
            bottomView.isHidden = false
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        let bottomView = stackView.arrangedSubviews[1]
        
        UIView.animate(withDuration: 0.10) {
            bottomView.isHidden = true
            
        }

        
    }
    
    @IBAction func maleButtonAction(_ sender: Any) {
    }
    
    @IBAction func femaleButtonAction(_ sender: Any) {
    }
    
    @IBAction func changePassButtonAction(_ sender: Any) {
        
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}

