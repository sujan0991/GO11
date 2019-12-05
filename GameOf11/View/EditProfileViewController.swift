//
//  EditProfileViewController.swift
//  DropDown
//
//  Created by MacBook Pro Retina on 2/18/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//
// [self.stackView.arrangedSubviews[_expandedViewIndex] setHidden: YES];

import UIKit

class EditProfileViewController: BaseViewController {
    
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet var mailTextField: UITextField!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet var phoneTextField: UITextField!
    
    @IBOutlet weak var passWordlabel: UILabel!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var oldPasswordTextFoeld: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var changePasswordButton: UIButton!
    @IBOutlet var dateOfbirthTextField: UITextField!
    
    @IBOutlet var maleButton: UIButton!
    
    @IBOutlet var femaleButton: UIButton!
    
    @IBOutlet var mailingAddressTextField: UITextField!
    
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var zipCodeTextField: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeNavBar(withTitle: "PERSONAL DETAILS".localized, isBackBtnVisible: true,isLanguageBtnVisible: false)
        
        self.tabBarController?.tabBar.isHidden = true
        
        let bottomView = stackView.arrangedSubviews[1]
        bottomView.isHidden = true
        
        nameLabel.text = "Name".localized
        mailLabel.text = "Email Address".localized
        phoneLabel.text = "Phone Number".localized
        passWordlabel.text = "Password".localized
        oldPasswordTextFoeld.placeholder = "Old Password".localized
        newPasswordTextField.placeholder = "New Password".localized
        cancelButton.setTitle("Cancel".localized, for: .normal)
        changeButton.setTitle("Change".localized, for: .normal)
        changePasswordButton.setTitle("Change Password".localized, for: .normal)
        dateOfbirthTextField.placeholder = "Date of Birth".localized
        maleButton.setTitle("Male".localized, for: .normal)
        femaleButton.setTitle("Female".localized, for: .normal)
        mailingAddressTextField.placeholder = "Mailing Address".localized
        cityTextField.placeholder = "City".localized
        zipCodeTextField.placeholder = "Zipcode".localized
        updateButton.setTitle("UPDATE PROFILE".localized, for: .normal)
        
        
        maleButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#30B847")
        femaleButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#30B847")
        changePasswordButton.decorateButtonRound(5, borderWidth: 1.0, borderColor: "#AEB2BB")
        //AEB2BB
        
        
        if let um = AppSessionManager.shared.currentUser {
            
            self.phoneTextField.text = String.init(format: "%@", um.phone ?? "")
            self.nameTextField.text = String.init(format: "%@", um.name ?? "")
            self.mailTextField.text = String.init(format: "%@", um.email ?? "")
            self.dateOfbirthTextField.text = String.init(format: "%@", um.dateOfBirth ?? "")
            self.mailingAddressTextField.text = String.init(format: "%@", um.address ?? "")
            self.cityTextField.text = String.init(format: "%@", um.city ?? "")
            self.zipCodeTextField.text = String.init(format: "%@", um.zipcode ?? "")
            
            print(",,,,,,,,,um.sex",um.sex)
            
            if um.sex != nil{
                if um.sex == "Male"{
                    
                    maleButton.isSelected = true;
                    maleButton.backgroundColor = UIColor.init(named: "GreenHighlight")
                    
                }else if um.sex == "Female"{
                    
                    femaleButton.isSelected = true;
                    femaleButton.backgroundColor = UIColor.init(named: "GreenHighlight")
                    
                }
            }
            
            let dateFormatter = DateFormatter()
            self.dateOfbirthTextField.text = um.dateOfBirth
            
            
            if um.isVerified == 1 {
                
                nameTextField.isUserInteractionEnabled = false
            }
            
        }
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
    
    @IBAction func maleButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            femaleButton.isSelected = false
            femaleButton.backgroundColor = UIColor.white
            sender.backgroundColor = UIColor.init(named: "GreenHighlight")
            
        }else{
            
            sender.backgroundColor = UIColor.white
            
        }
    }
    
    @IBAction func femaleButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            maleButton.isSelected = false
            maleButton.backgroundColor = UIColor.white
            sender.backgroundColor = UIColor.init(named: "GreenHighlight")
            
        }else{
            
            sender.backgroundColor = UIColor.white
            
        }
    }
    
    @IBAction func changePassButtonAction(_ sender: Any) {
        
        let validateMsg = ValidationManager.manager.validateResetPasswordForm(oldPassword: oldPasswordTextFoeld.text!, confirmPassword: newPasswordTextField.text!)
        
        if !validateMsg.isEmpty{
            showConfimationAlert(validateMsg)
            return
        }
        
        
        APIManager.manager.changePasswordWith(oldPassword: oldPasswordTextFoeld.text!, newPassword: newPasswordTextField.text!) { (status, msg) in
          
            if status{
                
                self.view.makeToast("Password change successful.".localized)
            }else{
                
                self.view.makeToast(msg!)
            }
        }
        
        
        
    }
    
    @IBAction func updateProfileButtonAction(_ sender: Any) {
        
   
        var params:[String:String] = [:]
        
        if nameTextField.text!.count > 0{
            
            if maleButton.isSelected{
              
                 params = ["name":nameTextField.text!,
                                              "sex":"Male",
                                              "address":mailingAddressTextField.text ?? "",
                                              "city":cityTextField.text ?? "",
                                              "zipcode":zipCodeTextField.text ?? "",
                                              "dob":dateOfbirthTextField.text ?? ""]
            }else if femaleButton.isSelected{
                
                 params = ["name":nameTextField.text!,
                                              "sex":"Female",
                                              "address":mailingAddressTextField.text ?? "",
                                              "city":cityTextField.text ?? "",
                                              "zipcode":zipCodeTextField.text ?? "",
                                              "dob":dateOfbirthTextField.text ?? ""]
            }else{
                
                params = ["name":nameTextField.text!,
                          "address":mailingAddressTextField.text ?? "",
                          "city":cityTextField.text ?? "",
                          "zipcode":zipCodeTextField.text ?? "",
                          "dob":dateOfbirthTextField.text ?? ""]
            }
        }
        
        APIManager.manager.updateProfile(params: params) { (status, msg) in
            
            if status{
                
                self.view.makeToast(msg!)
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}

