//
//  googleMapViewController.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/9.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var travelDetail : TravelDetail?
    
    var noteData:Note?
    var sectionIndex:Int?
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        
        
        
    }
}




extension TripPlanViewController: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        dismiss(animated: true , completion: nil)
        self.txtSearch.text = place.name
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
    }
    
    
}
