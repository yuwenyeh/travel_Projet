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

class TripDetailViewController: UITableViewController {

    

    
    var placeId:String?
    var placeName:String?
    var photoReference:String?
    
    
    var img_1:UIImage?
    var img_2:UIImage?
    
    
    
    
    
    var placeClient:GMSPlacesClient!
    
    // A hotel in Saigon with an attribution.
//    let placeID = "ChIJV4k8_9UodTERU5KXbkYpSYs"

    // Specify the place data types to return.
    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue))!
      

    
    
    

    
  
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let placeId = self.placeId{
            getMapDetailInfo(placeId)
        }
        
    }
    
    
    //取詳情
    func getMapDetailInfo(_ placeId:String){
        
        let url = GoogleApiUtil.createMapDetailInfo(placeId: placeId)
        
        Alamofire.request(url).validate().responseJSON { (response) in
            
            if response.result.isSuccess{
                
        
                do {
                    
                    let jsonData = try JSON(data: response.data!)
                    
                    
                    
                    if let photoArray = jsonData["result"]["photos"].array{
                        
                        print(photoArray)
                        
                    }
                    
                    
                    
                    
                    
                    //  評論
                    if let reviewArray = jsonData["result"]["reviews"].array{
                        
                        print(reviewArray)
                        
                    }
                    
                    
                    
                }catch{
                    print("JSONSerialization error:", error)
                }
                
                
            }
            
        }
        
        
    
        
    }
    
    
    
 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

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
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
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
