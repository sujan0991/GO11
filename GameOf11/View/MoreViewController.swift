//
//  MoreViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 18/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit
import SafariServices

class MoreViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var topLogoImageView: UIImageView!
    
    @IBOutlet weak var moretableView: UITableView!
    
    var menuArray = [Dictionary<String,Any>]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        moretableView.delegate = self
        moretableView.dataSource = self
        
        placeNavBar(withTitle: "More", isBackBtnVisible: false)
        
        
        menuArray.append(["title":"How to Play", "icon":"how_to_play_icon"])
        menuArray.append(["title":"FAQs", "icon":"faq_icon"])
        menuArray.append(["title":"Terms & Conditions", "icon":"terms_icon"])
        menuArray.append(["title":"Privacy Policy", "icon":"privacy_icon"])
        menuArray.append(["title":"About Us", "icon":"about_us_icon"])
        menuArray.append(["title":"Watch How To Play", "icon":"play_icon"])
        
        
        moretableView.tableFooterView = UIView()
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
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
            
            urlString = "https://www.gameof11.com/how-to-play"
            
        }else if(indexPath.row == 1){
            
            urlString = "https://www.gameof11.com/faq"
        }else if(indexPath.row == 2){
            
            urlString = "https://www.gameof11.com/terms-and-conditions"
        }else if(indexPath.row == 3){
            
            urlString = "https://www.gameof11.com/privacy-policy"
        }else if(indexPath.row == 4){
            
            urlString = "https://www.gameof11.com/about-us"
        }else if(indexPath.row == 5){
            
            urlString = "https://youtu.be/OJMbQ-BpEWM"
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
