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
    
    @IBOutlet weak var changeLanguageLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var banglaButton: UIButton!
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var languageView: UIView!
    
    var menuArray = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        moretableView.delegate = self
        moretableView.dataSource = self
        
        placeNavBar(withTitle: "MORE".localized, isBackBtnVisible: false,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        changeLanguageLabel.text = "Change Language".localized
        
        if Language.language == Language.bangla{
            
            banglaButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
            banglaButton.backgroundColor = UIColor.init(named: "GreenHighlight")!
            
            englishButton.backgroundColor = UIColor.white
            englishButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
        }else{
            banglaButton.backgroundColor = UIColor.white
            banglaButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
            
            englishButton.backgroundColor = UIColor.init(named: "GreenHighlight")!
            englishButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
            
        }
        englishButton.layer.borderWidth = 0.5
        englishButton.layer.borderColor = UIColor.lightGray.cgColor
        banglaButton.layer.borderWidth = 0.5
        banglaButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        
        menuArray.append(["title":"How to Play".localized, "icon":"how_to_play_icon"])
        menuArray.append(["title":"FAQs".localized, "icon":"faq_icon"])
        menuArray.append(["title":"Team Select & Scoring".localized, "icon":"scoring"])
        menuArray.append(["title":"Terms & Conditions".localized, "icon":"terms_icon"])
        menuArray.append(["title":"Privacy Policy".localized, "icon":"privacy_icon"])
        menuArray.append(["title":"About Us".localized, "icon":"about_us_icon"])
        menuArray.append(["title":"Watch How To Play".localized, "icon":"play_icon"])
        menuArray.append(["title":"Write Your Feedback".localized, "icon":"feedback"])
        menuArray.append(["title":"Promo Code".localized, "icon":"promotion"])
        menuArray.append(["title":"Change Language".localized, "icon":"language_change_icon"])
        
        moretableView.tableFooterView = UIView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        shadowView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        shadowView.isHidden = true
        languageView.isHidden = true
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
            
            shadowView.isHidden = false
            languageView.isHidden = false
            
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
    
    @IBAction func englishButtonAction(_ sender: Any) {
        
        Language.language = Language.english
    }
    
    @IBAction func banglaButtonAction(_ sender: Any) {
        
        print("bangla.........")
        Language.language = Language.bangla
    }
    
    @objc func languageChangeAction(_ notification: NSNotification) {
        
        print("baseLanguageButtonAction")
        if let currentVC = UIApplication.topViewController() as? MoreViewController {
            
            shadowView.isHidden = false
            languageView.isHidden = false
            
        }
        
    }
    
    
    
}
