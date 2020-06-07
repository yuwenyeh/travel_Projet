//
//  Note.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/5/28.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import Foundation
import UIKit

class  Note :Equatable{
    
    
    var travelName: String? //行程名稱
    var startDate: String? //出發日期
    var days : String?  //天數
    var dailyPlan:[CellData]?//行程計畫詳情
    var addFlag = false//是否已新增行程
    
    

  

 
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.travelName == rhs.travelName
    }
    
}




