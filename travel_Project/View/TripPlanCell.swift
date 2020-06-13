//
//  TripPlanCell.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/3.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class TripPlanCell: UITableViewCell {

    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var locationLabel : UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var startLabel: UIImageView!//星星評價
    
    @IBOutlet var typeLabel : UILabel!
    @IBOutlet var tripImage: UIImageView!
//        {
//        didSet{
//            tripImage.layer.cornerRadius = 50
//            tripImage.clipsToBounds = true
//        }
//    }
    
   
    

    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
