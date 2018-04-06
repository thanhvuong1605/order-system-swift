//
//  APImanager.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/5/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class APImanager{
    static let shared = APImanager()
    let baseURL = NSURL(string: BASE_URL)
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    
    // this is asynchronous function, so 2 function will be run at the same time. It will connect to the server and process data and get back data to the client.
    
    // so we need to use Closure. function declared as parameters. function #2 will wait for func 1 to complete process. Avoid timeout error.
    
    //API for loging in
    func login(userType: String, completionHandler: @escaping(NSError?) -> Void){
        let path = "auth_fb/convert-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type":"convert_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend":"facebook",
            "token":FBSDKAccessToken.current().tokenString,
            "user_type":userType
        ]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON { (response) in
            switch response.result{
                case .success(let value):
                    let jsonData = JSON(value)
                    self.accessToken = jsonData["access_token"].string!
                    self.refreshToken = jsonData["refresh_token"].string!
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))

                    completionHandler(nil)
                    break
                
                case .failure(let error):
                    completionHandler(error as NSError?)
                    break
            }
        }
    }
    
    //API for logging out
    func logout(completionHandler: @escaping (NSError?) -> Void){
        let path = "auth_fb/revoke-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "token":self.accessToken
        ]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseString { (response) in
            switch response.result{
            case .success:
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
        }

    }
    
    func refreshToken(completionHandler: @escaping() -> Void){
        let path = "auth_fb/refresh-token"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken,
            "refresh_token": self.refreshToken
        ]
        if (Date() > self.expired){
            Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    let jsonData = JSON(value)
                    self.accessToken = jsonData["access_token"].string!
                    self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expired_in"].int!))
                    completionHandler()
                    break
                    
                case .failure:
                    break
                }
            })
        } else {
            completionHandler()
        }
    }
    
    
    //API for restaurant list
    func getRestaurants(completionHandler: @escaping (JSON) -> Void){
        let path = "api/customer/restaurants"
        let url = baseURL?.appendingPathComponent(path)
        
        refreshToken{
            Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    let jsonData = JSON(value)
                    completionHandler(jsonData)
                    break
                    
                case .failure:
                    completionHandler(nil)
                    break
                }
            })
        }
    }
    
    
    //api for getting list of meal
    func getMeals(restaurantId: Int, completionHandler: @escaping(JSON) -> Void){
        let path = "api/customer/meals/\(restaurantId)"
        let url = baseURL?.appendingPathComponent(path)
        
        refreshToken{
            Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    let jsonData = JSON(value)
                    completionHandler(jsonData)
                    break
                    
                case .failure:
                    completionHandler(nil)
                    break
                }
            })
        }

    }
    
    
    
    // api for creating order
    func createOrder(stripeToken: String, completionHandler: @escaping (JSON) -> Void){
        let path = "api/customer/order/add/"
        let url = baseURL?.appendingPathComponent(path)
        let simpleArray = Tray.currentTray.items
        let jsonArray = simpleArray.map { item in
            return [
                "meal_id": item.meal.id!,
                "quantity": item.qty
            ]
            
        }
        
        if JSONSerialization.isValidJSONObject(jsonArray){
            do{
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                
                let params: [String: Any] = [
                    "access_token": self.accessToken,
                    "stripe_token": stripeToken,
                    "restaurant_id": "\(Tray.currentTray.restaurant!.id!)",
                    "order_details": dataString,
                    "address": Tray.currentTray.address!
                ]
                refreshToken{
                    Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: { (response) in
                        switch response.result{
                        case .success(let value):
                            let jsonData = JSON(value)
                            completionHandler(jsonData)
                            break
                            
                        case .failure:
                            completionHandler(nil)
                            break
                        }
                    })
                }

            
            }catch{
                print("JSON serialization failed")
            }
        }
    }
    
    
    //getting latest order
    func getLatestOrder(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/order/latest/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "access_token": self.accessToken
        ]
        
        refreshToken{
            Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    let jsonData = JSON(value)
                    completionHandler(jsonData)
                    break
                    
                case .failure:
                    completionHandler(nil)
                    break
                }
            })
        }

    }
}





