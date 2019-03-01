//
//  Vivid.swift
//  Welltravel
//
//  Created by Amit Sen on 11/17/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation
import UIKit

class Vivid {
    
    init() {
    }
    
    func callNumber(phoneNumber: String) {
        guard let number = URL(string: "tel://" + phoneNumber.removingWhitespaces()) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
}
