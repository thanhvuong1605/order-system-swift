//
//  File.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 3/19/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import Foundation

class TrayItem{
    var meal: Meal
    var qty: Int
    
    init(meal:Meal, qty: Int){
        self.meal = meal
        self.qty = qty
    }
}

class Tray{
    static let currentTray = Tray()
    var restaurant: Restaurant?
    var items = [TrayItem]()
    var address: String?
    
    func getTotal() -> Float{
        var total: Float = 0
        
        for item in self.items{
            total = total + Float(item.qty) * item.meal.price!
            
        }
        
        return total
    }
    
    func reset(){
        self.restaurant = nil
        self.items = []
        self.address = nil
    }
}
