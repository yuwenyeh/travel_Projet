//
//  TripUIImagePicCell.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/14.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class TripUIImagePicCell: UITableViewCell {

  
    
    @IBOutlet var allMessage: UILabel!
    
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var timetext: UILabel!
    
    @IBOutlet var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
