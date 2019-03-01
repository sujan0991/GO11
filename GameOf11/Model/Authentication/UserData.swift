//
//  UserData.swift
//  UG Customer
//
//  Created by Amit Sen on 3/11/18.
//  Copyright © 2018 Amit Sen. All rights reserved.
//

import ObjectMapper

class UserData: Mappable {
    private struct Key {
        let name = "name"
        let gender = "gender"
        let birth_date = "birth_date"
        let nationality = "nationality"
        let mobile_number = "mobile_number"
        let email = "email"
        let address = "address"
        let picture = "picture"
        let created_at = "created_at"
        let edited_at = "edited_at"
    }
    
    internal var name: String!
    internal var gender: String!
    internal var email: String!
    internal var birthDate: String!
    internal var nationality: String!
    internal var mobileNo: String!
    internal var address: String!
    internal var photoUrl: String!
    
    required internal init(map: Map) {
        mapping(map: map)
    }
    
    internal func mapping(map: Map) {
        let key = Key.init()
        
        name <- map[key.name]
        gender <- map[key.gender]
        email <- map[key.email]
        birthDate <- map[key.birth_date]
        nationality <- map[key.nationality]
        mobileNo <- map[key.mobile_number]
        address <- map[key.address]
        photoUrl <- map[key.picture]
    }
}
