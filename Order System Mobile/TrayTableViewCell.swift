//
//  TrayTableViewCell.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/20/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit

class TrayTableViewCell: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        quantityLabel.layer.borderColor = UIColor.gray.cgColor
        quantityLabel.layer.borderWidth = 1.0
        quantityLabel.layer.cornerRadius = 10
    }

}
