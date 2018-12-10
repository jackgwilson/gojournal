//
//  SearchDetailsViewController.swift
//  GoJournal
//
//  Created by Jack Wilson on 11/28/18.
//  Copyright © 2018 Jack Wilson. All rights reserved.
//

import UIKit
import MapKit

class SearchDetailsViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var venue: Venue!
    let regionDistance: CLLocationDistance = 1100

    override func viewDidLoad() {
        super.viewDidLoad()
        let region = MKCoordinateRegion(center: venue.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
        updateMap()
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(venue)
        mapView.setCenter(venue.coordinate, animated: true)
    }
    
}
