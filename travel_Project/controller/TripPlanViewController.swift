//
//  TripPlan.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/3.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class TripPlanViewController: UIViewController {

    
    var sights : String?
    
    var noteData:Note?
    
    var sectionIndex:Int?
    
    
    @IBOutlet var Sights: UISearchBar!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(noteData)

       
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 0
//    }

    
    
   

}
