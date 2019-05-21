//
//  DepositCoinViewController.swift
//  DropDown
//
//  Created by MacBook Pro Retina on 2/19/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit
import SafariServices

class DepositCoinViewController: BaseViewController,SFSafariViewControllerDelegate {
    
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
        
        if tkAmountLabel.text?.count != 0{
            
            let tkAmount = (tkAmountLabel.text! as NSString).floatValue
            
            APIManager.manager.getInvoice(amount: tkAmount) { (status, id,url,msg) in
                
                print("getInvoice msg",msg!)
                
                if status{
                    self.showStatus(status, msg: msg)
                    
                    print("getInvoice id",id ?? "??",url!)
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BkashPaymentViewController") as? BkashPaymentViewController
                    
                    vc?.urlString = url!
                    
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                }
                else{
                    self.showStatus(false, msg: msg)
                }
                
            }

        }
        
    }
    

}
