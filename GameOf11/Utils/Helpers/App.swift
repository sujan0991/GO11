//
//  App.swift
//  Welltravel
//
//  This is a singleton class which have all the instances of objects that will be needed throughout the app.
//
//  Created by Amit Sen on 11/11/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

public class App {
    static let sharedInstance = App()
    let texts = Constants.Texts.init()
    let colors = Constants.Color.init()
    let regex = Constants.Regex.init()
    let configKeys = Constants.ConfigKeys.init()
    let timeFormats = Constants.TimeFormats.init()
    let fonts = Constants.Fonts.init()
    let apiPaths = Constants.APIPaths.init()
    let alert = Alert.init()
    let userDefaultsManager = UserDefaultsManager.init()
    let validityManager = ValidityManager.init()
    let uiHelper = UIHelper.init()
    let dataStoreManager = DataStoreManager.init()
    let vivid = Vivid.init()
    let dateTimeHelper = DateTimeHelper.init()
    let mockDataManager = MockDataManager.init()
    let routes = Routes.init()
    let images = Constants.Images.init()
    let fileNames = Constants.FileNames.init()
    
    private init() {
    }
    
    func initialize(application: UIApplication) {
        
      //  IQKeyboardManager.sharedManager().enable = true
        
      //  networkManager = networkManager.init(withHost: dataStoreManager.getHost(),
       //                                      andBaseUrl: dataStoreManager.getBaseURL())
//        if networkManager != nil {
//            print("network manager is not nil")
//        }
        //GMSServices.provideAPIKey(dataStoreManager.getGoogleApiKey())
    }
}
