//
//  MealDetailsViewController.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 2/27/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit

class MealDetailsViewController: UIViewController {

    @IBOutlet weak var meal_Image: UIImageView!
    
    @IBOutlet weak var meal_label: UILabel!
    
    @IBOutlet weak var meal_description: UILabel!
    
    @IBOutlet weak var total_order: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    var counter = 1
    var meal:Meal?
    
    var restaurant: Restaurant?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMeal()
        
        total_order.text = "1"
    }
    
    func loadMeal(){
        meal_label.text = meal?.name
        meal_description.text = meal?.description
        
        if let image = meal?.image{
            let url = "\(image)"
            loadImage(imageView: meal_Image, urlString: url)
        }
        if let meal_price = meal?.price{
            price.text = "$\(meal_price)"
        }
        
        
    }
    
    func loadImage(imageView: UIImageView, urlString: String){
        let imgURL: URL = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: imgURL){ (data,response,error) in
            guard let data = data, error == nil else { return}
            
            DispatchQueue.main.async(execute: {
                imageView.image = UIImage(data: data)
            })
            
            }.resume()
    }

   
    //ADd to tray animation
    @IBAction func addToTray(_ sender: AnyObject) {
        let label = UILabel(frame: CGRect(x:0,y:0,width:200,height:40))
        label.text = "Added to tray!!"
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.center = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height-100)
        self.view.addSubview(label)

        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { 
             label.center = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
            }, completion: { _ in
                label.removeFromSuperview()
                
                
                //logic for tray
                let trayItem = TrayItem(meal: self.meal!, qty: self.counter)
                guard let trayRestaurant = Tray.currentTray.restaurant, let currentRestaurant = self.restaurant
                    else{
                        Tray.currentTray.restaurant = self.restaurant
                        Tray.currentTray.items.append(trayItem)
                        return
                }
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                //Ordering meal from same restaurant
                if trayRestaurant.id == currentRestaurant.id{
                    let inTray = Tray.currentTray.items.index(where: {(item) -> Bool in
                        return item.meal.id! == trayItem.meal.id!
                        
                })
                    if let index = inTray{
                        let aleartView = UIAlertController(
                            title: "Add more?",
                            message: "Your order already has this meal. Do you want to add more?",
                            preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "Add more",style: .default, handler:{(action: UIAlertAction!) in
                            Tray.currentTray.items[index].qty += self.counter
                    })
                        aleartView.addAction(okAction)
                        aleartView.addAction(cancelAction)
                        
                        self.present(aleartView, animated: true, completion: nil)
                    
                    }else{
                    Tray.currentTray.items.append(trayItem)
                    }
                    
                }else {
                    let inTray = Tray.currentTray.items.index(where: {(item) -> Bool in
                        return item.meal.id! == trayItem.meal.id!
                        
                    })
                    if let index = inTray{
                        let aleartView = UIAlertController(
                            title: "Add more?",
                            message: "Your order already has this meal. Do you want to add more?",
                            preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "Add more",style: .default, handler:{(action: UIAlertAction!) in
                            Tray.currentTray.items[index].qty += self.counter
                        })
                        aleartView.addAction(okAction)
                        aleartView.addAction(cancelAction)
                        
                        self.present(aleartView, animated: true, completion: nil)
                        
                    }else{
                        Tray.currentTray.items.append(trayItem)
                    }
                

                
        }
        })
    
    
        
        
    }
    
    @IBAction func plus(_ sender: AnyObject) {
        
        if counter < 99{
            counter +=  1
            total_order.text = String(counter)
            if let meal_price = meal?.price{
                price.text = "$\(Float(counter) * meal_price)"
            }
        }
       
    }
    @IBAction func minus(_ sender: AnyObject) {
        
        if counter > 1{
            counter -= 1
            total_order.text = String(counter)
            if let meal_price = meal?.price{
                price.text = "$\(Float(counter) * meal_price)"
            }
        }
    }
}

