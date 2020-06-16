//
//  TripPlan.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/3.
//  Copyright © 2020 葉育彣. All rights reserved.
//0266166000

import UIKit
import GooglePlaces
import GoogleMaps

import Alamofire
import SwiftyJSON
import Kingfisher


class TripPlanViewController: UIViewController, UISearchResultsUpdating{
    
    
    var noteData:Note?
    var sectionIndex:Int?
    
    
    var stopLocationNearMap:Bool!//停止搜尋附近
    
    let currentLocation: CLLocation? = nil
    let locationManager = CLLocationManager()
    var mapView : GMSMapView!
    var placeClient:GMSPlacesClient!
    var zoomLevel:Float = 15.0
    
    private var travePlaceList: [TravelDetail]?//景點清單
    private var nameSearch:UISearchController?
    private var searchText = ""
    
    private var presenter : TripPlanViewControllProtocol?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
 
    
    override func viewDidLoad() {
        
        
        getLocationNearMap(lat: 25.138917 ,long: 121.750889, types: "food")
        
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        stopLocationNearMap = false
        
        //開啟定位方式最好的方式
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableView.automaticDimension
        getCurrentLocation()
        
        //利用定位去抓使用者位置並顯示到畫面上
        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.startUpdatingLocation() //開啟定位
        locationManager.requestAlwaysAuthorization()
        
        if #available(iOS 10.0,*){
            locationManager.requestAlwaysAuthorization()
        }else{
            
        }
    }
    
    
    func initView(){ //根本沒進來
        /* Init SearchController 搜尋功能*/
        self.nameSearch = UISearchController(searchResultsController: nil)
        
        self.nameSearch?.initStyle(updater: self, placeholoderTxt: NSLocalizedString("Please input the search keyword", comment: ""))
        self.navigationItem.searchController = self.nameSearch
        // /向上滾動時隱藏搜索欄，默認為true。 如果設置為false，它將始終顯示
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    
    
    /*搜尋附近景點*/
    func getLocationNearMap(lat:Double,long:Double,types:String){
        
        let nearMapUrl = GoogleApiUtil.createNearMapUrl(lat: lat, lng: long, types:types)
        
        guard let boxUrl = URL(string:nearMapUrl)else{
            return
        }
        
        Alamofire.request(boxUrl).validate().responseJSON { (response) in
            
            if response.result.isSuccess{
                
                do {
                    let jsonData = try JSON(data: response.data!)
                    
                    if let result = jsonData["results"].array{
                        self.travePlaceList = [TravelDetail]()
                        
                        for data in result{
                            var info =  TravelDetail()
                            
                            let photoReference = data["photos"][0]["photo_reference"].string
                            
                            if photoReference != nil {
                                let lat = data["geometry"]["location"]["lat"]
                                let lng = data["geometry"]["location"]["lng"]
                                info.name = data["name"].string!
                                info.address = data["vicinity"].string!
                                info.placeID =  data["place_id"].string!
                              
                                info.photoReference = photoReference
                                
                                
                                
                                info.centerLat = Double("\(lat)")
                                info.centerLng = Double("\(lng)")
                                
                                self.travePlaceList?.append(info)
                            }
                            
                        }// for
                        
                        self.tableView.reloadData()
                        
                    }
                    
                }catch  {
                    print("JSONSerialization error:", error)
                }
            }
        }
    }
    
    
    //segueprotocol搜尋結果更新
    func updateSearchResults(for searchController: UISearchController) {
        // Avoid continue update searching result when click list item
        guard self.searchText != searchController.searchBar.text else {
            return
        }
        self.searchText = searchController.searchBar.text ?? ""
        self.presenter?.onSearchKeyworkChange(keyword: self.searchText)
    }
    
    
    func getCurrentLocation(){
        //請求採用授權
        self.locationManager.requestWhenInUseAuthorization()
    }
    
 
    
} //class





extension TripPlanViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let travePlacelList = self.travePlaceList{
            return travePlacelList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TripPlanCell
        
        if let travePlace = travePlaceList?[indexPath.row]{
            
            cell.nameLabel?.text = travePlace.name
            cell.address?.text = travePlace.address
            
            if let photoReference = travePlace.photoReference{
                let urlStr = GoogleApiUtil.createPhotoUrl(ference: photoReference, width: 400)
                let url = URL(string: urlStr)
                cell.tripImage.kf.setImage(with: url)
            }
            
        }
        return cell
    }
    
    
}

extension TripPlanViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController()
        
        let storeFile = UIAlertAction(title: "加入行程", style: .default) { (action) in
            
        
            let planDetail = self.travePlaceList?[indexPath.row]
            
            
            if let pvc = self.storyboard?.instantiateViewController(withIdentifier: "plan"){
                let planVC = pvc as! PlanViewController
                // let travelArray = [TravelDetail]()
                //                let celldetail  = plan.notedata?.dailyPlan[1].sectionData[1
                let count = (self.noteData?.dailyPlan?[self.sectionIndex!].sectionData.count)! - 1
                
                self.noteData?.dailyPlan?[self.sectionIndex!].sectionData.insert(planDetail! ,at: count)
                
                planVC.notedata = self.noteData
                self.navigationController?.pushViewController(planVC, animated: true)
                
            }
            
            
            
            
        }
        
        let okAction = UIAlertAction(title: "地圖導覽", style: .default) { (action)->Void in
            
            let selectedTravelDetail = self.travePlaceList?[indexPath.row]//選好的景點
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapVC"){
                let mapVC = vc as! MapViewController
                mapVC.travelDetail = selectedTravelDetail
                mapVC.noteData = self.noteData
                mapVC.sectionIndex = self.sectionIndex
                self.navigationController?.pushViewController(mapVC, animated: true)
                
            }
        }
        let deleteAction = UIAlertAction(title: "Cancel", style: .cancel) { (action)->Void in
            print("按下取消")
        }
        
        
        
        alertController.addAction(storeFile)
        alertController.addAction(okAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true,completion: nil)
    }
    
    
    
    
}



extension TripPlanViewController: CLLocationManagerDelegate{
    
    
    
    //獲取定位資訊
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations:[CLLocation]){
        let currentLocation:CLLocation = locations[locations.count-1] as CLLocation
        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        
        
        if(currentLocation.horizontalAccuracy > 0  && !stopLocationNearMap){
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            getLocationNearMap(lat: lat, long: long, types: "food")
            //停止定位
            stopLocationNearMap = true
            locationManager.stopUpdatingLocation()
            
            
        }
        
        
        
        
    }
    
    //    func locationManager(manager:CLLocationManager!,didUpdateLocations locations :[AnyObject]!){
    //        //取得locations陣列的最後一個
    //        var location:CLLocation = locations[locations.count-1] as! CLLocation
    //        print("自己的位置\(locationManager)")
    //        //判斷是否為空
    //        if(location.horizontalAccuracy>0){
    //            print(location.coordinate.latitude)
    //            print(location.coordinate.longitude)
    //
    //            var lat = location.coordinate.latitude
    //            //停止定位
    //        }
    //        func VIewDidDispappear(animated: Bool){
    //            locationManager.stopUpdatingHeading()
    //        }
    //
    //    }
    
    //錯誤資訊列印
    func locationManager(manager:CLLocationManager!,didFinishDeferredUpdatesWithError error: NSError!){
        print(error)
    }
    
    
}



// MARK: - Table view data source





