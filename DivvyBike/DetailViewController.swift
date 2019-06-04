//
//  DetailViewController.swift
//  DivvyBike
//
//  Created by Gwyneth Semanisin on 6/4/19.
//  Copyright © 2019 Gwyneth Semanisin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate {
    
    var selectedAnnotation = MKPointAnnotation()
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        mapView.addAnnotation(selectedAnnotation)
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.showAnnotations(mapView.annotations, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    
    
    
}
