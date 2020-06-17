//
//  DesireView.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/17.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import Foundation
import UIKit

 class DesignView: UIView {
    
    var cornerRadius : CGFloat = 0
    
    var  shadowColor: UIColor? = UIColor.black
    
    var shadowOffSetWidth : Int = 0
    var shadwOffSetHeight : Int = 1
    
    var shadowOpacity : Float = 0.2
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        
        layer.shadowColor = shadowColor?.cgColor
        
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadwOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.shadowPath = shadowPath.cgPath
        
        layer.shadowOpacity = shadowOpacity
        
    }
    
    
    
    
}
