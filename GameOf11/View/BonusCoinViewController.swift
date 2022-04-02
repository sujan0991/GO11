//
//  BonusCoinViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 1/4/22.
//  Copyright © 2022 Tanvir Palash. All rights reserved.
//

import UIKit

class BonusCoinViewController : BaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var bonusCoinTableView: UITableView!
    
    var bonusLogArray:[Any] = []
    var bonusListArray:[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        

        
        bonusCoinTableView.delegate = self
        bonusCoinTableView.dataSource = self
        bonusCoinTableView.tableFooterView = UIView()
        
       // getData()

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
    
    func getData(){
        
        var lang = "en"
        
        if Language.language == Language.bangla{
            
            lang = "bn"
            
        }
        
//        APIManager.manager.getCoinLog(lang: lang) { (logArray) in
//
//            if logArray.isEmpty{
//
//
//            }else{
//
//                self.coinLogArray = logArray
//
//                self.transactionTableView.reloadData()
//            }
//        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if UserDefaults.standard.object(forKey: "BonusLogList") as? String == "Bonus Log"{
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"transactionCell") as! TransactionTableViewCell
            
            //        let singleLog = coinLogArray[indexPath.row] as! Dictionary<String,Any>
            //
            //        cell.titleLabel.text = "\(String(describing: singleLog["title"]!))"
            //        cell.detailLabel.text = "\(String(describing: singleLog["description"]!))"
            //        cell.amountLabel.text = "\(String(describing: singleLog["coin"]!))"
            //
            //        let dateFormatter = DateFormatter()
            //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //        dateFormatter.locale = Locale(identifier: "en_US")//without it app crashes in device
            //        let dateFromString :Date = dateFormatter.date(from: ((singleLog["log_time"]! as! String)))!
            //        let sttringFDate = dateFromString.toDateString(format: "MMM d, h:mm a")
            //
            //        cell.dateLabel.text = sttringFDate

                   
                    return cell

        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier:"bonusCoinPackCell") as! BonusCoinTableViewCell
            
           
                   
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if let cell = cell as? TransactionTableViewCell{
//
//            let singleLog = coinLogArray[indexPath.row] as! Dictionary<String,Any>
//
//            if singleLog["transaction_type"] as! String == "credited" {
//
//                cell.amountLabel.textColor = UIColor.init(named: "on_green")!
//                cell.transactionTypeImageView.image = UIImage(named: "plus_icon")
//
//            }else{
//
//                cell.amountLabel.textColor = UIColor.init(named: "Red")!
//                cell.transactionTypeImageView.image = UIImage(named: "minus_icon")
//
//            }
//        }
    }


}
