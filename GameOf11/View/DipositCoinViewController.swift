//
//  DipositCoinViewController.swift
//  DropDown
//
//  Created by MacBook Pro Retina on 2/19/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

class DipositCoinViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var tkAmountLabel: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tkAmountLabel.delegate = self
        
        tkAmountLabel.becomeFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tkAmountLabel.resignFirstResponder()
        return true
    }

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addCoinButtonAction(_ sender: Any) {
        
        
    }
    

}
