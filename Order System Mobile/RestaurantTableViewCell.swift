//
//  RestaurantTableViewCell.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/11/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var protoView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.photo.layoutIfNeeded()
        photo.layer.cornerRadius = 10
        photo.layer.masksToBounds = true
        
        protoView.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect:  protoView.bounds)
         protoView.layer.masksToBounds = false
         protoView.layer.shadowColor = UIColor.darkGray.cgColor
         protoView.layer.shadowOffset = CGSize(width: CGFloat(0.05), height: CGFloat(0.05))
         protoView.layer.shadowOpacity = 0.1
         protoView.layer.shadowPath = shadowPath2.cgPath
        protoView.layer.shadowRadius = 10
    

    }

   
}
