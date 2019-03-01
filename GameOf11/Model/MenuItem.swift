//
//  MenuItem.swift
//  Welltravel
//
//  Created by Amit Sen on 10/1/18.
//  Copyright © 2018 Amit Sen. All rights reserved.
//

import Foundation
import UIKit

class MenuItem {
    var icon: UIImage!
    var name: String!
    
    init(withIcon icon: UIImage, andName name: String) {
        self.icon = icon
        self.name = name
    }
}
