//
//  startPlanning.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/18.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class StartPlanning: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var data:[Note] = []
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
   // let search = UISearchController(searchResultsController: nil)
    
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
    
   
    func initStatusBarStyle(){
        
        // Set StatusBar Style
        
        self.navigationController?.navigationBar.barStyle = .black
 
        self.navigationController?.navigationBar.tintColor = UIColor.red
        // navigation & status bar 改顏色方法
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 219/255, alpha: 1)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        initStatusBarStyle()
        
    }
    
 
    
}

//extension StartPlanning:StartPlanningDelegate{
//
//    func didFinishUpdate(note:Note){
//        if let index = self.data.firstIndex(of: note){
//
//            let data = Note()
//
//
//        }
//    }
//
//}






