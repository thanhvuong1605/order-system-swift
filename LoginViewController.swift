//
//  LoginViewController.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/1/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var bLogin: UIButton!
    @IBOutlet weak var bLogout: UIButton!
    var fbLoginSuccess = false
    
    var userType: String = USERTYPE_CUSTOMER
    
    
    
    //run in the first time but run only once
    override func viewDidLoad() {
        super.viewDidLoad()

        bLogin.layer.cornerRadius = 8
        bLogout.layer.cornerRadius = 8
        
        if (FBSDKAccessToken.current() != nil){
            bLogout.isHidden = false
            FBManager.getFBUserData(completionHandler: {
                self.bLogin.setTitle("Continue as \(User.currentUser.email!)", for: .normal)
                
            })
        } else {
            //self.bLogout.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //will run manytimes
    override func viewDidAppear(_ animated: Bool) {
        if(FBSDKAccessToken.current() != nil && fbLoginSuccess == true){
            performSegue(withIdentifier: "CustomerView", sender: self)
        }
    }
    @IBAction func FacebookLogin(_ sender: AnyObject) {
        if(FBSDKAccessToken.current() != nil){
            
            APImanager.shared.login(userType: userType, completionHandler: { (error) in
                self.fbLoginSuccess = true
                self.viewDidAppear(true)
            })
            
           
        }else{ //call back function
            FBManager.shared.logIn(withReadPermissions: ["public_profile","email"], from: self, handler: { (result, error) in
                if(error == nil){
                    FBManager.getFBUserData(completionHandler: {
                        APImanager.shared.login(userType: self.userType, completionHandler: { (error) in
                            if error == nil{
                                self.fbLoginSuccess = true
                                self.viewDidAppear(true)

                            }
                        })
                    })
                }
            })
        }
    }

    @IBAction func FacebookLogout(_ sender: AnyObject) {
        
        APImanager.shared.logout { (error) in
            if error == nil{
                FBManager.shared.logOut()
                User.currentUser.resetInfo()
                
                self.bLogin.setTitle("Sign in with Facebook", for: .normal)

            }
        }
        
    }
    
      
}
