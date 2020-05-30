//
//  Note.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/5/28.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import Foundation
import UIKit

class Note :Equatable{
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.text == rhs.text
        
        
    }
    
    
    var text: String?
 
    var Days : String?
    var date: String?
    var notearray : [String] = []
 
}
