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
    

//    @IBOutlet var panoView: UIView!
    
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let travelDetail = travelDetail{
            
            let lat =  travelDetail.centerLat!
            let long = travelDetail.centerLng!
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
            let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            
//            self.googleMapView.addSubview(mapView)
//            self.view.addSubview(googleMapView)
            
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = mapView
            
            
//            let pano = GMSPanoramaView(frame: .zero)
//            pano.moveNearCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: long))
//            self.panoView = pano
           
            
            
           let panoView = GMSPanoramaView(frame: .zero)
            self.view = panoView
            panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: long))
            
            
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
