//
//  MyContestViewController.swift
//  GameOf11
//
//  Created by Tanvir Palash on 4/1/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import DTPagerController

class MyContestViewController: BaseViewController,DTSegmentedControlProtocol,DTPagerControllerDelegate {

    var selectedSegmentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeNavBar(withTitle: "My Contest", isBackBtnVisible: false)
        
        // Do any additional setup after loading the view.
        
        placeContainer()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let fixtureVC = storyboard.instantiateViewController(withIdentifier: "MatchViewController") as! MatchViewController
        fixtureVC.title = "Upcoming"
        fixtureVC.type = .upcomingContest
        
        let liveVC = storyboard.instantiateViewController(withIdentifier: "MatchViewController") as! MatchViewController
        liveVC.title = "Live"
        liveVC.type = .liveContest
        
        
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MatchViewController")as! MatchViewController
        resultVC.title = "Completed"
        resultVC.type = .completedContest
        
        
        let pagerController = DTPagerController(viewControllers: [fixtureVC, liveVC,resultVC])
        customizeSegment(pagerController: pagerController)
        
        pagerController.delegate = self
        
        print(containerView)
        addChild(pagerController)
        pagerController.view.frame = containerView.bounds
        print(pagerController.view)
        containerView.addSubview(pagerController.view)
        pagerController.didMove(toParent: self)
    }
    

    func customizeSegment(pagerController: DTPagerController)
    {
        
        pagerController.preferredSegmentedControlHeight = 44
        //   pagerController.font = UIFont.systemFont(ofSize: 15)
        //   pagerController.selectedFont = UIFont.boldSystemFont(ofSize: 15)
        pagerController.textColor = UIColor.white
        pagerController.selectedTextColor = UIColor.white
        
        pagerController.perferredScrollIndicatorHeight = 2
        pagerController.scrollIndicator.layer.cornerRadius = pagerController.scrollIndicator.frame.height/2
        pagerController.scrollIndicator.backgroundColor = UIColor.init(named: "TabOrangeColor")
        pagerController.pageSegmentedControl.backgroundColor = UIColor.init(named: "GreenHighlight")
        
    }
    func setImage(_ image: UIImage?, forSegmentAt segment: Int) {
        // Custom page control does not support
        
    }
    
    func setTitle(_ title: String?, forSegmentAt segment: Int) {
        // Custom page control does not support
        
    }
    func setTitleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State) {
        //
    }
    
    func pagerController(_ pagerController: DTPagerController, didChangeSelectedPageIndex index: Int) {
        print(index)
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
