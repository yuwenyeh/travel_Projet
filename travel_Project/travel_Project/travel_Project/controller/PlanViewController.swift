//
//  Planning.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/2.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

protocol PlanviceControllDelegate :class{
    func didFinishUpdate(_ note:Note)
}

class PlanViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var tableViewData:[CellData]?
    var notedata : Note?
    
    weak var delegate : PlanviceControllDelegate?
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!//導航列
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let noteData = notedata{
            self.tableViewData = noteData.dailyPlan
            navItem.title = noteData.travelName//設定導航列標題文字
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func addCellLabel(_ sender: Any) {
        

//        let  CellData(isOpen: false, sectionTitle: <#T##String#>, sectionData: <#T##[String]#>)
        
//        if let noteDate = notedata{
//            self.tableViewData?.append(contentsOf:CellData)
//        }
        
        
        
//        let indexPath = IndexPath(row:0, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return tableViewData!.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData![section].isOpen == true{
            return tableViewData![section].sectionData.count + 1
            
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            cell.textLabel?.text = tableViewData![indexPath.section].sectionTitle
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = tableViewData![indexPath.section].sectionData[indexPath.row - 1].place
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  tableViewData![indexPath.section].isOpen == true{
            tableViewData![indexPath.section].isOpen = false
            let indexes = IndexSet(integer : indexPath.section)
            tableView.reloadSections(indexes, with: .automatic)
            
        }else{
            tableViewData![indexPath.section].isOpen = true
            let indexes = IndexSet(integer : indexPath.section)
            tableView.reloadSections(indexes, with: .automatic)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playVC"{
            let indexPath = segue.destination as! PlayTrip
            
        }
    }
    
    
    
    
    
    
    
    
}
