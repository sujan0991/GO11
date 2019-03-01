//
//  RedeemCoinViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 24/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

class RedeemCoinViewController: UIViewController {
    
    
    @IBOutlet weak var tkAmountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
  

}
