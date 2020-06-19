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

class TripDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var noteData: Note?
    
    //從前頁帶過來3個變數
    var placeId:String?
    var placeName:String? //顯示飯店名稱
    var photoReference:String?
    
    
    
    @IBOutlet weak var tbl_height: NSLayoutConstraint!
    var accessorUIimage: String?
    
    var referenceArray:[String] = []
    
    private var messageLabel : [discuss]?//放評論的小盒子
    
    
    @IBOutlet weak var mainImage: UIImageView! //大照片
    @IBOutlet var imageLabel: UIImageView!
    @IBOutlet weak var threeImage: UIImageView!//第三張照片(View)
    
    
    
    @IBOutlet var addressLabel: UILabel! //顯示住址
    
    @IBOutlet var tableview: UITableView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        navigationItem.title = self.placeName
        
        if let placeId = self.placeId{
            getMapDetailInfo(placeId)
            
        }
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ aminated: Bool){
        
        self.tableview.addObserver(self, forKeyPath: "contentSize", options: .new
            , context: nil)
        self.tableview.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated:Bool){
        
        self.tableview.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"
        {
            
                if let newvalue = change?[.newKey]{
                    let newsize = newvalue as! CGSize
                    self.tbl_height.constant = newsize.height
                
                    
                }
            
            
        }
    }
    
    
    
    
    
    //設置照片
    func setPhoto(){
        
        if !referenceArray.isEmpty {
            
            for  (index,reference) in referenceArray.enumerated() {
                
                if index == 0{
                    //照片1
                    let  urlStr = GoogleApiUtil.createPhotoUrl(ference: reference, width: 400)
                    let  url = URL(string: urlStr)
                    self.mainImage.kf.setImage(with: url)
                }
                if index == 1{
                    //照片2
                    let urlStr = GoogleApiUtil.createPhotoUrl(ference: reference, width: 400)
                    let  url = URL(string: urlStr)
                    self.imageLabel.kf.setImage(with: url)
                    
                }
                if index == 2{
                    //照片2
                    let urlStr = GoogleApiUtil.createPhotoUrl(ference: reference, width: 400)
                    let  url = URL(string: urlStr)
                    self.threeImage.kf.setImage(with: url)
                    
                }
                
            }
            
        }else{}
        
    }
    
    
    
    //取詳情
    func getMapDetailInfo(_ placeId:String){
        
        let url = GoogleApiUtil.createMapDetailInfo(placeId: placeId)
        
        Alamofire.request(url).validate().responseJSON { (response) in
            
            if response.result.isSuccess{
                
                do {
                    let jsonData = try JSON(data: response.data!)
                    
                    //取照片參照碼
                    if let photoArray = jsonData["result"]["photos"].array{
                        
                        for (index ,photo) in photoArray.enumerated() {
                            
                            if index < 3{
                                self.referenceArray.append(photo["photo_reference"].string!)
                                self.placeName = jsonData["result"]["name"].string
                                self.addressLabel.text = jsonData["result"]["formatted_address"].string
                                
                            }else{
                                break
                            }
                            
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
                    
                    self.setPhoto()
                    self.tableview.reloadData()
                    
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Trip_UimagePicCell
        
        
        cell.allMessage?.text = "所有評價"
        
        if let message = messageLabel?[indexPath.row]{
            
            
            cell.userName?.text = message.author_name //評論者姓名
            cell.timetext?.text = message.timetext //上次評論的時間
            cell.messageLabel?.text = message.text// 評論的內容
            cell.startUIImage.image = message.star//星星
            
           //讓文字展開
            cell.messageLabel.numberOfLines = 0
            
            //從google抓照片
            if let user = message.user{
                let urlStr = GoogleApiUtil.createPhotoUrl(ference: user, width:150)
                let url = URL(string: urlStr)
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
        
        return star
        
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
