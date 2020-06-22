//
//  SearchCell.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/22.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet var searchImage: UIImageView!
    
    @IBOutlet var newPlaceName: UILabel!
    
    @IBOutlet var newPlaceAdd: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
