//
//  TripDetailViewController.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/14.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

import GooglePlaces
import GoogleMaps

import Alamofire
import SwiftyJSON
import Kingfisher

class TripDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    var noteData: Note?
    
    //從前頁帶過來3個變數
    var placeId:String?
    var placeName:String? //顯示飯店名稱
    var photoReference:String?
    
    
    var accessorUIimage: String?
    
    var referenceArray:[String] = [] //裝照片參照碼
    var moreImage : [UIImageView] = [] //裝照片
    private var messageLabel : [discuss]?//放評論的小盒子
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var mainImage: UIImageView!//主要照片
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = self.placeName
        
        if let placeId = self.placeId{
            getMapDetailInfo(placeId)
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    
    func getPhoto(){
        
        if !referenceArray.isEmpty{
            let  urlStr = GoogleApiUtil.createPhotoUrl(ference: referenceArray[0], width: 400)
            let  url = URL(string: urlStr)
            self.mainImage.kf.setImage(with: url)
        }
        
    }
    
    
    
    //取詳情
    func getMapDetailInfo(_ placeId:String){
        //取景點一個位置
        let url = GoogleApiUtil.createMapDetailInfo(placeId: placeId)
        
        Alamofire.request(url).validate().responseJSON { (response) in
            
            if response.result.isSuccess{
                
                do {
                    let jsonData = try JSON(data: response.data!)
                    
                    self.placeName = jsonData["result"]["name"].string
                    
                    //取照片參照碼
                    if let photoArray = jsonData["result"]["photos"].array{
                        
                        for photo in photoArray {
                            self.referenceArray.append(photo["photo_reference"].string!)
                        }//for
                        
                    }
                    
                    //取評論
                    if let reviewArray = jsonData["result"]["reviews"].array{
                        
                        self.messageLabel = [discuss]()
                        for data in reviewArray{
                            
                            var info = discuss()
                            let user = data["profile_photo_url"].string //取使用者頭像
                            if user != nil {
                                info.author_name = data["author_name"].string!
                                info.text = data["text"].string!
                                info.timetext = data["relative_time_description"].string!
                                info.star =  self.getStar(rating:Int(data["rating"].int!))
                                info.user = user
                                
                                self.messageLabel?.append(info)
                            }
                        }
                        
                    }
                    
                    self.getPhoto()
                    self.tableView.reloadData()
                    
                }catch{
                    print("JSONSerialization error:", error)
                }
            }
        }
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageLabel?.count ?? 1
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Trip_UimagePicCell
        
        cell.allMessage?.text = "所有評價"
        
        if let message = messageLabel?[indexPath.row]{
            
            cell.userName?.text = "發表人:  \(message.author_name!)"  //評論者姓名
            cell.timetext?.text = "發表時間:  \(message.timetext!)" //上次評論的時間
            cell.messageLabel?.text = "發表內容:  \(message.text!)"// 評論的內容
            cell.startUIImage.image = message.star!//星星
            //讓文字展開
            cell.messageLabel.numberOfLines = 0
            
            //評論者照片
            if let user = message.user{
                let url = URL(string: user)
                cell.Userphoto.kf.setImage(with: url)
            }
            
        }
        
        
        return cell
    }
    
    
    
    
    
    
    func getStar(rating:Int) ->UIImage!{
        
        var star:UIImage?
        
        switch rating {
            
        case 1:
            star = UIImage(named: "Star_rating_1_of_5")
        case 2:
            star = UIImage(named: "Star_rating_2_of_5")
        case 3:
            star = UIImage(named: "Star_rating_3_of_5")
        case 4:
            star = UIImage(named: "Star_rating_4_of_5_")
        case 5:
            star = UIImage(named: "Star_rating_5_of_5")
        case nil:
            star = UIImage(named: "Star_rating_0_of_5")
        default:
            star = UIImage(named: "Star_rating_0_of_5")
        }
        
        return star!
        
    }
    
    
    
    
}
