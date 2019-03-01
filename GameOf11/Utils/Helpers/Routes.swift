//
//  ViewControllerHelper.swift
//  Welltravel
//
//  Created by Amit Sen on 11/17/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation
import UIKit

class Routes {
    
    let mainSB = "Main"
    let launchScreenSB = "LaunchScreen"
    let authentication = "Authentication"
    
    init() {

    }
    // swiftlint:disable line_length
    func gotoSignupPage(from vc: BaseViewController) {
        let signupVC = UIStoryboard(name: self.authentication,
                                         bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        vc.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    // swiftlint:enable line_length
}
