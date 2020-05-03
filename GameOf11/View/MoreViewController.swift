//
//  MoreViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 18/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit
import SafariServices

class MoreViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,SFSafariViewControllerDelegate {
    
    
    
    @IBOutlet weak var topLogoImageView: UIImageView!
    
    @IBOutlet weak var moretableView: UITableView!
    
    
    var menuArray = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        moretableView.delegate = self
        moretableView.dataSource = self
        
        placeNavBar(withTitle: "MORE".localized, isBackBtnVisible: false,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        

        
        menuArray.append(["title":"How to Play".localized, "icon":"how_to_play_icon"])
        menuArray.append(["title":"FAQs".localized, "icon":"faq_icon"])
        menuArray.append(["title":"Team Select & Scoring".localized, "icon":"scoring"])
        menuArray.append(["title":"Terms & Conditions".localized, "icon":"terms_icon"])
        menuArray.append(["title":"Privacy Policy".localized, "icon":"privacy_icon"])
        menuArray.append(["title":"About Us".localized, "icon":"about_us_icon"])
        menuArray.append(["title":"Watch How To Play".localized, "icon":"play_icon"])
        menuArray.append(["title":"Write Your Feedback".localized, "icon":"feedback"])
        menuArray.append(["title":"Promo Code".localized, "icon":"promotion"])
        menuArray.append(["title":"Setting".localized, "icon":"language_change_icon"])
        //"Change Language"
        moretableView.tableFooterView = UIView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
  
            
            if #available(iOS 13, *) {
                      if UserDefaults.standard.bool(forKey: "DarkMode"){
                          
                          overrideUserInterfaceStyle = .dark
                          self.tabBarController?.tabBar.backgroundColor = UIColor.init(named: "tab_dark_bg")
                          self.tabBarController?.tabBar.unselectedItemTintColor = .white

                      }else{
                          overrideUserInterfaceStyle = .light
                          self.tabBarController?.tabBar.backgroundColor = .white
                          self.tabBarController?.tabBar.unselectedItemTintColor = .gray

                      }
                  
                  }else{
                      
                  }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "moreCell"
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        
        let titlelabel:UILabel = cell.viewWithTag(502) as! UILabel
        
        titlelabel.text = menuArray[indexPath.row]["title"]! as? String
        //cell.imageView?.backgroundColor = UIColor.blue
        let imageView:UIImageView = cell.viewWithTag(501) as! UIImageView
        
        imageView.image = UIImage(named: menuArray[indexPath.item]["icon"]! as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var urlString = ""
        
        if indexPath.row == 0 {
            
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                urlString = "https://www.gameof11.com/how-to-play"
            }else{
                urlString = "https://www.gameof11.com/football/how-to-play"
            }
            
        }else if(indexPath.row == 1){
            
            urlString = "https://www.gameof11.com/faq"
            
        }else if(indexPath.row == 2){
            
            //            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
            //            
            //            self.navigationController?.pushViewController(popupVC ?? self, animated: true)
            if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
                
                urlString = "https://www.gameof11.com/team-select-and-scoring-system"
                
            }else{
                urlString = "https://www.gameof11.com/football/point-system"
                
                
            }
            
            
        }else if(indexPath.row == 3){
            urlString = "https://www.gameof11.com/terms-and-conditions"
            
        }else if(indexPath.row == 4){
            urlString = "https://www.gameof11.com/privacy-policy"
            
        }else if(indexPath.row == 5){
            urlString = "https://www.gameof11.com/about-us"
            
        }else if(indexPath.row == 6){
            
            urlString = "https://youtu.be/OJMbQ-BpEWM"
            
        }else if(indexPath.row == 7){
            
            if AppSessionManager.shared.authToken != nil {
                
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as? FeedbackViewController
                
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }else{
                
                let alertVC = UIAlertController(title: nil, message: "You have to login to use this feature".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (aciton) in
                    
                    // self.dismiss(animated: true, completion: nil)
                    
                    // self.teamNameTextField.resignFirstResponder()
                })
                
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
                
            }
            
            
        }else if(indexPath.row == 8){
            
            if AppSessionManager.shared.authToken != nil {
                
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PromoCodeViewController") as? PromoCodeViewController
                
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
                
                let alertVC = UIAlertController(title: nil, message: "You have to login to use this feature".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (aciton) in
                    
                    // self.dismiss(animated: true, completion: nil)
                    
                    // self.teamNameTextField.resignFirstResponder()
                })
                
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
                
            }
            
        }else if(indexPath.row == 9){
            
             let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController
            
             self.navigationController?.pushViewController(vc!, animated: true)

            
        }
        
        print("urlString",urlString)
        
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
        
    }
  
    
    
    
}
