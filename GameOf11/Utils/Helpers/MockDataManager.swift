//
//  MockData.swift
//  Welltravel
//
//  Created by Amit Sen on 11/17/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation
import UIKit

class MockDataManager {
    private var menuItems: [MenuItem]!
    
    // swiftlint:disable function_body_length
    init() {
        menuItems = [
//            MenuItem(withIcon: UIImage(named: "my_bookings")!,
//                     andName: "My Bookings")
        ]
    }
    // swiftlint:enable function_body_length

    func getMenuItems() -> [MenuItem] {
        return menuItems
    }
}
