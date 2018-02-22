//
//  ViewController.swift
//  unier
//
//  Created by Nathanael Sheehan on 03/02/2018.
//  Copyright © 2018 Nathanael Sheehan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var courseSearch: UITextField!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var latLongLabel: UILabel!
    @IBOutlet weak var locationDetailsLabel: UILabel!
    
    @IBAction func searchButton(_ sender: Any) {
        
        guard let searchTerm = courseSearch.text else {
            return
        }
        
        guard let result = searchEngine.shared.search(for: searchTerm) else {
            return
        }
        print(result.count)
        self.performSegue(withIdentifier: "showResults", sender: result)
    }
    var receivedString = ""
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        welcomeLabel.text = "Welcome \(receivedString)"
        let logo = UIImage(named: "UNIER.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        //if location service in engabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //trigger location update when device moves more than 50 meteres
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
        
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        latLongLabel.text = "latitude: \(latitude) \n longitude: \(longitude)"
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        latLongLabel.text = "latitude: \(latitude) \n longitude: \(longitude)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            if let destination  = segue.destination as? ResultsPage {
                destination.courses = sender as! [Course]
            }
        }
    }
}

