//
//  Restaurant.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/11/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import Foundation
import SwiftyJSON

class Restaurant{
    var id: Int?
    var name: String?
    var address: String?
    var logo: String?
    
    init(json:JSON){
        self.id = json["id"].int
        self.name = json["name"].string
        self.address = json["address"].string
        self.logo = json["logo"].string
    }
}
