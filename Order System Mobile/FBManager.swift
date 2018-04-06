//
//  FBManager.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/1/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON


///For taking the FBSDK token, and make a func to get FB user to display in the menu
class FBManager{
    static let shared = FBSDKLoginManager()
    
    public class func getFBUserData(completionHandler: @escaping () -> Void){
        if (FBSDKAccessToken.current() != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, email, picture.type(normal)"]).start(completionHandler: { (connection, result, error) in
                if(error == nil){
                    let json = JSON(result!)
                    print(json)
                    User.currentUser.setInfo(json: json)
                    completionHandler()
                }
            })
        }
    }
    
}
