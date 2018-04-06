//
//  User.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/1/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import Foundation
import SwiftyJSON

class User{
    var name: String?
    var email: String?
    var pictureURL: String?
    
    static let currentUser = User()
    
    func setInfo(json: JSON){
        self.name = json["name"].string
        self.email = json["email"].string
        let picture = json["picture"].dictionary
        let pictureData = picture?["data"]?.dictionary
        self.pictureURL = pictureData?["url"]?.string
    }
    
    func resetInfo(){
        self.name = nil
        self.email = nil
        self.pictureURL = nil
    }
}
