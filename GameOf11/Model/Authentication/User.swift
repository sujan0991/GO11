//
//  User.swift
//  UG Customer
//
//  Created by Amit Sen on 3/11/18.
//  Copyright © 2018 Amit Sen. All rights reserved.
//

import ObjectMapper

class User: BaseModel, Mappable {
    private struct Key {
        let user = "user"
    }
    
    internal var userData: UserData!
    
    required internal init(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    internal func mapping(map: Map) {
        let baseKey = BaseKey.init()
        statusCode <- map[baseKey.status_code]
        
        let key = Key.init()
        userData <- map[key.user]
    }
}
