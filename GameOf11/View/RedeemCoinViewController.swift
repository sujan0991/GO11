//
//  RedeemCoinViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 24/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

class RedeemCoinViewController: BaseViewController {
    
    
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
        
        placeNavBar(withTitle: "REDEEM COIN".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false)
        redeemButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
        tkToCoinLabel.text = "1 BDT = 50 Coins".localized
        amountLabel.text = "Amount in BDT".localized
        redeemButton.setTitle("Redeem Coins".localized, for: .normal)
        firstSuggestionlabel.text = "Use cash to redeem coins instantly!".localized
        secondSuggestionLabel.text = "The amount in BDT you would mention here will add the equivalent amount of coins in your profile.".localized
        
        self.tabBarController?.tabBar.isHidden = true;
        
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
