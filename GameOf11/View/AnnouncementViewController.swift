//
//  AnnouncementViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 4/2/20.
//  Copyright © 2020 Tanvir Palash. All rights reserved.
//

import UIKit
import WebKit

class AnnouncementViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var announcementTableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var navTitle: UILabel!
    var announcementArray:[Any] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
        navTitle.text = "ANNOUNCEMENTS".localized
        
        announcementTableView.delegate = self
        announcementTableView.dataSource = self
        announcementTableView.tableFooterView = UIView()

       
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        shadowView.addGestureRecognizer(tap)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return announcementArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"announcementCell") as! AnnouncementTableViewCell
        
        let singleAnnouncement = announcementArray[indexPath.row] as! Dictionary<String,Any>
        
        cell.titleLabel.text = "\(String(describing: singleAnnouncement["title"]!))"
        cell.detailLabel.text = "\(String(describing: singleAnnouncement["short_description"]!))"
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")//without it app crashes in device
        let dateFromString :Date = dateFormatter.date(from: ((singleAnnouncement["created_at"]! as! String)))!
        
        let sttringFDate = dateFromString.toDateString(format: "yyyy-MM-dd HH:mm:ss")
        
        cell.dateLabel.text = sttringFDate.getElapsedInterval()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let singleAnnouncement = announcementArray[indexPath.row] as! Dictionary<String,Any>
        
        titleLabel.text = "\(String(describing: singleAnnouncement["title"]!))"
        
        let htmlString = singleAnnouncement["description"]! as! String
        print("..................",htmlString.htmlToAttributedString!)
        
        detailLabel.attributedText = htmlString.htmlToAttributedString
        
       // detailLabel.text = htmlString
       
       // detailViewHeight.constant = detailLabel.frame.height + 50
        
        self.detailView.isHidden = false
        self.shadowView.isHidden = false
        self.detailView.frame = CGRect(x: 0, y:self.view.frame.height, width: self.detailView.frame.width, height: self.detailView.frame.height)
        
        let bottonSpace = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 1.0
        
        
        UIView.animate(withDuration:0.2, animations: {
            
            
            self.detailView.frame = CGRect(x: 0, y:self.view.frame.height - self.detailView.frame.height - bottonSpace, width: self.detailView.frame.width, height: self.detailView.frame.height)
            
        }) { _ in
            
            
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        shadowView.isHidden = true
        detailView.isHidden = true
        
    }

    @IBAction func backButtonAction(_ sender: Any) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.popViewController(animated: true)
    }
    
    

}

