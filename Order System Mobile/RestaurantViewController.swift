//
//  RestaurantViewController.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 2/27/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController{

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var Logo: UIImageView!
    
    @IBOutlet weak var callButtonLbl: UIBarButtonItem!
    
    
    
    // create programmatically search bar when click to the icon
    
     let searchBar = UISearchBar()
    @IBAction func callButton(_ sender: AnyObject) {
        createSearchBar()
        
      
    }
    
    
    
    @IBOutlet weak var tableViewRestaurant: UITableView!
  
    var restaurants = [Restaurant]()
    var filterRestaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        loadRestaurants()
    }

    
    
    func loadRestaurants(){
        APImanager.shared.getRestaurants { (json) in
            if json != nil {
                self.restaurants = []
                if let listRestaurant = json["restaurants"].array{
                    for item in listRestaurant{
                        let restaurant = Restaurant(json: item)
                        self.restaurants.append(restaurant)
                    }
                    
//                    for r in self.restaurants{
//                        print(r.name)
//                        print(r.address)
//                    }
                    
                    self.tableViewRestaurant.reloadData()
                }
            }
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
    
    
    // for restaurant id to be given and sent to meal list whenever the segue is activated
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MealList"{
            let controller = segue.destination as! MealListTableViewController
            controller.restaurant = restaurants[(tableViewRestaurant.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// Table for Restaurant
extension RestaurantViewController: UITabBarDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != ""{
                return self.filterRestaurants.count
        }
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell
        
               
        
        let restaurant: Restaurant
        
        if searchBar.text != "" {
            restaurant = filterRestaurants[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        
        
        cell.lblName.text = restaurant.name!
        cell.lblAddress.text = restaurant.address!
        
        if let logoName = restaurant.logo{
            let url = "\(logoName)"
            loadImage(imageView: cell.photo, urlString: url)
        }
        
        
        
        return cell
    }
    
}


// search bar function
extension RestaurantViewController: UISearchBarDelegate, UISearchControllerDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterRestaurants = self.restaurants.filter({(res: Restaurant) -> Bool in
            return res.name?.lowercased().range(of: searchText.lowercased()) != nil
        })
        self.tableViewRestaurant.reloadData()
        
    }
    
    func createSearchBar(){
       
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    /*func cancelButtonClicked() {
        self.searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.searchDisplayController?.setActive(false, animated: true)
    }*/
   }












