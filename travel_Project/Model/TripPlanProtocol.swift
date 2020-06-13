//
//  TripPlanProtocol.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/12.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import Foundation


protocol TripPlanViewControllProtocol: Codable {
    
    func onSearchKeyworkChange(keyword:String?)
  
  
}

class tripPlanInfo:Codable{
    var id :String?
       var name :String?
}
