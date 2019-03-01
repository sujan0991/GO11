//
//  Constants.swift
//  Welltravel
//
//  Created by Amit Sen on 11/11/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    // List all the texts here
    struct Texts {
        let ok = "OK"
        let cancel = "Cancel"
        let done = "Done"
        let email = "Email"
        let password = "Password"
        let error = "Error"
        let dataNotFound = "Data not found"
        let name = "Name"
        let confirmPassword = "Confirm Password"
        let gender = "Gender"
        let birthdate = "Birthdate"
        let nationality = "Nationality"
        let mobile = "Mobile No"
        let address = "Address"
        let authorization = "Authorization"
    }
    
    // List all the colors here
    struct Color {
        let map_gradient = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.8)
        let red_marker = UIColor.red
        let textfield_border = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1)
        let go_btn = UIColor(red: 0, green: 0.75, blue: 0.8, alpha: 1)
        let textfield_hint = UIColor(red: 0.72, green: 0.72, blue: 0.72, alpha: 1)
        let textfield_text = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1)
        let transparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    // List all the URL paths here
    struct APIPaths {
        let tokenUrl = "/o/token/"
    }
    
    // List all the time formats here
    struct TimeFormats {
        let YYYY_MM_DD = "yyyy-MM-dd"
        let DD_MMM_YYYY = "dd MMM yyyy"
        let MMM_DD_YYYY = "MMM dd, yyyy"
        let YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss"
        let HH_MM_A = "HH:mm a"
        let DD_MM_YYYY = "dd/MM/yyyy"
    }
    struct Text {
        static let PROGRESS_TITLE = "Caricamento..."
        
        static let EMPTY_GALLERY_TITLE = "Non hai ancora creato nessuno Snap!\nApri il menu e scegli Fai una foto” per iniziare. Se hai qualche dubbio puoi riguardare il tutorial"
        static let GALLERY_EMPTY_ACTION_TITLE = "Tutorial"
    }
    
    struct ScreenSize
    {
        static let WIDTH         = UIScreen.main.bounds.size.width
        static let HEIGHT        = UIScreen.main.bounds.size.height
        static let MAX_LENGTH    = max(ScreenSize.WIDTH, ScreenSize.HEIGHT)
        static let MIN_LENGTH    = min(ScreenSize.WIDTH, ScreenSize.HEIGHT)
    }
    
    // List all the fonts here
    struct Fonts {
//        let approversHeaderFont = UIFont(name: "Assistant-SemiBold", size: 20.0)
    }
    
    // For regular expressions
    struct Regex {
        let email = "[A-Z0-9a-z]+[._%&+-]*[A-Z0-9a-z]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    // KEYs
    struct ConfigKeys {
        let HOST = "HOST"
        let BASE_URL = "BASE_URL"
        let CLIENT_ID = "CLIENT_ID"
        let CLIENT_SECRET = "CLIENT_SECRET"
        let GOOGLE_API_KEY = "GOOGLE_API_KEY"
    }
    
    // Images
    struct Images {
//        let close = UIImage(named: "close_icon")     
    }
    
    // Filenames
    struct FileNames {
        
    }
}
