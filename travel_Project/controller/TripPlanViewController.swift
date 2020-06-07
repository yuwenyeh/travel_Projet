//
//  TripPlan.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/3.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class TripPlanViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
  
    var noteData:Note?
    
    var sectionIndex:Int?
    var searchController : UISearchController!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tripLabel = ["haha","apple","banana","紀念館"]
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
      
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        
        //        print(noteData)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripLabel.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cellIdentifier = "cell1"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TripPlanCell
        
        
        cell.nameLabel?.text = tripLabel[indexPath.row]
        cell.imageView?.image = UIImage(named: "Mapimage")
        return cell
    }
      
    
    
    
    // MARK: - Table view data source
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
    
    
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //
    //        return 1
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //
    //        return 1
    //    }
    
    
    
    
    
}
