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
    var addjsonData : String? //顯示住址
    var accessorUIimage: String?
    
    var referenceArray:[String] = []
    
   private var messageLabel : [discuss]?//放評論的小盒子
    
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet var imageLabel: UIImageView!
    
    @IBOutlet var namelabel: UILabel! //View店名稱
    @IBOutlet var addressLabel: UILabel! // View地址
    
    
    @IBOutlet var tableview: UITableView!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
            
        }
    
  

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let placeId = self.placeId{
            getMapDetailInfo(placeId)
        }
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        self.namelabel?.text = self.placeName
        
        self.addressLabel?.text = self.addjsonData
       
        
        
    }
    
    
//    func photo(){
//        
//        
//        if let message = messageLabel?(discuss){
//            
//               if let messageLanguage =  {
//                
//                   let urlStr = GoogleApiUtil.createPhotoUrl(ference:
//                    self.accessorUIimage!, width: 400)
//                
//                   let url = URL(string: urlStr)
//                
//                   //self.referenceArray[0].tripImage.kf.setImage(with: url)
//                   self.mainImage.kf.setImage(with: url)
//                }{}
//               }
//        
//        
//        
//    }
    
    
    
    //取詳情
    func getMapDetailInfo(_ placeId:String){
        
        let url = GoogleApiUtil.createMapDetailInfo(placeId: placeId)
        
        Alamofire.request(url).validate().responseJSON { (response) in
            
            if response.result.isSuccess{

                do {
                    let jsonData = try JSON(data: response.data!)
                    
                   
                    
                    if let photoArray = jsonData["result"]["photos"].array{
                        
                        for (index ,photo) in photoArray.enumerated() {
                            
                            if index < 2{
                            
                                self.referenceArray.append(photo["photo_reference"].string!)
                               self.placeName = jsonData["result"]["name"].string
                                self.addjsonData = jsonData["result"]["formatted_address"].string
                               
                            }else{
                                break
                            }
                    
                        }//for
                        
                        
                    }
                   
                    //  評論
                    if let reviewArray = jsonData["result"]["reviews"].array{
                        self.messageLabel = [discuss]()
                        
                        for data in reviewArray{
                        var info = discuss()
                        
                            info.author_name = data["author_name"].string!
                            info.text = data["text"].string!
                            info.timetext = data["relative_time_description"].string!
                            
                            self.messageLabel?.append(info)
              
                        }
                        

                    }
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

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Trip_UimagePicCell

        cell.allMessage?.text = "所有評價"
        //private var messageLabel : [discuss]?
        if let message = messageLabel?[indexPath.row]{
            
            cell.userName?.text = message.author_name
            cell.timetext?.text = message.timetext
            cell.messageLabel.text = message.text
            
        }

  
    

        return cell
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
