//
//  LuggageListViewController.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/28.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class LuggageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var selectIndex:Int?//選取的計畫(儲存用)
    
    var checkList = ["護照","錢包","信用卡","當地貨幣","交通卡","耳機","充電器","轉接器","相機","電池","防曬乳","藥物","外套","內衣","襪子","墨鏡","聯繫人聯絡方式","保養品"] //18個
    var isChecked = [String]()//勾選狀態
    
    
    var data:[Note] = []
    let dbManager = DBManager.shared
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.myCollectionView.dataSource = self
        self.myCollectionView.delegate = self
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "行李清單"
        //初始化
        isChecked = Array(repeating: "N", count:checkList.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //讀取資料
        self.data = DBManager.shared.loadTravelPlans()
        //初始化勾選狀態 預設第一個行程
        if !data.isEmpty{
            if data[0].isChecked != nil{
                let isCheckArray = data[0].isChecked?.split(separator: "_").map(String.init)
                self.isChecked = isCheckArray!
            }
        }
        self.myCollectionView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = self.checkList[row]//項目
        if self.isChecked[row] == "Y" {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        isChecked[row] = isChecked[row] == "Y" ? "N": "Y"
        self.tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: true)
    }
    
}

extension LuggageListViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! MyCollectionCell
        
        if self.data.count > 0{
            let note = self.data[indexPath.row]
            let dailyStrArray = note.dailyStr?.split(separator: "_")
            cell.startDay?.text = "日期:\(note.startDate!) - \(dailyStrArray![dailyStrArray!.count - 1])"
            cell.travelName?.text = "旅遊名稱:  \(note.travelName!)"
            cell.happyNumber?.text = "天數:\(note.days!)天"
            let number = Int.random(in: 1 ..< 4 )
            cell.myImageView.image = UIImage(named: "pic\(number)")
            cell.myImageView.layer.cornerRadius = 10
            
        }else{
            cell.startDay?.text = "日期:"
            cell.travelName?.text = "旅遊名稱:"
            cell.happyNumber?.text = "天數:天"
            let number = Int.random(in: 1 ..< 4 )
            cell.myImageView.image = UIImage(named: "pic\(number)")
            cell.myImageView.layer.cornerRadius = 10
        }
        
        return cell
    }
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectIndex = indexPath.row
        var note = data[indexPath.row]
        
        let alertController = UIAlertController()
        let OokAction = UIAlertAction(title: "儲存行李清單", style: .default) { (action)-> Void in
            print("使用者按下ok")
            
            if note.id != nil{
                let id = note.id
                let str = self.isChecked.joined(separator: "_")
                self.dbManager.updateMovie(withID:id!,isChecked:str)
                
            }else{
                
            }
            
        }
        
        let loadAction = UIAlertAction(title: "讀取行李清單", style: .default) { (action)-> Void in
            print("使用者按下ok")
            //讀取資料
            self.data = DBManager.shared.loadTravelPlans()
            note = self.data[indexPath.row]
            if note.isChecked != nil {
                let isCheckArray = note.isChecked?.split(separator: "_").map(String.init)
                self.isChecked = isCheckArray!
                self.tableView.reloadData()
            }else{
                //初始化
                self.isChecked = Array(repeating: "N", count:self.checkList.count)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){(action) ->Void in
            print("使用者按下取消")
        }
        
        alertController.addAction(OokAction)
        alertController.addAction(cancelAction)
        alertController.addAction(loadAction)
        self.present(alertController, animated: true,completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        //        let height = self.view.frame.width
        return CGSize(width: width, height:200)
    }
    
}
