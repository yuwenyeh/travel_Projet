//
//  startPlanning.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/18.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class startPlanning: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var data:[Note] = []
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var button: UIButton!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count == 0 ? 1 : data.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelTableViewCell", for: indexPath) as! TravelTableViewCell
        
        if self.data.count != 0{
            
            let note = self.data[indexPath.row]
            cell.showsReorderControl = true
            
            
            cell.startDay?.text = note.startDate
            cell.travelName?.text = note.travelName
            cell.happyNumber?.text = note.days
            
        }else{
            cell.startDay.text = "日期"
            cell.travelName.text = "旅遊名稱"
            cell.happyNumber.text = "天數"
        }
        
        return cell
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.delegate = self
        self.tableview.dataSource = self
    }
    

       }
       
       
       
       //
     
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


