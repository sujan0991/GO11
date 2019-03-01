//
//  DataStoreManager.swift
//  Welltravel
//
//  Created by Amit Sen on 11/17/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation
import ObjectMapper

class DataStoreManager {
    
    init() {
        
    }

    func getBaseURL() -> String {
        return Bundle.main.infoDictionary![App.sharedInstance.configKeys.BASE_URL] as! String
    }

    func getHost() -> String {
        return Bundle.main.infoDictionary![App.sharedInstance.configKeys.HOST] as! String
    }
    
    func getGoogleApiKey() -> String {
        return Bundle.main.infoDictionary![App.sharedInstance.configKeys.GOOGLE_API_KEY] as! String
    }
    
    func getClientId() -> String {
        return Bundle.main.infoDictionary![App.sharedInstance.configKeys.CLIENT_ID] as! String
    }
    
    func getClientSecret() -> String {
        return Bundle.main.infoDictionary![App.sharedInstance.configKeys.CLIENT_SECRET] as! String
    }
    
    func parseJsonObject<T: Mappable>(fromFile fileName: String, returnType type: T.Type, callback: @escaping(T) -> Void) {
        let apiData = Mapper<T>().map(JSONfile: fileName)!
        callback(apiData)
    }
    
    func parseJsonArray<T: Mappable>(fromFile fileName: String, returnType type: T.Type, callback: @escaping([T]) -> Void) {
        let apiData = Mapper<T>().mapArray(JSONfile: fileName)!
        callback(apiData)
    }
}
