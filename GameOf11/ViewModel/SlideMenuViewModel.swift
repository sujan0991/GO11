//
//  SlideMenuViewModel.swift
//  Welltravel
//
//  Created by Amit Sen on 9/1/18.
//  Copyright © 2018 Amit Sen. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate: class {
    func slideMenuItemSelectedAtIndex(_ index: Int)
}

class SlideMenuViewModel: BaseViewModel {

    override init() {
        super.init()
    }
    
    func getMenuItems() -> [MenuItem] {
        return mockDataManager.getMenuItems()
    }
}
