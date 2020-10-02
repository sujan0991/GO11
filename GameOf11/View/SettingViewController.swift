//
//  SettingViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 31/3/20.
//  Copyright © 2020 Tanvir Palash. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var settingTableView: UITableView!
    
    @IBOutlet weak var changeLanguageLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var banglaButton: UIButton!
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var languageView: UIView!
    
    
     var menuArray = [Dictionary<String,Any>]()
     var isNotiON = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        placeNavBar(withTitle: "SETTINGS".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        self.tabBarController?.tabBar.isHidden = true
              
        
        //check noti status
        if #available(iOS 10.0, *) {
           let current = UNUserNotificationCenter.current()
           current.getNotificationSettings(completionHandler: { settings in

                switch settings.authorizationStatus {
                    case .notDetermined:
                        print("Authorization request has not been made yet")
                    case .denied:
                        // You could tell them to change this in Settings
                        print("User has denied authorization.")
                        self.isNotiON = false
                    case .authorized:
                        print("User has given authorization.")
                        self.isNotiON = true
                    case .provisional:
                        print("provisional.")
                default : break
                }
           })
        }


        changeLanguageLabel.text = "Change Language".localized
        
        if Language.language == Language.bangla{
            
            banglaButton.setTitleColor(UIColor.white, for: .normal)
            banglaButton.backgroundColor = UIColor.init(named: "on_green")!
            
            englishButton.backgroundColor = UIColor.white
            englishButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
        }else{
            banglaButton.backgroundColor = UIColor.white
            banglaButton.setTitleColor(UIColor.init(named: "DefaultTextColor")!, for: .normal)
            
            englishButton.backgroundColor = UIColor.init(named: "on_green")!
            englishButton.setTitleColor(UIColor.white, for: .normal)
            
        }
        englishButton.layer.borderWidth = 0.5
        englishButton.layer.borderColor = UIColor.lightGray.cgColor
        banglaButton.layer.borderWidth = 0.5
        banglaButton.layer.borderColor = UIColor.lightGray.cgColor
        
        if #available(iOS 13, *) {
            
            menuArray.append(["title":"Change Language".localized, "icon":"language_change_icon"])
       //     menuArray.append(["title":"Notification".localized, "icon":"language_change_icon"])
            menuArray.append(["title":"Dark Mode".localized, "icon":"night_mode"])
             
        }else{
            
            menuArray.append(["title":"Change Language".localized, "icon":"language_change_icon"])
        //    menuArray.append(["title":"Notification".localized, "icon":"language_change_icon"])
             
        }
        
        settingTableView.tableFooterView = UIView()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        shadowView.addGestureRecognizer(tap)

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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
           
           shadowView.isHidden = true
           languageView.isHidden = true
       }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           return menuArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier:"settingCell") as! SettingTableViewCell
           
            
           cell.titleLabel.text = menuArray[indexPath.row]["title"]! as? String
          
           cell.cellImageView.image = UIImage(named: menuArray[indexPath.item]["icon"]! as! String)
        
        if indexPath.row == 0{
            
            cell.settingSwitch.isHidden = true
        }
//        else if indexPath.row == 1{
//
//            if isNotiON{
//
//                cell.settingSwitch.isOn = true
//            }else{
//                cell.settingSwitch.isOn = false
//            }
//
//        }
        else if indexPath.row == 1{
            
             if UserDefaults.standard.bool(forKey: "DarkMode"){
                               
                cell.settingSwitch.isOn = true
            }else{
                cell.settingSwitch.isOn = false
            }
        }

        
        
        cell.settingSwitch.tag = indexPath.row
        cell.settingSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .touchUpInside)
           
           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
        
           
           if indexPath.row == 0 {
               
             shadowView.isHidden = false
             languageView.isHidden = false
               
           }
    
           
       }
    
    @objc func switchAction(sender: UISwitch){
        let switchTag = sender.tag
        
        print("switch tag", switchTag)
//        if sender.tag == 1{
//            if sender.isOn{
//
//                print("noti on")
//
//            }else{
//                print("noti on")
//            }
//
//
//        }

        if sender.tag == 1{
        if #available(iOS 13, *) {
            if sender.isOn{

                print("dark mode is on")
                UserDefaults.standard.set(true, forKey: "DarkMode")
                overrideUserInterfaceStyle = .dark

            }else{
                UserDefaults.standard.set(false, forKey: "DarkMode")
                overrideUserInterfaceStyle = .light
            }

        }else{

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
