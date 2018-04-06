//
//  MealTableViewCell.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/13/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mealName: UILabel!
    
    @IBOutlet weak var mealDescription: UILabel!
    @IBOutlet weak var mealPrice: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
