//
//  GoogleMapViewController.swift
//  travel_project
//  Created by 葉育彣 on 2020/6/23.
//  Copyright © 2020 葉育彣. All rights reserved.
import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {
    
    
    var mapView:GMSMapView!
    var path: GMSMutablePath!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

            // 將視角切換至台北 101
                   let camera = GMSCameraPosition.camera(withLatitude: 25.033671, longitude: 121.564427, zoom:11.0)
                   
                   // 生成 MapView
                   self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                   self.mapView.isMyLocationEnabled = true // 開啟我的位置(藍色小點)
                   self.view = self.mapView
                   
                   // 新增台北 101 的 Marker
                   // 台北 101
                   let marker = GMSMarker()
                   marker.position = CLLocationCoordinate2D(latitude: 25.033671, longitude: 121.564427)
                   marker.title = "Taiwan"
                   marker.snippet = "Taipei101"
                   marker.map = mapView
        
        // 台北車站
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: 25.0326708, longitude: 121.56953640000006)
        marker1.title = "Taiwan"
        marker1.snippet = "TaipeiStation"
        marker1.map = mapView
        
        // 新增折線
        self.path = GMSMutablePath()
        self.path.add(CLLocationCoordinate2D(latitude:25.033671, longitude: 121.564427))
        self.path.add(CLLocationCoordinate2D(latitude:25.0326708, longitude: 121.56953640000006))
        
        let line = GMSPolyline(path: self.path)
        line.map = self.mapView
        let url = URL(string: "comgooglemaps://?saddr=&daddr=25.033671,121.564427&directionsmode=driving")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // 若手機沒安裝 Google Map App 則導到 App Store(id443904275 為 Google Map App 的 ID)
            let appStoreGoogleMapURL = URL(string: "itms-apps://itunes.apple.com/app/id585027354")!
            UIApplication.shared.open(appStoreGoogleMapURL, options: [:], completionHandler: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 調整 camera 讓 polyline 的能見度完整顯示在 MapView 上
            var bounds: GMSCoordinateBounds = GMSCoordinateBounds()
            for index in 0 ..< path.count() {
                bounds = bounds.includingCoordinate(path.coordinate(at: index))
            }
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        
    }

 

}
