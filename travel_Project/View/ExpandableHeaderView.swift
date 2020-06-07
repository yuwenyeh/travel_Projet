//
//  ExpandableHeaderView.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/2.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

protocol ExpandbleHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView,section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {

    var delegate : ExpandbleHeaderViewDelegate?
       var section: Int!
       
      override init(reuseIdentifier: String?) {
       super.init(reuseIdentifier : reuseIdentifier)
       self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
           
       }
       
       
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:)has note been implemented")
       }
       @objc func selectHeaderAction(GestureRecognizer: UITapGestureRecognizer){
           let cell = GestureRecognizer.view as! ExpandableHeaderView
           delegate?.toggleSection(header: self, section: cell.section)
       }
       
       func customInit(title:String,section : Int,delegate: ExpandbleHeaderViewDelegate){
           self.textLabel?.text = title
           self.section = section
           self.delegate = delegate
           
       }
       override func layoutSubviews() {
               super.layoutSubviews()
               self.textLabel?.textColor = UIColor.white
               self.contentView.backgroundColor = UIColor.orange
       
       }


}
