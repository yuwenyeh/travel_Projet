//
//  Planning.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/2.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class Planning: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //    struct CellData {
    //      var isOpen: Bool
    //      var sectionTitle :String
    //      var sectionData :[String]
    //  }
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewData1 = [Note]()
    
    
    var tableViewData = [CellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData = [
            CellData(isOpen: false, sectionTitle:"11/1", sectionData: ["吃冰","紀念館"]),
            CellData(isOpen: false, sectionTitle: "11/2", sectionData: ["吃香蕉"]),
            CellData(isOpen: false, sectionTitle: "11/3", sectionData: ["吃水果"])
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if tableViewData[section].isOpen == true{
            return tableViewData[section].sectionData.count + 1
            
        }else{
            return 1
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            cell.textLabel?.text = tableViewData[indexPath.section].sectionTitle
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  tableViewData[indexPath.section].isOpen == true{
            tableViewData[indexPath.section].isOpen = false
            let indexes = IndexSet(integer : indexPath.section)
            tableView.reloadSections(indexes, with: .automatic)
            
        }else{
            tableViewData[indexPath.section].isOpen = true
            let indexes = IndexSet(integer : indexPath.section)
            tableView.reloadSections(indexes, with: .automatic)
        }
        
    }
}

