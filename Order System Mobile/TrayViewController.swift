//
//  TrayViewController.swift
//  Order System Mobile
//
//  Created by Thanh Vuong on 2/28/18.
//  Copyright © 2018 Thanh Vuong. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class TrayViewController: UIViewController {

    @IBOutlet weak var tableViewMeal: UITableView!
    @IBOutlet weak var totalView: UIView!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var addressTextBox: UITextField!
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
    var locationManager: CLLocationManager!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for the customer menu
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        
        if Tray.currentTray.items.count == 0{
            //message
            let lbEmptyTray = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
            lbEmptyTray.center = self.view.center
            lbEmptyTray.textAlignment = .center
            lbEmptyTray.text = "Your tray is Empty."
            self.view.addSubview(lbEmptyTray)
        } else {
            //show all the views
            self.tableViewMeal.isHidden = false
            self.totalView.isHidden = false
            self.addressView.isHidden = false
            self.mapView.isHidden = false
            self.paymentButton.isHidden = false
            
            loadMeal()
        }
        
        //show user's location
        if CLLocationManager.locationServicesEnabled(){
            
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            self.map.showsUserLocation = true
        }
        
        
        
    }

    
    func loadMeal(){
        self.tableViewMeal.reloadData()
        self.totalLabel.text = "$\(Tray.currentTray.getTotal())"
    }
    
    @IBAction func payment_action(_ sender: AnyObject) {
        if self.addressTextBox.text == "" {
            // alert
            let alertController = UIAlertController(title: "Address", message: "Please input address or choose picking up option.", preferredStyle: .alert)
            
            let okaction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                self.addressTextBox.becomeFirstResponder()
            })
            let pickupaction = UIAlertAction(title: "Pick up", style: .default, handler: { (alert) in
                self.addressTextBox.text = "Pick up."
            })
            
            alertController.addAction(okaction)
            alertController.addAction(pickupaction)
            self.present(alertController, animated: true, completion: nil)
            
        } else if self.addressTextBox.text == "Pick up."{
            Tray.currentTray.address = addressTextBox.text
            self.performSegue(withIdentifier: "Payment", sender: self)
        } else {
            Tray.currentTray.address = addressTextBox.text
            self.performSegue(withIdentifier: "Payment", sender: self) //self means send from this controller
        }
    }
    
}

//delegate for location
extension TrayViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
    }
}


extension TrayViewController: UITableViewDataSource, UITabBarDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tray.currentTray.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrayCell", for: indexPath) as! TrayTableViewCell
        let tray = Tray.currentTray.items[indexPath.row]
        cell.quantityLabel.text = "\(tray.qty)"
        cell.mealName.text = tray.meal.name
        cell.priceLabel.text = "$\(tray.meal.price! * Float(tray.qty))"
        
        return cell
    }
}


extension TrayViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let address = textField.text
        let geocoder = CLGeocoder()
        Tray.currentTray.address = address
        
        
        geocoder.geocodeAddressString(address!) { (placemarks, error) in
            if (error != nil){
                print("error", error)
                
            }
            if let placemark = placemarks?.first{
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                let region = MKCoordinateRegion(center: coordinates
                    , span: MKCoordinateSpanMake(0.01, 0.01))
                
                self.map.setRegion(region, animated: true)
                self.locationManager.stopUpdatingLocation()  //stop updating location of user when input new address
                
                
                //create pin
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                self.map.addAnnotation(annotation)
            }
        }
        return true
    }
}




