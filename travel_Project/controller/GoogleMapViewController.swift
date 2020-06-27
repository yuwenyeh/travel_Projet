//
//  GoogleMapViewController.swift
//  travel_project
//  Created by 葉育彣 on 2020/6/23.
//  Copyright © 2020 葉育彣. All rights reserved.
import UIKit
import GoogleMaps
import GooglePlaces

import Alamofire
import SwiftyJSON

class GoogleMapViewController: UIViewController,CLLocationManagerDelegate {
    
    
    var googleMaplDetail : TravelDetail?
    var lat:Double?
    var long:Double?
    
    var type = "driving"//交通方式 寫死
    
    var clat:Double? = 25.138917//預設當前位置
    var clong:Double? = 121.750889
    
    var mapView: GMSMapView!
    let currentLocation: CLLocation? = nil
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let travelMap = googleMaplDetail{
            self.lat = travelMap.centerLat
            self.long = travelMap.centerLng
            //製作地圖
            let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 10.0)
            self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            self.view = self.mapView
            //插地標
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            marker.map = mapView
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //導航鈕
        let navigationBtn = UIButton()
        let btnImage = UIImage(named: "googleMap-1")
        navigationBtn.setImage(btnImage, for: .normal)
        navigationBtn.frame = CGRect(x: self.view.frame.width * 0.75, y: self.view.frame.height * 0.35, width: 100 , height: 100)
        navigationBtn.addTarget(self, action: #selector(self.navigation), for: .touchUpInside)
        
        //街景扭
        let cameraBtn = UIButton()
        let camBtnImage = UIImage(named:"locationName")
        cameraBtn.setImage(camBtnImage, for: .normal)
        cameraBtn.frame = CGRect(x: self.view.frame.width * 0.75, y: self.view.frame.height * 0.20, width: 100, height: 100)
        cameraBtn.addTarget(self, action: #selector(self.cameraBtn), for: .touchUpInside)
        
        //路徑鈕
        let pathBtn = UIButton()
        let pathImage = UIImage(named:"AB")
        pathBtn.setImage(pathImage, for: .normal)
        pathBtn.frame = CGRect(x: self.view.frame.width * 0.75, y: self.view.frame.height * 0.50, width: 100, height: 100)
        pathBtn.addTarget(self, action: #selector(self.createGoogleMapPath), for: .touchUpInside)
        
        self.view.addSubview(cameraBtn)
        self.view.addSubview(navigationBtn)
        self.view.addSubview(pathBtn)

    }
    
    
    //產生地圖路線
     @objc func createGoogleMapPath(){
        
        let mapPathUrl = GoogleApiUtil.createMapPathUrl(cLat:self.clat!, cLong:self.clong!, dLat:self.lat!, dLng:self.long! , mode: self.type)
        
        guard let url = URL(string:mapPathUrl)else{
            return
        }
        
        Alamofire.request(url).validate().responseJSON { (response) in
            
            if response.result.isSuccess{
                
                do {
                    let jsonData = try JSON(data: response.data!)
                    
                    guard let routers = jsonData["routes"].array else{
                        return
                    }
                    
                        let routeOverviewPolyline = routers[0]["overview_polyline"]
                        let points = routeOverviewPolyline["points"].string
                    
                        DispatchQueue.main.async(execute: {
                            let path = GMSPath(fromEncodedPath: points!)
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeWidth = 5.0
                            polyline.strokeColor = UIColor.green
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            polyline.map = self.mapView

                        })
                     
                }catch {
                    print("JSONSerialization error:", error)
                }
                
            }
            
        }
        
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
    
    
    //獲取定位資訊
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations:[CLLocation]){
        
        let currentLocation:CLLocation = locations[locations.count-1] as CLLocation
        
        self.clat = currentLocation.coordinate.latitude //search 功能給經緯度
        self.clong = currentLocation.coordinate.longitude //search功能給經緯度
        
        if(currentLocation.horizontalAccuracy > 0){
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            //停止定位
            locationManager.stopUpdatingLocation()
        }
        
    }

    

}



