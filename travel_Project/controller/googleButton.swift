//
//  googleButton.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/20.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit



@IBDesignable
class googleButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 0.0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat = 0.0 {
        didSet{
            layer.borderWidth = BorderWidth
        }
    }
    @IBInspectable var borderColor : UIColor = .black {
     
        didSet{
            layer.borderColor = borderColor.cgColor
        }
        
        
    }
    
}
