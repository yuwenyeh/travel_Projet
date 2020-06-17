//
//  Trip-UimagePicCell.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/16.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class Trip_UimagePicCell: UITableViewCell {

    
    
    
    @IBOutlet var allMessage: UILabel! //所有評價
    @IBOutlet var userName: UILabel! //評論者姓名
    @IBOutlet var timetext: UILabel!  //上次評論的時間
    @IBOutlet var messageLabel: UILabel! //評論內容
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
