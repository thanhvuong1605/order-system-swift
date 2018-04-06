//
//  MealListTableViewController.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 2/27/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit

class MealListTableViewController: UITableViewController {
    
    var restaurant: Restaurant?
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let restaurant_name = restaurant?.name{
            self.navigationItem.title = restaurant_name
        }
     
        loadMeals()
    }
    
    //prevent timeout
    func loadMeals(){
        if let restaurantId = restaurant?.id{
            APImanager.shared.getMeals(restaurantId: restaurantId, completionHandler: { (json) in
                if json != nil{
                    self.meals = []
                    if let tempMeals = json["meals"].array{
                        for item in tempMeals{
                            let meal = Meal(json:item)
                            self.meals.append(meal)
                        }
                        self.tableView.reloadData()
                    }
                }})
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

    
    //prepare function for segue, take the meal id to the meal detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MealDetails" {
            let controller = segue.destination as! MealDetailsViewController
            controller.meal = meals[(tableView.indexPathForSelectedRow?.row)!]
            controller.restaurant = restaurant
        }
    }
    
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealTableViewCell
        
        let meal = meals[indexPath.row]
        cell.mealName.text = meal.name
        cell.mealDescription.text = meal.description
        
        if let price = meal.price{
            cell.mealPrice.text = "$\(price)"
        }
        
        if let image = meal.image{
            let url = "\(image)"
            loadImage(imageView: cell.mealImage, urlString: url)
        }

        
        return cell
    }
}
