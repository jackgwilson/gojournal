//
//  SearchController.swift
//  GoJournal
//
//  Created by Jack Wilson on 11/28/18.
//  Copyright © 2018 Jack Wilson. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

let clientID = "HVPMHZXNSJTDJNCYIMA0NEGF554XWPBVKYGATPBMMDFYRUHB"
let clientSecret = "XQFRBBGINBRW5M3OV121BRHGHNC21GU3JDWKFAMEABM0JV3P"

class SearchController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var searchResults = [JSON]()
    var placesToDiscover: [String] = []
    var recPlaces = [String]()
    var placeAddresses = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        //snapToPlace()
        //fetchVenues()
        //tableView.reloadData()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Attempting to get location upon viewWillAppear")
        getLocation {
            //self.snapToPlace()
        }
    }

    
    func snapToPlace() {
        print(currentLocation)
        print(currentLocation.coordinate.longitude)
        let url = "https://api.foursquare.com/v2/venues/search/?ll=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&v=20181129&intent=checkin&limit=1&radius=40000&client_id=\(clientID)&client_secret=\(clientSecret)"
        print(url)
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                print(json["response"]["venues"][0]["name"].string)
                
                if let currentVenueName = json["response"]["venues"][0]["name"].string {
                    self.currentLocationLabel.text = "The closest venue is: \(currentVenueName)"
                } else {
                    print("Could not return a current venue name.")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchVenues(completed: @escaping () -> ()) {
        print("HELLO")
        
        let url = "https://api.foursquare.com/v2/venues/explore/?ll=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&limit=30&client_id=HVPMHZXNSJTDJNCYIMA0NEGF554XWPBVKYGATPBMMDFYRUHB&client_secret=XQFRBBGINBRW5M3OV121BRHGHNC21GU3JDWKFAMEABM0JV3P&v=20181129"
        print(currentLocation.coordinate.longitude)
        print(currentLocation.coordinate.latitude)
        Alamofire.request(url).responseJSON { response in
            print("HELLO2")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("fetchVenues Reponse")
                print(json)
                var items = json["response"]["groups"][0]["items"]
                for index in 0..<items.count {
                    let closeVenue = items[index]["venue"]["name"].string
                    self.recPlaces.append(closeVenue ?? "")
                }
                
                // not pulling category name 
                
                for index in 0..<items.count {
                    let category = items[index]["venue"]["categories"]["name"].string
                    print(category)
                    self.placeAddresses.append(category ?? "")
                    print(self.placeAddresses)
                }
                //print("HERE AGAIN: \(self.recPlaces)")
                self.tableView.reloadData()

                
            case .failure(let error):
                print(error)
            }
        }
//        for venue in placesToDiscover {
//            venue = JSON(["response"]["venues"][0]["name"].string)
//        }
        //print("HERE AGAIN: \(self.recPlaces)")
        //self.tableView.reloadData()
        completed()
    }
    
    
    
    

}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(recPlaces.count)
        return recPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = recPlaces[indexPath.row]
        cell.detailTextLabel?.text = placeAddresses[indexPath.row]
        print("HERE: \(recPlaces[indexPath.row])")
        return cell
    }
    
    
}

extension SearchController: CLLocationManagerDelegate {
    
    func getLocation(completed: @escaping () -> ()) {
        print("GETTING LOCATION")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        completed()
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            print("REQUESTING LOCATION")
        case .denied:
            print("I'm sorry - can't show location. User has not authorized it.")
        case .restricted:
            print("Access denied. Likely parental controls restrict location services in this app.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        print("CURRENT LOCATION IS \(currentLocation.coordinate.longitude), \(currentLocation.coordinate.latitude)")
        self.snapToPlace()
        self.fetchVenues() {
            print("finished")
            print(self.recPlaces.count)
            self.tableView.reloadData()
        }
        
        //self.fetchVenues()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location")
    }
}
