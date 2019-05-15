//
//  WithdrawRequestViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 24/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

class WithdrawRequestViewController: BaseViewController {

    
    
    @IBOutlet weak var tkAmountTextField: UITextField!
    @IBOutlet weak var bKashNoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        placeNavBar(withTitle: "Withdraw Request", isBackBtnVisible: true)
        
    }
    

   
    @IBAction func sendRequestButtonAction(_ sender: Any) {
        
        APIManager.manager.postWithdrawRequest(amount: self.tkAmountTextField.text ?? "0", number: self.bKashNoTextField.text ?? "0") { (success, msg) in
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
