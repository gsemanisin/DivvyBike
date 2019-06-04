//
//  ViewController.swift
//  DivvyBike
//
//  Created by Gwyneth Semanisin on 6/4/19.
//  Copyright © 2019 Gwyneth Semanisin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    var selectedAnnotation = MKPointAnnotation()
    let query = "https://feeds.divvybikes.com/stations/stations.json"
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.delegate = self
        
        query5()
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let center = location?.coordinate
        let region = MKCoordinateRegion(center: center!, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func parse(json: JSON){
        
        for result in json["stationBeanList"].arrayValue{
            let latitude = result["latitude"].doubleValue
            let longitude = result["longitude"].doubleValue
            let name = result["stationName"].stringValue
            let availableBikes = result["availableBikes"].stringValue
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = name
            annotation.subtitle = "Available bikes: \(availableBikes)"
            mapView.addAnnotation(annotation)
        }
    }
    
    func loadError(){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error Loading", message: "There was a problem loading the bus stop data", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }

    func query5() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            [unowned self] in
            if let url = URL(string: self.query) {
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSON(data: data)
                    self.parse(json: json)
                    return
                }
            }
            self.loadError()

        }

    }
}

