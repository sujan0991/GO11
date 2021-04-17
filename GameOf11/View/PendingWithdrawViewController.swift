//
//  PendingWithdrawViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 27/8/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class PendingWithdrawViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var noRequestView: UIView!
    
    @IBOutlet weak var requestTableView: UITableView!
    @IBOutlet weak var navTitle: UILabel!
    
    
    var withdrawListArray : [Any] = []
    var username = AppSessionManager.shared.currentUser?.name
    
    var page_no = 1
    var total_page_no : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        //        self.view.setGradientBackground(colorTop:UIColor.white , colorBottom: UIColor("#66dcff").withAlphaComponent(0.30))
        
        requestTableView.delegate = self
        requestTableView.dataSource = self
        requestTableView.tableFooterView = UIView()
        
        self.requestTableView.isHidden = true
        self.noRequestView.isHidden = true
        
       getCompletedWithdraw(pageNo: page_no)
    }
    
    func getCompletedWithdraw(pageNo:Int){
    
        let p_no:String = String(describing: page_no)

        APIManager.manager.getWithdrawList(page_no: p_no) { (status, dataList, msg, pageCount) in
            
            if status{
                
                if self.page_no == 1{
                    
                    self.total_page_no = pageCount
                    
                    self.withdrawListArray = dataList
                    
                    print("self.withdrawListArray.........",self.withdrawListArray)
                    
                    if self.withdrawListArray.count == 0{
                        
                        self.requestTableView.isHidden = true
                        self.noRequestView.isHidden = false
                    }else{
                        
                        self.noRequestView.isHidden = true
                        self.requestTableView.isHidden = false
                        self.requestTableView.reloadData()
                        
                    }

                    
                }else{
                    
                    self.withdrawListArray.append(contentsOf: dataList)
                }
                
                                
            }else{
                self.requestTableView.isHidden = true
                self.noRequestView.isHidden = false
                
            }
            
        }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return withdrawListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"withdrawCell") as! WithdrawTableViewCell
        
        let singleRequest = withdrawListArray[indexPath.row] as! Dictionary<String,Any>
        
        // cell.oldpackLabel.text = "\(String(describing: singlePack["actual_amount"]!)) BDT"
        
        
        cell.nameLabel.text = username
        
        if singleRequest["status"] as! String == "pending" {
            
            cell.statusLabel.text = "\(String(describing: singleRequest["status"]!))".uppercased()
            cell.referenceLabel.text = "Ref ID: Processing"
            
        }else{
            
            cell.statusLabel.text = "APPROVED"
            cell.referenceLabel.text = "Ref ID: \(String(describing: singleRequest["reference"]!))"
        }
        
        cell.transnumberLabel.text = "Trans Num: \(String(describing: singleRequest["transaction_number"]!))"
        cell.transIdLabel.text = "Trans ID: \(String(describing: singleRequest["id"]!))"
        cell.amountLabel.text = "- ৳\(String(describing: singleRequest["amount"]!))"
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")//without it app crashes in device
        let dateFromString :Date = dateFormatter.date(from: ((singleRequest["created_at"]! as! String)))!
        let sttringFDate = dateFromString.toDateString(format: "dd/MM/yyyy")
        
        cell.dateLabel.text = sttringFDate
        
        if indexPath.row == (withdrawListArray.count) - 3 {
            
           
            if total_page_no > page_no { // more items to fetch
                
                
                page_no = page_no + 1
                
                getCompletedWithdraw(pageNo: page_no)
                
            }else{
                
             //   showMoreButton.isHidden = false
                
            }
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell = cell as? WithdrawTableViewCell{
            
            let singleRequest = withdrawListArray[indexPath.row] as! Dictionary<String,Any>
            
            
            if singleRequest["status"] as! String == "pending" {
                
                cell.statusLabel.textColor = UIColor.init(named: "brand_orange")!
                cell.amountLabel.textColor = UIColor.init(named: "brand_orange")!
                cell.statusImageView.image = UIImage(named: "pending_icon")
            }else{
                
                cell.statusLabel.textColor = UIColor.init(named: "on_green")!
                cell.amountLabel.textColor = UIColor.init(named: "on_green")!
                cell.statusImageView.image = UIImage(named: "team_select_icon")
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}
