//
//  TravelTableViewCell.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/5/30.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class TravelTableViewCell: UITableViewCell {
 
    
    @IBOutlet  var startDay: UILabel!
    @IBOutlet  var travelName : UILabel!
    @IBOutlet  var happyNumber: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}