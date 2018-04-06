//
//  Meal.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/13/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import Foundation
import SwiftyJSON

class Meal{
    var id: Int?
    var name: String?
    var description: String?
    var image: String?
    var price: Float?
    
    init(json:JSON){
        self.id = json["id"].int
        self.name = json["name"].string
        self.description = json["description"].string
        self.image = json["image"].string
        self.price = json["price"].float
    }
}
