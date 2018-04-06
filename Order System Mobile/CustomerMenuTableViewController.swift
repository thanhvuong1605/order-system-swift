//
//  CustomerMenuTableViewController.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 2/27/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit

class CustomerMenuTableViewController: UITableViewController {

    @IBOutlet weak var ava_picture: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name_label.text = User.currentUser.name
        ava_picture.image = try! UIImage(data: Data(contentsOf: URL(string: User.currentUser.pictureURL!)!))
        ava_picture.layer.cornerRadius = 70/2 //circle
        ava_picture.layer.borderColor = UIColor.white.cgColor
        ava_picture.clipsToBounds = true
        view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Logout" {
            APImanager.shared.logout(completionHandler: { (error) in
                if error == nil{
                    FBManager.shared.logOut()
                    User.currentUser.resetInfo()
                    
                    //Re-render the LoginView once you comleted logout process
                    let storyBoard = UIStoryboard(name:"Main",bundle:nil)
                    let appController = storyBoard.instantiateViewController(withIdentifier: "MainController") as! LoginViewController
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = appController
                }
            })
            return false
        }
        return true
    }

}
