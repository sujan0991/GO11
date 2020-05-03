//
//  WithdrawRequestViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 24/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

class WithdrawRequestViewController: BaseViewController {

    
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tkAmountTextField: UITextField!
    @IBOutlet weak var bKashNoTextField: UITextField!
    @IBOutlet weak var confirmBkashNoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var cashWithdrawLabel: UILabel!
    @IBOutlet weak var firstSuggestionlabel: UILabel!
    @IBOutlet weak var secondSuggestionlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  self.view.setGradientBackground(colorTop:UIColor.white , colorBottom: UIColor.init(named: "light_blue_transparent")!)
        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "WITHDRAW REQUEST".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        amountLabel.text = "Amount in BDT".localized
        tkAmountTextField.placeholder = "Amount in BDT".localized
        bKashNoTextField.placeholder = "Personal bKash phone number".localized
        
        sendButton.setTitle("Send Withdraw Request".localized, for: .normal)
        
        cashWithdrawLabel.text = "Cash-Withdrawl!".localized
        firstSuggestionlabel.text = "The minimum withdrawal amount is 250 BDT and the maximum amount is 4999 BDT.".localized
        secondSuggestionlabel.text = "Personal Bkash number is needed while withdrawing the money. You may provide it later when GO11 team contact you regarding the withdrawal process.".localized
        
        self.tabBarController?.tabBar.isHidden = true
        
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
   
    @IBAction func sendRequestButtonAction(_ sender: Any) {
        
        if tkAmountTextField.text?.count != 0 && bKashNoTextField.text?.count != 0 && confirmBkashNoTextField.text?.count != 0{
            
            if  bKashNoTextField.text != confirmBkashNoTextField.text{
                
                self.view.makeToast( "Given bKash numbers are not same!")
                
            }else{
                
                APIManager.manager.postWithdrawRequest(amount: self.tkAmountTextField.text ?? "0", number: self.bKashNoTextField.text ?? "0") { (success, msg) in
                    if(success)
                    {
                        self.view.makeToast(msg!)
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    else{
                        self.view.makeToast( msg!)
                    }
                }
            }
        
     
        }
    }
    
  
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
