//
//  Alert.swift
//  Welltravel
//
//  Created by Amit Sen on 11/17/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation
import NotificationBannerSwift


class Alert {
    init() {
    }

    func showSuccessBanner(title: String, subTitle: String, onClick callback: @escaping(NotificationBanner) -> Void) {
        DispatchQueue.main.async {
            let banner = NotificationBanner(title: title, subtitle: subTitle, style: .success)
            banner.onTap = {
                callback(banner)
            }
            banner.show()
        }
    }

    func showErrorBanner(title: String, subTitle: String) {
        DispatchQueue.main.async {
            let banner = NotificationBanner(title: title, subtitle: subTitle, style: .danger)
            banner.show()
        }
    }

    func showInfoBanner(title: String, subTitle: String, onClick callback: @escaping(NotificationBanner) -> Void) {
        DispatchQueue.main.async {
            let banner = NotificationBanner(title: title, subtitle: subTitle, style: .info)
            banner.onTap = {
                callback(banner)
            }
            banner.show()
        }
    }

    func showWarningBanner(title: String, subTitle: String) {
        DispatchQueue.main.async {
            let banner = NotificationBanner(title: title, subtitle: subTitle, style: .warning)
            banner.show()
        }
    }
    
    func showSimpleAlert(title: String, message: String, btnTitle: String, onBtnClicked clicked: @escaping() -> Void) {
        DispatchQueue.main.async {
//            EZAlertController.alert(title, message: message, buttons: [btnTitle]) { (_, _) in
//                clicked()
//            }
        }
    }
}
