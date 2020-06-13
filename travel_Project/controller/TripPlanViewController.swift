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
    
    var stopLocationNearMap = false//停止搜尋附近

    
    private var travePlacelList: [TravelDetail]?
    private var nameSearch:UISearchController?
    private var searchText = ""
    private var presenter : TripPlanViewControllProtocol?
    
    @IBOutlet var txtSearch: UITextField!
    @IBAction func locationTapped(_ sender: Any) {
        
        gotoPlaces()
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    let currentLocation: CLLocation? = nil
    let locationManager = CLLocationManager()
    var noteData:Note?
    var mapView : GMSMapView!
    var placeClient:GMSPlacesClient!
    var zoomLevel:Float = 15.0
    
    var sectionIndex:Int?
    
    
    
//    getlastestBox()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
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
    
    
    func initView(){
        /* Init SearchController 搜尋功能*/
        self.nameSearch = UISearchController(searchResultsController: nil)
        
        self.nameSearch?.initStyle(updater: self, placeholoderTxt: NSLocalizedString("Please input the search keyword", comment: ""))
        self.navigationItem.searchController = self.nameSearch
        // Hide the search bar when scrolling up, Default is true. if setup as false it will always display
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "googleCell"{
            let googleViewControll = segue.description as? MapVC
            let detailInfo = sender as! tripPlanInfo
            
            googleViewControll?.tripInfo = detailInfo
        }
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
                        self.travePlacelList = [TravelDetail]()
                        
                        for data in result{
                            var info =  TravelDetail()
                            
                            let photoReference = data["photos"][0]["photo_reference"].string
                            
                            if photoReference != nil {
                                
                                let lat = data["geometry"]["location"]["lat"]
                                let lng = data["geometry"]["location"]["lng"]
                                
                                info.name = data["name"].string!
                                info.address = data["vicinity"].string!
                                info.photoReference = photoReference
                                info.centerLatLngStr = "\(lat),\(lng)"
                                self.travePlacelList?.append(info)
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
    
    
    func gotoPlaces(){
        txtSearch.resignFirstResponder()//辭職。 第一。 回應者
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        
    }
    
    func getCurrentLocation(){
        //請求採用授權
        self.locationManager.requestWhenInUseAuthorization()
    }
    
   
    
} //class





extension TripPlanViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let travePlacelList = self.travePlacelList{
            return travePlacelList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TripPlanCell
        
        if let localInfo = travePlacelList?[indexPath.row]{
            cell.nameLabel?.text = localInfo.name
            
            if let photoReference = localInfo.photoReference{
                let urlStr = GoogleApiUtil.createPhotoUrl(ference: photoReference, width: 400)
                let url = URL(string: urlStr)
                cell.tripImage.kf.setImage(with: url)
            }
        }
        return cell
    }
    
    
}

extension TripPlanViewController: UITableViewDelegate{
    
    
    
    
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
    
    func locationManager(manager:CLLocationManager!,didUpdateLocations locations :[AnyObject]!){
        //取得locations陣列的最後一個
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        print("自己的位置\(locationManager)")
        //判斷是否為空
        if(location.horizontalAccuracy>0){
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            var lat = location.coordinate.latitude
            //停止定位
        }
        func VIewDidDispappear(animated: Bool){
            locationManager.stopUpdatingHeading()
        }
        
    }
    
    //錯誤資訊列印
    func locationManager(manager:CLLocationManager!,didFinishDeferredUpdatesWithError error: NSError!){
        print(error)
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

// MARK: - Table view data source





