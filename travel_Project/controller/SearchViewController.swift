//
//  SearchViewController.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/22.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


import Alamofire
import SwiftyJSON
import Kingfisher

class SearchViewController: UIViewController,UISearchResultsUpdating {
    
    
    var searchColltroller : UISearchController!
    var searchResults: [String] = [] //儲存搜尋的結果
    
    
    var beforeSearch : [String] = [] //搜尋之前的結果
    var resurtdata: [locationInfo]?//裝小盒子
    
    
    let googleMapUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=23.48386540,120.45358340&rankby=distance&types=tourist_attraction&key=%20AIzaSyCzxPdj1LXGnX0953beVlsZu1CgrobApgk&language=zh-TW"
    
    let pictureUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference="
    
    let apiKey = "AIzaSyD-OVc_frDI7h3KNYjsjB8cr_kiG2K74SY"
    
    
    
    var locationManger:CLLocationManager!//用來查找設備的當前位置
    var crrentLocation:CLLocation?// 當前位置
    var mapView:GMSMapView!
    var placeClient:GMSPlacesClient!
    var zoomLevel:Float = 15.0
    
    
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchColltroller = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchColltroller.searchBar
        
        googleNearBysearch()
        initStatusBarStyle()
        
        searchColltroller.searchResultsUpdater = self  //搜尋結果更新器
        searchColltroller.obscuresBackgroundDuringPresentation = true //搜尋期間要不要變暗淡
        searchColltroller.searchBar.placeholder = "搜尋景點"
        searchColltroller.searchBar.barTintColor = .white
        searchColltroller.searchBar.backgroundImage = UIImage()
        searchColltroller.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60, alpha: 1)
        
    }
    
    // 取資料
    func googleNearBysearch(){
        
        guard let url = URL(string: googleMapUrl) else{
            return
        }
        
        Alamofire.request(url).validate().responseJSON(completionHandler: { response in
            
            if response.result.isSuccess {
                
                do {
                    let jsonData = try JSON(data: response.data!)
                    
                    if let result = jsonData["results"].array{
                        
                        self.resurtdata = [locationInfo]()
                        
                        for data in result{
                            var info =  locationInfo()
                            info.newphotoReference = data["photos"][0]["photo_reference"].string
                            info.newlocationName = data["name"].string
                            info.newlocationAdd = data["plus_code"]["compound_code"].string
                            
                            self.resurtdata?.append(info)
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                }catch  {
                    print("JSONSerialization error:", error)
                }
            }
 
        })
 
    }
    

    //過濾內容的func
    func filterContent(for searchText : String){
        
        searchResults = beforeSearch.filter({ (filterArry) -> Bool in
            let words = filterArry
            let isMach = words.localizedCaseInsensitiveCompare(searchText) //用來查詢搜尋是否在文字裡面
            
            return false
            
            
        })
    }
    
    //實作方法當使用者選取搜尋列,或關鍵字方法會被呼叫
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    func initStatusBarStyle(){
           
           // Set StatusBar Style
           
           self.navigationController?.navigationBar.barStyle = .black
           
           self.navigationController?.navigationBar.tintColor = UIColor.red
           // navigation & status bar 改顏色方法
         
           
          navigationController?.navigationBar.applyy(gradient: [UIColor(red: 19/255, green: 93/255, blue: 14, alpha: 1),UIColor(red: 105/255, green: 255/255, blue: 151/255, alpha: 1),UIColor(red: 0/255, green: 228/255, blue: 255, alpha: 1)])
       }
    
}
extension SearchViewController: UITableViewDelegate{
    
    
}
extension SearchViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
             
             if let localInfo = resurtdata?[indexPath.row]{
                 cell.newPlaceName.text = localInfo.newlocationName!
                cell.newPlaceAdd.text = localInfo.newlocationAdd
                
                 
                //開始抓照片
                 if let photoReference = localInfo.newphotoReference{
                    
                    let urlStr = GoogleApiUtil.createPhotoUrl(ference: photoReference, width: 400)
                     let url = URL(string: urlStr)
                    cell.searchImage.kf.setImage(with: url)
                     
                     
                 }

                }
         return cell
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // if (searchColltroller?.isActive)! {}
            
            if let mapArray = self.resurtdata{
                return mapArray.count
            }

    return 1
  
    }

    
}

extension UINavigationBar{
    
    //將顏色加入指定範圍
      func applyy(gradient colors: [UIColor]) {
         var naviAndStatusBar: CGRect = self.bounds
         naviAndStatusBar.size.height += 45//statusBar和navigationBar的高度
         setBackgroundImage(UINavigationBar.gradiente(size: naviAndStatusBar.size,colors: colors), for: .default)
     }
     
    
    //設定漸層
    static func gradiente(size: CGSize, colors: [UIColor]) ->UIImage{
    
        
        let cgColors = colors.map{$0.cgColor}//將顏色轉換成cgColor
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)//開始繪製的位置
        
        guard let context = UIGraphicsGetCurrentContext() else { return UIGraphicsGetImageFromCurrentImageContext()!}
        
        defer {UIGraphicsEndImageContext()}
        
        var locations: [CGFloat] = [0,1]//顏色位置(座標)
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgColors as NSArray as CFArray, locations: &locations) else { return UIGraphicsGetImageFromCurrentImageContext()! }
        
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: [])//繪製漸層的角度
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
}