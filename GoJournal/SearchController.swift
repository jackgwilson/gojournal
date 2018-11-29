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
    
    
    var searchResults = [JSON]()
    var currentLocation: CLLocationCoordinate2D!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        snapToPlace()
    }
    
    func snapToPlace() {
        let url = "https://api.foursquare.com/v2/search/?ll=\(currentLocation.latitude),\(currentLocation.longitude)&v=20181128&intent=checkin&limit=1&radius=4000&client_id=\(clientID)&client_secret=\(clientSecret)"
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let currentVenueName = json["response"]["venues"][0]["name"].string {
                    self.currentLocationLabel.text = currentVenueName
                } else {
                    print("Could not return a current venue name.")
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    

    
    
    

}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = searchResults[(indexPath as NSIndexPath).row]["venue"]["name"].string
        return cell
    }
    
    
}
