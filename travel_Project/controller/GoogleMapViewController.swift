//
//  GoogleMapViewController.swift
//  travel_project
//  Created by 葉育彣 on 2020/6/23.
//  Copyright © 2020 葉育彣. All rights reserved.
import UIKit
import GoogleMaps
import GooglePlaces

class GoogleMapViewController: UIViewController {
    
    
    
    var googleMaplDetail : TravelDetail?
 
    var lat:Double?
    var long:Double?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let travelMap = googleMaplDetail{
            
            self.lat = travelMap.centerLat
            self.long = travelMap.centerLng
            //製作地圖
            let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 8.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            self.view = mapView
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            marker.map = mapView
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //導航鈕
        let navigationBtn = UIButton()
        let btnImage = UIImage(named: "googleMap")
        navigationBtn.setImage(btnImage, for: .normal)
        navigationBtn.frame = CGRect(x: self.view.frame.width * 0.65, y: self.view.frame.height * 0.25, width: 200 , height: 200)
        navigationBtn.addTarget(self, action: #selector(self.navigation), for: .touchUpInside)
        
        let cameraBtn = UIButton()
        let camBtnImage = UIImage(named:"icons8-camera")
        cameraBtn.setImage(camBtnImage, for: .normal)
        cameraBtn.frame = CGRect(x: self.view.frame.width * 0.65, y: self.view.frame.height * 0.15, width: 200, height: 200)
        cameraBtn.addTarget(self, action: #selector(self.cameraBtn), for: .touchUpInside)
        
        
        self.view.addSubview(cameraBtn)
        self.view.addSubview(navigationBtn)
    }
    
    
    
    
    //導航
    @objc func navigation(){
        
        let url = URL(string: "comgooglemaps://?saddr=&daddr=\(self.lat!),\(self.long!)&directionsmode=driving")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // 若手機沒安裝 Google Map App 則導到 App Store(id443904275 為 Google Map App 的 ID)
            let appStoreGoogleMapURL = URL(string: "itms-apps://itunes.apple.com/app/id585027354")!
            UIApplication.shared.open(appStoreGoogleMapURL, options: [:], completionHandler: nil)
        }
        
    }
    
    @objc func cameraBtn(){
        
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "mapVC")
        {
            let mapVC = controller as! MapViewController
            
            mapVC.travelDetail = self.googleMaplDetail
            
            
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    
    
 
    
    
}
