//
//  CustomNavigationBar.swift
//  Welltravel
//
//  Created by Amit Sen on 13/12/17.
//  Copyright © 2017 Amit Sen. All rights reserved.
//

import UIKit
import Bond

protocol NavigationBarDelegate: class {
    func backButtonAction()
}

class CustomNavigationBar: UIView {
    
    
    
    
    weak var delegate: NavigationBarDelegate?

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
 //   let viewModel = CustomNavigationBarViewModel.init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    // private methods

    private func customInit() {
        Bundle.main.loadNibNamed("CustomNavigationBar", owner: self, options: nil)
//        containerView.backgroundColor = viewModel.colors.navBarBg
//        headerLabel.textColor = viewModel.colors.navBarText
        self.addSubview(containerView)
        containerView.frame = self.bounds
    }

    // public methods
    public func activateBtn(navBarTitle: String,
                            isBackBtnVisible visible: Bool,
                            onBtnPressed callback: @escaping(UIButton) -> Void) {
        headerLabel.text = navBarTitle
        
        if navBarTitle.count == 0
        {
            logoImageView.isHidden = false
        }
        else
        {
            logoImageView.isHidden = true
        }
        if visible {
            backBtn.isHidden = false
            _ = backBtn.reactive.tap.observeNext {
                callback(self.backBtn)
            }
        } else {
            backBtn.isHidden = true
            
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
       
        delegate?.backButtonAction()
        
    }
    
}
