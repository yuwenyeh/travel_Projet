//
//  Travel+name+detal.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/5/28.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class Travel_name_detal: UITableViewController,welcomeDelegate {
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count == 0 ? 1 : data.count
    }
    
    //呼叫tableview轉場方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        let nextwelcomeID = self.storyboard?.instantiateViewController(withIdentifier: "welcomeID") as! welcomeTravel
////          welcome.delegate = self
//         nextwelcomeID.delegate = self
//
//        self.navigationController?.pushViewController(nextwelcomeID, animated: true)
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelTableViewCell", for: indexPath) as! TravelTableViewCell
        
    
        
        if self.data.count != 0{
            
            let note = self.data[indexPath.row]
            cell.showsReorderControl = true
            
            cell.textLabel?.text = note.text
            
            cell.data?.text = note.date
            cell.Days?.text = note.Days
            
        }else{
            cell.nameLabel.text = "旅遊名稱"
            cell.data.text = "日期"
            cell.Days.text = "天數"
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueWelcome"{

           // let welcome =  .destination as! welcomeTravel

        //       welcome.delegate = self
            
//            if let indexPath = self.tableView.indexPathForSelectedRow{
//
////                let note = self.data[indexPath.row]
////                welcome.note = note
//                welcome.delegate = self
//
//            }
            
        }
    }
    
    
    
    //
    func didFinishUpdate(_ note: Note){
        
        data.append(note);
        
        if let index = self.data.firstIndex(of : note){
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}
