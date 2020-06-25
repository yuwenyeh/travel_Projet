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
import MapKit

import Alamofire
import SwiftyJSON
import Kingfisher


class TripPlanViewController: UIViewController {
    
    let currentLocation: CLLocation? = nil
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()//地圖編碼器
    let dbManager = DBManager.shared

    var noteData:Note?
    var sectionIndex:Int?
    var travePlaceList: [TravelDetail]?//景點清單
    var stopLocationNearMap:Bool!//停止搜尋附近
    
    private var nameSearch:UISearchController?
    private var searchText = ""
//    private var presenter : TripPlanViewControllProtocol?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        //測試預設用
        getLocationNearMap(lat: 25.138917 ,long: 121.750889, types: "food")
        
        super.viewDidLoad()
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
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
        }
        
        //搜尋功能
        initView()
    
    }
    
    
    func initView(){
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
                                info.name = data["name"].string
                                info.address = data["vicinity"].string
                                info.placeID =  data["place_id"].string
                              
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
        
            //從google抓圖片
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
            //將字串的日期分開
            let dailyArray = self.noteData?.dailyStr?.split(separator: "_")
            let daily = dailyArray?[Int(self.sectionIndex!)]
            
            var planDetail = self.travePlaceList?[indexPath.row]
            planDetail?.relateId = self.noteData?.id//紀錄父關聯id
            planDetail?.travelDaily = String(daily!)//記錄遊玩日期
            //存入資料庫
            self.dbManager.insertPlanDetail(insertData: planDetail!)

            //導頁
            if let pvc = self.storyboard?.instantiateViewController(withIdentifier: "plan"){
                let planVC = pvc as! PlanViewController
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


//更新搜尋結果協定
extension TripPlanViewController: UISearchResultsUpdating{
    
    //segueprotocol搜尋結果更新
    func updateSearchResults(for searchController: UISearchController) {
        // Avoid continue update searching result when click list item
        guard self.searchText != searchController.searchBar.text else {
            return
        }
        self.searchText = searchController.searchBar.text ?? ""
        //        self.presenter?.onSearchKeyworkChange(keyword: self.searchText)
        self.geoCoder.geocodeAddressString(self.searchText, completionHandler: { placemarks, error in
            
            guard let placemarks = placemarks else{
                return
            }
            //經緯度 只抓第一筆
            let coordinate = placemarks[0].location?.coordinate
            //景點搜尋
            self.getLocationNearMap(lat:coordinate!.latitude , long: coordinate!.longitude, types: "food")
            
        })
    
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
            getLocationNearMap(lat: lat, long: long, types: "tourist_attraction")
            //停止定位
            stopLocationNearMap = true
            locationManager.stopUpdatingLocation()
        }

    }
    
    //錯誤資訊列印
    func locationManager(manager:CLLocationManager!,didFinishDeferredUpdatesWithError error: NSError!){
        print(error)
    }
    
    
}









