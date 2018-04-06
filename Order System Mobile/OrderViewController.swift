//
//  OrderViewController.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/1/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderViewController: UIViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var orderTableView: UITableView!
    var tray = [JSON]()
    
    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        getOrder()
    }
    
    
    func getOrder(){
        
        APImanager.shared.getLatestOrder { (json) in
            print(json)
            if let orderDetails = json["order"]["order_details"].array {
                
                
                self.statusLabel.text = json["order"]["status"].string!.uppercased()
                self.tray = orderDetails
                self.orderTableView.reloadData()
            }
        }
    }
}
extension OrderViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderTableViewCell
        
        let item = tray[indexPath.row]
        cell.qtyLabel.text = String(item["quantity"].int!)
        
        cell.mealName.text = item["meal"]["name"].string
        cell.priceLabel.text = "$\(String(item["sub_total"].float!))"
        return cell
    }
    }
