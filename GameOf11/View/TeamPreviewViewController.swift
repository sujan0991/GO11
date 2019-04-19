//
//  TeamPreviewViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 27/2/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class TeamPreviewViewController: BaseViewController {

    @IBOutlet weak var previewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
         placeNavBar(withTitle: "Team Preview", isBackBtnVisible: true)
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
