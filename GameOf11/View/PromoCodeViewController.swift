//
//  PromoCodeViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 2/2/20.
//  Copyright © 2020 Tanvir Palash. All rights reserved.
//

import UIKit

class PromoCodeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var promoTableView: UITableView!
    @IBOutlet weak var promoTextView: UITextField!
    @IBOutlet weak var AppliedCodeLabel: UILabel!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    
    var detailString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        navTitle.text = "PROMO CODE".localized
        promoTextView.placeholder = "Write your promo code".localized
        applyButton.setTitle("Apply Promo Code".localized, for: .normal)
        
        promoTableView.delegate = self
        promoTableView.dataSource = self
        promoTableView.tableFooterView = UIView()
        
        AppliedCodeLabel.isHidden = true
        promoTableView.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"promoCell") as! PromoCodeTableViewCell
        
        cell.titleLabel.text = promoTextView.text!
        cell.detailLabel.text = detailString
        
        return cell
        
    }
    
    
    @IBAction func applyButtonAction(_ sender: Any) {
        
        promoTextView.resignFirstResponder()
        if promoTextView.text?.count != 0{
            
            APIManager.manager.postPromo(promo: promoTextView.text!) { (status, msg) in
                
                self.detailString = msg!
                self.promoTableView.reloadData()
                self.promoTableView.isHidden = false
                self.AppliedCodeLabel.isHidden = false
            }
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
