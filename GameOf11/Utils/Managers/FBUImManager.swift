//
//  FBUImManager.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 1/9/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit
import AccountKit

class FBUImManager: NSObject,AKFUIManager {
    
    
    func actionBarView(for state: AKFLoginFlowState) -> UIView? {
        
        let view = self.actionBarView(for: state)
        
        return view
    }

}
