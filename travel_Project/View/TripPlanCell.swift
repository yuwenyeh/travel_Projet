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

    
    @IBOutlet var typeLabel : UILabel!
    @IBOutlet var tripImage: UIImageView!

   
    

    
   
    
    
    

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
