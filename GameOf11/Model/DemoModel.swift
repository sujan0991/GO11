//
//  DemoModel.swift
//  Welltravel
//
//  Created by Amit Sen on 11/21/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import UIKit
import ObjectMapper

class DemoModel: BaseModel, Mappable {
    private struct Key {
        let key_name = "name"
        let key_email = "email"
    }

    internal var name: String!
    internal var email: String!

    required internal init(map: Map) {
        super.init()
        mapping(map: map)
    }

    internal func mapping(map: Map) {
        let key = Key.init()

        name <- map[key.key_name]
        email <- map[key.key_email]
    }
}
