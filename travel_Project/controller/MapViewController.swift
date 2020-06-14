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


class MapViewController: UIViewController,GMSMapViewDelegate {
    
    
    var travelDetail : TravelDetail?
    var noteData:Note?
    var sectionIndex:Int?
    


    @IBOutlet var streetView: GMSPanoramaView!
    @IBOutlet var mapView: GMSMapView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let travelDetail = travelDetail{
            
            let lat =  travelDetail.centerLat!
            let long = travelDetail.centerLng!
            
            //地圖
            mapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
            mapView.mapType = .terrain
            
            self.streetView.moveNearCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: long))//街景
            

            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            marker.title = travelDetail.name
//            marker.snippet = "Australia"
            marker.map = mapView

        
            mapView.settings.compassButton = true//指南針
            mapView.isMyLocationEnabled = true//定位啟用
            mapView.settings.myLocationButton = true//定位按鈕
            
        }
        
        
        
        
        
        
        
        
        

        
        
        
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
