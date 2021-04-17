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
    
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet var pendingReqCountLabel: UILabel!

  
    
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  self.view.setGradientBackground(colorTop:UIColor.white , colorBottom: UIColor.init(named: "light_blue_transparent")!)
        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "WITHDRAW REQUEST".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        
        amountLabel.text = "Amount in BDT".localized
        tkAmountTextField.placeholder = "Amount in BDT".localized
        bKashNoTextField.placeholder = "Personal bKash phone number".localized
        pendingLabel.text = "Pending Withdraw".localized
        
        sendButton.setTitle("Send Withdraw Request".localized, for: .normal)
        sendButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        
        cashWithdrawLabel.text = "Cash-Withdrawl!".localized
        firstSuggestionlabel.text = "The minimum withdrawal amount is 250 BDT and the maximum amount is 4999 BDT.".localized
        secondSuggestionlabel.text = "Personal Bkash number is needed while withdrawing the money.".localized
        
        self.tabBarController?.tabBar.isHidden = true
        
        if let usermodel = AppSessionManager.shared.currentUser {
           
            if Language.language == Language.english{
                
                self.pendingReqCountLabel.text = String.init(format: "%d",usermodel.metadata?.totalPendingRequest ?? "")
            }else{
                
                self.pendingReqCountLabel.text = String.init(format: "%@", self.formatter.string(from: usermodel.metadata?.totalPendingRequest as NSNumber? ?? 0)!)
                
            }
        }else{
            
        }
        
        
        
        
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
                sendButton.isUserInteractionEnabled = false
                APIManager.manager.postWithdrawRequest(amount: self.tkAmountTextField.text ?? "0", number: self.bKashNoTextField.text ?? "0") { (success, msg) in
                    if(success)
                    {
                        self.view.makeToast(msg!)
                        self.navigationController?.popViewController(animated: true)
                        self.sendButton.isUserInteractionEnabled = false
                        
                    }
                    else{
                        self.view.makeToast( msg!)
                        self.sendButton.isUserInteractionEnabled = false
                    }
                }
            }
        
     
        }
    }
    
    @IBAction func pendingWithdrawButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PendingWithdrawViewController") as? PendingWithdrawViewController
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }

  
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
