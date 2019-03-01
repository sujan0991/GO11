//
//  Token.swift
//  UG Customer
//
//  Created by Amit Sen on 4/16/18.
//  Copyright © 2018 Amit Sen. All rights reserved.
//

import ObjectMapper

class Token: Mappable {
    private struct Key {
        let access_token = "access_token"
        let token_type = "token_type"
        let expires_in = "expires_in"
        let refresh_token = "refresh_token"
        let scope = "scope"
    }
    
    internal var accessToken: String!
    internal var tokenType: String!
    internal var expiresIn: Int!
    internal var refreshToken: String!
    internal var scope: String!
    
    required internal init(map: Map) {
        mapping(map: map)
    }
    
    internal func mapping(map: Map) {
        let key = Key.init()
        
        accessToken <- map[key.access_token]
        tokenType <- map[key.token_type]
        expiresIn <- map[key.expires_in]
        refreshToken <- map[key.refresh_token]
        scope <- map[key.scope]
    }
}
