//
//  SplashViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if AppSessionManager.shared.authToken != nil{
            APIManager.manager.getMyProfile { (status, um, msg) in
                if status{
                    if let u = um{
                        AppSessionManager.shared.currentUser = u
                        AppSessionManager.shared.save()
                        // self.fill(u)
                    }
                }
                else{
                    self.showStatus(status, msg: msg)
                }
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            }
            
        }
        else
        {
            //auth
            // self.performSegue(withIdentifier: "authSegue", sender: self)
            self.performSegue(withIdentifier: "homeSegue", sender: self)
            
        }
        
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
