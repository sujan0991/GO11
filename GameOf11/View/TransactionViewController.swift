//
//  TransactionViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 5/2/20.
//  Copyright © 2020 Tanvir Palash. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var navTitle: UILabel!
    var coinLogArray:[Any] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        navTitle.text = "COINS LOG".localized
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.tableFooterView = UIView()
        
        getData()

    }
    
    
    func getData(){
        
        var lang = "en"
        
        if Language.language == Language.bangla{
            
            lang = "bn"
            
        }
        
        APIManager.manager.getCoinLog(lang: lang) { (logArray) in
            
            if logArray.isEmpty{
                
                
            }else{
                
                self.coinLogArray = logArray
                
                self.transactionTableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return coinLogArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"transactionCell") as! TransactionTableViewCell
        
        let singleLog = coinLogArray[indexPath.row] as! Dictionary<String,Any>
        
        cell.titleLabel.text = "\(String(describing: singleLog["title"]!))"
        cell.detailLabel.text = "\(String(describing: singleLog["description"]!))"
        cell.amountLabel.text = "\(String(describing: singleLog["coin"]!))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")//without it app crashes in device
        let dateFromString :Date = dateFormatter.date(from: ((singleLog["log_time"]! as! String)))!
        let sttringFDate = dateFromString.toDateString(format: "MMM d, h:mm a")
        
        cell.dateLabel.text = sttringFDate

       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? TransactionTableViewCell{
            
            let singleLog = coinLogArray[indexPath.row] as! Dictionary<String,Any>
            
            if singleLog["transaction_type"] as! String == "credited" {
                
                cell.amountLabel.textColor = UIColor.init(named: "GreenHighlight")!
                cell.transactionTypeImageView.image = UIImage(named: "plus_icon")

            }else{
                
                cell.amountLabel.textColor = UIColor.init(named: "Red")!
                cell.transactionTypeImageView.image = UIImage(named: "minus_icon")

            }
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
