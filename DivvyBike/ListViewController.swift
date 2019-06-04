//
//  ListViewController.swift
//  DivvyBike
//
//  Created by Gwyneth Semanisin on 6/4/19.
//  Copyright © 2019 Gwyneth Semanisin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var titles : [String] = []
    var subtitles : [String] = []
    let locationManager = CLLocationManager()
    let query = "https://feeds.divvybikes.com/stations/stations.json"
    var userCoordinate = CLLocation()
    var selectedAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        query5()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userCoordinate = locations.first!
        locationManager.stopUpdatingLocation()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func parse(json: JSON){
        
        for result in json["stationBeanList"].arrayValue{
            let latitude = result["latitude"].doubleValue
            let longitude = result["longitude"].doubleValue
            let name = result["stationName"].stringValue
            let availableBikes = result["availableBikes"].stringValue
            
            let bikeLocation = CLLocation(latitude: latitude, longitude: longitude)
            let distanceInMeters = userCoordinate.distance(from: bikeLocation)
            print(distanceInMeters)
            let distanceInMiles = distanceInMeters/1609.34
            print(distanceInMiles)
            
            titles.append(name)
            let sub = String(format: "Available bikes: \(availableBikes) \nDistance: %.2f", distanceInMiles)
            subtitles.append(sub)
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print(titles[1])
        print(subtitles.count)
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
            
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        //sorting
        
        
        
        let title = titles[indexPath.row]
        cell?.textLabel?.text = title
        let subtitle = subtitles[indexPath.row]
        cell?.detailTextLabel?.text = subtitle
        return cell!
    }
    
    
    // MARK: - Navigation
     
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedAnnotation =
//    }
    
     
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
