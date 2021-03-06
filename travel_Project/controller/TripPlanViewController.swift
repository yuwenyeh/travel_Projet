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


class TripPlanViewController: UIViewController, UISearchBarDelegate {
    
    let currentLocation: CLLocation? = nil
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()//地圖編碼器
    let dbManager = DBManager.shared
    
    var noteData:Note?
    var sectionIndex:Int?
    var travePlaceList: [TravelDetail]?//景點清單
    
    var searchBefore : [String] = []
    var stopLocationNearMap:Bool!//停止搜尋附近
    
    private var nameSearch:UISearchController!//生成一個Search
    private var searchText = ""
    var isShowSearchResult: Bool = true//是否顯示搜尋結果
    
    var travelPlaceType = "tourist_attraction"//搜尋預種類
    
    var searchlat : Double?
    var searchlong : Double?
    var imageType : UIImage?//放Type的照片
    
    
    @IBOutlet weak var segmentedLabel: UISegmentedControl!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        getCurrentLoation()
        //getCurrent() //Alert詢問是否要設定開啟定位
       
        
        tableView.separatorColor = UIColor(white: 0.85, alpha: 1)
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        stopLocationNearMap = false
        
        
        //開啟定位方式最好的方式
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableView.automaticDimension
       
        
        tableView.delegate = self
        tableView.dataSource = self
    
        //利用定位去抓使用者位置並顯示到畫面上
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
         locationManager.startUpdatingLocation() //開啟定位
       


        initView()//搜尋功能畫面
    }//viewDlod
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
            
            let aleat = UIAlertController(title: "打開定位開關", message:"定位服務未開啓,請進入系統設置>隱私>定位服務中打開開關,並允許trip使用定位服務", preferredStyle: .alert)
            let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                
                self.dismiss(animated: true, completion: nil)
                    }
            let callAction = UIAlertAction(title: "立即設置", style: .default) { (action) in
                let url = NSURL.init(string: UIApplication.openSettingsURLString)
                if UIApplication.shared.canOpenURL(url! as URL) {
                    
                    
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url! as URL, options: [:], completionHandler: { (success) in
                           print("跳至設定")
                        })
                       } else {
                        UIApplication.shared.openURL(url! as URL)
                         }
                       }
                   }
                    
                    aleat.addAction(tempAction)
                    aleat.addAction(callAction)
            self.present(aleat, animated: true, completion: nil)
                }
        
        // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    func getCurrentLoation(){//獲取當前位置定位第一次登入請求授權
        self.locationManager.requestWhenInUseAuthorization()
    }

    
//    func getCurrent(){
//    if (CLLocationManager.authorizationStatus() != .denied){
//
//        print("應用擁有定位權限")
//
//    }else {
//
//        let aleat = UIAlertController(title: "打開定位開關", message:"定位服務未開啓,請進入系統設置>隱私>定位服務中打開開關,並允許trip使用定位服務", preferredStyle: .alert)
//        let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
//
//
//                }
//        let callAction = UIAlertAction(title: "立即設置", style: .default) { (action) in
//            let url = NSURL.init(string: UIApplication.openSettingsURLString)
//            if UIApplication.shared.canOpenURL(url! as URL) {
//
//
//                if #available(iOS 10, *) {
//                    UIApplication.shared.open(url! as URL, options: [:], completionHandler: { (success) in
//                       print("跳至設定")
//                    })
//                   } else {
//                    UIApplication.shared.openURL(url! as URL)
//                     }
//                   }
//               }
//
//                aleat.addAction(tempAction)
//                aleat.addAction(callAction)
//        self.present(aleat, animated: true, completion: nil)
//            }
//    }
    

    //搜尋選擇器
    @IBAction func travelTypeBtn(_ sender: UISegmentedControl) {
         
        switch sender.selectedSegmentIndex {
        case 0:
     
            self.travelPlaceType = "tourist_attraction" //地方性
        case 1:
            self.travelPlaceType = "restaurant" //餐廳
        case 2:
            self.travelPlaceType = "shopping_mall" //百貨
        case 3:
            self.travelPlaceType = "department_store" //商店
        case 4:
            self.travelPlaceType = "lodging" //住宿
        default:
            self.travelPlaceType = "tourist_attraction" //旅遊景點
        }
        
        
        //判斷有無經緯度,沒有就不搜尋
        if let lat = self.searchlat , let long = self.searchlong {
        self.getLocationNearMap(lat: lat , long: long ,types:self.travelPlaceType)
        
         }
    }
    
    
    func initView(){
        /* Init SearchController 搜尋功能*/
        self.nameSearch = UISearchController(searchResultsController: nil)
 
        self.nameSearch.searchBar.placeholder = "搜尋景點"
      
        self.tableView.tableHeaderView = nameSearch.searchBar //不要與標題混淆
        self.nameSearch.obscuresBackgroundDuringPresentation = true//搜尋時不要變暗淡
        self.nameSearch.searchBar.backgroundImage = UIImage()
        self.nameSearch.searchBar.barTintColor = .white
        self.nameSearch.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60, alpha: 1)
        self.nameSearch.searchResultsUpdater = self
        self.nameSearch.searchBar.delegate = self
        
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
    
    
//    func getCurrentLocation(){ //獲取當前位置開啟定位
//        //請求採用授權
//        self.locationManager.requestWhenInUseAuthorization()
//    }
    
 
 
    
} //class


extension TripPlanViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let travePlacelList = self.travePlaceList{
            return travePlacelList.count
        }
        return 0
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
            
            
//        guard
            
            
            guard  var planDetail = self.travePlaceList?[indexPath.row] else{
                let controller = UIAlertController(title: "無法取到定位", message: "請開定位服務", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(okAction)
                self.present(controller, animated: true, completion: nil)
               return
                
            }
            planDetail.travelPlaceType = self.travelPlaceType  //建立type分類名稱
            
            planDetail.relateId = self.noteData?.id//紀錄父關聯id
            planDetail.travelDaily = String(daily!)//記錄遊玩日期
            //存入資料庫
            
            self.dbManager.insertPlanDetail(insertData: planDetail)
            
            //導頁
            if let pvc = self.storyboard?.instantiateViewController(withIdentifier: "plan"){
                let planVC = pvc as! PlanViewController
                let count = (self.noteData?.dailyPlan?[self.sectionIndex!].sectionData.count)! - 1
                self.noteData?.dailyPlan?[self.sectionIndex!].sectionData.insert(planDetail ,at: count)
                planVC.notedata = self.noteData
                self.navigationController?.pushViewController(planVC, animated: true)
            }
            
        }
        
        let okAction = UIAlertAction(title: "評價搜尋", style: .default) { (action)->Void in
          
            
            //用guard 解包防呆
            if let tripDvc = self.storyboard?.instantiateViewController(withIdentifier: "TripDvc"), let trave = self.travePlaceList?[indexPath.row]{
                let tripDetailVC = tripDvc as! TripDetailViewController//轉到單一評價
//                let trave = self.travePlaceList[indexPath.row]
                tripDetailVC.placeName = trave.name
                tripDetailVC.placeId = trave.placeID
                self.navigationController?.pushViewController(tripDvc, animated: true)
                
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
        
        //  地圖編碼器
        self.geoCoder.geocodeAddressString(self.searchText, completionHandler: { placemarks, error in
            
            guard let placemarks = placemarks else{
                return
            }
            //經緯度 只抓第一筆
            let coordinate = placemarks[0].location?.coordinate
            //景點搜尋
            self.getLocationNearMap(lat:coordinate!.latitude , long: coordinate!.longitude, types:self.travelPlaceType)
            
        })
        tableView.reloadData()
    }
    
}


extension TripPlanViewController: CLLocationManagerDelegate{
    
    //獲取定位資訊
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations:[CLLocation]){
        
        let currentLocation:CLLocation = locations[locations.count-1] as CLLocation
//        let lat = currentLocation.coordinate.latitude
//        let long = currentLocation.coordinate.longitude
        
        self.searchlat = currentLocation.coordinate.latitude //search 功能給經緯度
        self.searchlong = currentLocation.coordinate.longitude //search功能給經緯度
    
        if(currentLocation.horizontalAccuracy > 0  && !stopLocationNearMap){
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
            
            if let lat = self.searchlat , let long = self.searchlong{
            getLocationNearMap(lat: lat, long: long, types: "tourist_attraction")
            }
                //停止定位
            
            stopLocationNearMap = true
            locationManager.stopUpdatingLocation()
        }
        
    }
    
   
}








