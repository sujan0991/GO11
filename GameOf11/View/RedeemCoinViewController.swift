//
//  RedeemCoinViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 24/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

class RedeemCoinViewController: BaseViewController {
    
    
    @IBOutlet weak var tkAmountTextField: UITextField!
    @IBOutlet weak var redeemButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "Redeem Coin", isBackBtnVisible: true)
        redeemButton.makeRound(5, borderWidth: 0, borderColor: .clear)
        
    }
    
    @IBAction func redeemButtonAction(_ sender: Any) {
        
        APIManager.manager.redeemCoinForCash(amount: self.tkAmountTextField.text ?? "0") { (success, msg) in
            if(success)
            {
                self.showStatus(true, msg: msg)
                self.navigationController?.popViewController(animated: true)
                
            }
            else{
                self.showStatus(false, msg: msg)
            }
        
        }

    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
  

}
