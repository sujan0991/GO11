//
//  RedeemCoinViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 24/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

class RedeemCoinViewController: BaseViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var tkToCoinLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tkAmountTextField: UITextField!
    @IBOutlet weak var redeemButton: UIButton!
    
    @IBOutlet weak var firstSuggestionlabel: UILabel!
    @IBOutlet weak var secondSuggestionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.view.setGradientBackground(colorTop:UIColor.white , colorBottom: UIColor.init(named: "light_blue_transparent")!)
        
        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "REDEEM COIN".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        redeemButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        tkToCoinLabel.text = "1 BDT = 50 Coins".localized
        amountLabel.text = "Amount in BDT".localized
        redeemButton.setTitle("Redeem Coins".localized, for: .normal)
        firstSuggestionlabel.text = "Use cash to redeem coins instantly!".localized
        secondSuggestionLabel.text = "The amount in BDT you would mention here will add the equivalent amount of coins in your profile.".localized
        
        self.tabBarController?.tabBar.isHidden = true;
        self.tkAmountTextField.delegate = self
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxAmount = UserDefaults.standard.value(forKey: "maxRechargeAmount") as! Int
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if newText.isEmpty {
            return true
        }
        else if let intValue = Int(newText), intValue <= maxAmount {
            return true
        }
        else {
            self.view.makeToast("Maximum limit is \(maxAmount)")
        }
        return false
    }
    
    @IBAction func redeemButtonAction(_ sender: Any) {
       
        if tkAmountTextField.text?.count != 0 { APIManager.manager.redeemCoinForCash(amount: self.tkAmountTextField.text ?? "0") { (success, msg) in
            if(success)
            {
                self.view.makeToast( msg!)
                self.navigationController?.popViewController(animated: true)
                
            }
            else{
                self.view.makeToast(msg!)
            }
            
            }
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
