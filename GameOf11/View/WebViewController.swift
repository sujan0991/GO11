//
//  WebViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 27/8/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navTitleLabel.text = "TEAM SELECT & SCORING".localized
        
      //  let urlString = "\(API_K.BaseUrlStr)team-select-and-scoring-system"
        var urlString = ""
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            urlString = "https://www.gameof11.com/team-select-and-scoring-system"
            
        }else{
            urlString = "https://www.gameof11.com/football/point-system"
            
            
        }
        
        print("urlString.........",urlString)
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
    }
    

    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
