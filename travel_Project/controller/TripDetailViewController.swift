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
    var placeName:String?
    //var photoReference:String?
    
    
    var referenceArray:[String] = []
    
    var messageLabel : [discuss]?
    
    
    
//    @IBOutlet var themephotoUIimage: UIImageView! //大照片
//    @IBOutlet var accessoryUIimage: UIImageView! //小照片
    

    @IBOutlet var tableview: UITableView!
  

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let placeId = self.placeId{
            getMapDetailInfo(placeId)
        }
        self.tableview.delegate = self
        self.tableview.dataSource = self
       
       
        
        
        
    }
    
    
    
    
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
                            
                               
                            }else{
                                break
                            }
                    
                        }//for
                        
                        
                    }
                        
               
                    
                    //  評論
                    if let reviewArray = jsonData["result"]["reviews"].array{
                        
                        
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
       
        return 1
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
//        let cell = tableView.dequeueReusableCell(withIdentifier: "call") as! TripUIImagePicCell
//
//        cell.nameLabel?.text = self.placeName
//
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TripUIImagePicCell

        cell.nameLabel?.text = self.placeName


  
        

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
