//
//  googleMapViewController.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/9.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit
import GoogleMaps


class MapVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var tripInfo : tripPlanInfo?
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        
    

}
}

