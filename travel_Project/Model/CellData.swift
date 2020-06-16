//
//  CellData.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/6.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import Foundation
import UIKit

 struct CellData {
    
    
    var id:String? //旅遊計畫id
    var isOpen: Bool
    var sectionTitle :String   //日期 4/1
    var sectionData :[TravelDetail] //行程
}
