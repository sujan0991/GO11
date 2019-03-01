//
//  SlideMenuViewController.swift
//  Welltravel
//
//  Created by Amit Sen on 9/1/18.
//  Copyright © 2018 Amit Sen. All rights reserved.
//

import UIKit

class SlideMenuViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var childViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuViewHeight: NSLayoutConstraint!
    @IBOutlet weak var closeMenuBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    // public variables
    weak var delegate: SlideMenuDelegate!
    let viewModel = SlideMenuViewModel.init()
    var menuBtn: UIButton!
    
    // private variables
    
    //Overridden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        scrollView.backgroundColor = viewModel.colors.mainMenuBg
//        profileView.backgroundColor = viewModel.colors.buttonBg
//        nameLabel.textColor = viewModel.colors.buttonText
//        emailLabel.textColor = viewModel.colors.mainMenuBg
        mainView.setShade()
        addMenuItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    @IBAction func closeMenuBtnPressed(_ sender: UIButton) {
        menuBtn.tag = 0
        
        if self.delegate != nil {
            var index = Int(sender.tag)
            if sender == self.closeMenuBtn {
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -self.viewModel.uiHelper.getScreenWidth(), 
                                     y: 0, 
                                     width: self.viewModel.uiHelper.getScreenWidth(),
                                     height: self.viewModel.uiHelper.getScreenHeight())
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (_) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    @IBAction func editProfileBtnPressed(_ sender: UIButton) {
        sender.tag = 0
        
        closeMenuBtnPressed(sender)
    }
    
    // public methods
    
    // private methods
    func addMenuItems() {
        let verticalGap: CGFloat = 8.0
        let xOrigin: CGFloat = 0.0
        var yOrigin: CGFloat = 0.0
        let width: CGFloat = menuView.frame.width
        let height: CGFloat = 50.0
        
        increaseHeights(byHeight: CGFloat(viewModel.getMenuItems().count) * (height + verticalGap))
        
        var count: Int = 1
        
        for menuItem in viewModel.getMenuItems() {
            let menuItemRow = SlideMenuItemView(frame: CGRect(x: xOrigin, y: yOrigin, width: width, height: height))
            menuItemRow.setShade()
            
            menuItemRow.btn.tag = count
            
            menuItemRow.setData(icon: menuItem.icon, title: menuItem.name, onBtnPressed: { (btn) in
                print(menuItem.name)
                print("btn tag: \(btn.tag)")
                self.closeMenuBtnPressed(btn)
            })
            
            menuView.addSubview(menuItemRow)
            yOrigin += (height + verticalGap)
            
            count += 1
        }
    }
    
    private func increaseHeights(byHeight height: CGFloat) {
        menuViewHeight.constant += height
        childViewHeight.constant += height
        
        scrollView.contentSize = CGSize(width: viewModel.uiHelper.getScreenWidth(), height: childViewHeight.constant)
    }
    
    // delegates
}
