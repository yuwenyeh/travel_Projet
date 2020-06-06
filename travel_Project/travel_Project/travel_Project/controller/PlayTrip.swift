//
//  Travel+name+detal.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/5/28.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class PlayTrip: UITableViewController,welcomeDelegate {
    
    var data :[Note] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //要顯示多少row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count == 0 ? 1 : data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    //呼叫tableview轉場方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //        let nextwelcomeID = self.storyboard?.instantiateViewController(withIdentifier: "welcomeID") as! welcomeTravel
    //        welcome.delegate = self
        //         nextwelcomeID.delegate = self
        //
        //        self.navigationController?.pushViewController(nextwelcomeID, animated: true)
        

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueWVC"{
            
            let welcome =  segue.destination as! welcomeTravel
            
            welcome.delegate = self
            
        }
    }
    
    
    
    //
    func didFinishUpdate(_ note: Note){
        
        data.append(note);
        
        //新增table row
        let dataCount =  data.count - 1
        
        //第一次新增 不增加row
        if(dataCount != 0){
            let rowIndex = IndexPath(row: dataCount, section: 0)
            self.tableView.insertRows(at: [rowIndex], with: .automatic)
        }
     
        
      
        let indexPath = IndexPath(row: dataCount, section: 0)
        
        //insert cell
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    
}
