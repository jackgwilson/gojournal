//
//  Venue.swift
//  GoJournal
//
//  Created by Jack Wilson on 12/3/18.
//  Copyright © 2018 Jack Wilson. All rights reserved.
//

import Foundation
import MapKit

class Venue: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var venue: String = ""
    var venueName: String? {
        return venue
    }
    
    // convenience
    init(venue: String, coordinate: CLLocationCoordinate2D) {
        self.venue = venue
        self.coordinate = coordinate
    }
    
    convenience override init() {
        self.init(venue: "", coordinate: CLLocationCoordinate2D())
    }
    
}
