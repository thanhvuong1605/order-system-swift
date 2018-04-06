//
//  PaymentViewController.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 2/28/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController {

    @IBOutlet weak var cardField: STPPaymentCardTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func placeOrder(_ sender: AnyObject) {
        //APImanager.shared.getLatestOrder{ (json) in
            //if json["oder"]["status"] == nil || json["order"]["status"] == "Delivered" {
                //processing payment
                
                let card = self.cardField.cardParams
                STPAPIClient.shared().createToken(withCard: card, completion: { (token, error) in
                    if let error = error{
                        print("Error", error)
                    } else if let stripeToken = token{
                        APImanager.shared.createOrder(stripeToken: stripeToken.tokenId, completionHandler: { (json) in
                            Tray.currentTray.reset()
                            self.performSegue(withIdentifier: "ViewOrder", sender: self)
                        })
                    }
                })}
//            } else {
//                //alert
//                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
//                let okAction = UIAlertAction(title: "Go to Order", style: .default, handler: { (UIAlertAction) in
//                    self.performSegue(withIdentifier: "ViewOrder", sender: self)
//                })
//                
//                let alertView = UIAlertController(title: "Already Order", message: "Cannot be completed", preferredStyle: .alert)
//                
//                alertView.addAction(okAction)
//                alertView.addAction(cancelAction)
//                self.present(alertView, animated: true, completion: nil)
//            }
        
       // }
    
    //}
}
