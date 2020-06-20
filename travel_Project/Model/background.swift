//
//  background.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/20.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class background: UIViewController {

    
    
    
  
  var gradientLayer: CAGradientLayer!
    
    func  createGradientLayer () {
    gradientLayer = CAGradientLayer ()
    gradientLayer.frame = self .view.bounds
        
        let color = UIColor(red: 0.76, green: 0.88, blue: 0.77, alpha: 0.5).cgColor
        
        let blueGreen = UIColor(red: 0.04, green: 0.52, blue: 0.63, alpha:0.44).cgColor
        
        let titColor = UIColor(red: 1, green: 095, blue:0.74, alpha: 1).cgColor
        
        let blueCOlor = UIColor(red: 0.77, green: 0.87, blue: 0.96, alpha:0.5).cgColor
        
        let green = UIColor(red: 0.77, green: 0.87, blue: 0.96, alpha: 1.00).cgColor
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [ blueGreen,titColor,color,titColor ];
        
        self.view.layer.addSublayer(gradientLayer)
        
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
 
    }
    
    override  func  viewWillAppear (_ animated: Bool) {
        super .viewWillAppear(animated)
        
        createGradientLayer()
        
    }
    



  
}
