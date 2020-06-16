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
    
    //var travelDetail : [TravelDetail]?
    var tableViewData:[CellData]?
    var notedata : Note?
    
    weak var delegate : PlanviceControllDelegate?
    
    @IBOutlet weak var arrow: UIImageView!
    
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
        
        //功能還沒寫好
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
            cell.textLabel?.text = tableViewData![indexPath.section].sectionData[indexPath.row - 1].name
            cell.imageView?.image = UIImage(systemName: "arrow.down", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
            
            return cell
            
            //加東西
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            if  tableViewData![indexPath.section].isOpen == true{
                tableViewData![indexPath.section].isOpen = false
                let indexes = IndexSet(integer : indexPath.section)
                tableView.reloadSections(indexes, with: .automatic)
                
            }else{
                tableViewData![indexPath.section].isOpen = true
                let indexes = IndexSet(integer : indexPath.section)
                tableView.reloadSections(indexes, with: .automatic)
            }
            
        }else{
            
            
            let section =  indexPath.section
            
            let cellData = tableViewData?[section].sectionData
            let tripDetail = cellData?[indexPath.row - 1] 
           
            
            if tripDetail?.name != "點擊新增"{
                
                
                if let tripDvc = storyboard?.instantiateViewController(withIdentifier: "TripDvc") {
                    
                    let tripDetailVC = tripDvc as! TripDetailViewController
                    
                    tripDetailVC.placeName = tripDetail?.name
                    tripDetailVC.placeId = tripDetail?.placeID
                    //tripDetailVC.photoReference = tripDetail?.photoReference
                    
                    
                    navigationController?.pushViewController(tripDvc, animated: true)
                
                }
                
                
            }else{
                
                if let vc = storyboard?.instantiateViewController(withIdentifier: "TripPlanVC") {
                    let tripPlanVC = vc as! TripPlanViewController
                    tripPlanVC.noteData = self.notedata
                    tripPlanVC.sectionIndex = indexPath.section
                    navigationController?.pushViewController(tripPlanVC, animated: true)
                }
                
            }
            
 
        }
    }
    
    //增加刪除功能
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete{
            //var  note-> dailyPlan:[CellData]?
            
//            tableViewData.remove(at: indexPath.row)
             
             
         }
        tableView.reloadData()
     }
     
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    
    
    
    
    
    
    
}
