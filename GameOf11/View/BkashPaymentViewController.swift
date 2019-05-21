//
//  BkashPaymentViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 21/5/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import WebKit

class BkashPaymentViewController: BaseViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeNavBar(withTitle: "Add Coins", isBackBtnVisible: true)
        

        self.tabBarController?.tabBar.isHidden = true;
        
        print("url string",urlString)
        
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
