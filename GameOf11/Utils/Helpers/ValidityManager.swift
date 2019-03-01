//
//  ValidityManager.swift
//  Welltravel
//
//  Created by Amit Sen on 11/17/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation

class ValidityManager {
    
    init() {
        
    }
    
    func isValidEmail(emailString email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", App.sharedInstance.regex.email)
        
        return emailPredicate.evaluate(with: email)
    }
    
    func matches(for regex: String, in text: String) -> Bool {
        
        if text.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil {
            return true
        }
        
        return false
    }
}
