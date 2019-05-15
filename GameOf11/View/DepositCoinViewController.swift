//
//  DepositCoinViewController.swift
//  DropDown
//
//  Created by MacBook Pro Retina on 2/19/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

class DepositCoinViewController: BaseViewController {
    
    @IBOutlet weak var tkAmountLabel: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        placeNavBar(withTitle: "Add Coins", isBackBtnVisible: true)
        
        tkAmountLabel.becomeFirstResponder()
        
    }


    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addCoinButtonAction(_ sender: Any) {
        
        
    }
    

}
