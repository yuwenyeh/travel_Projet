//
//  Planning.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/2.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit


class PlanViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableViewData:[CellData]? = [CellData]()
    var notedata : Note!
    
    var travelName : String?
    var startDate : String?
    var happyNumber : String?
    
    let dbManager = DBManager.shared
    
    
   // @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!//導航列
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let noteData = notedata{
//            navItem.title = noteData.travelName//設定導航列標題文字
//        }
        //initStatusBarStyle()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.travelName = self.notedata.travelName
        self.startDate = self.notedata.startDate
        self.happyNumber = self.notedata.days
        
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //讀取資料
        if let notedata = self.notedata{
            
            self.tableViewData?  = []//清空資料
            
            let dailyStrArray = notedata.dailyStr?.split(separator: "_")
            
            //用單日日期去找 行程
            for daily in dailyStrArray!{
                //取得每日行程主項
                let cellData = dbManager.loadPlanDetails(notedata.id!, daily: String(daily))
                //裝入
                self.tableViewData?.append(cellData)
            }
            
            self.notedata.dailyPlan = self.tableViewData
            
        }
        
    }
    
    @IBAction func backStartButton(_ sender: Any) {
        let startVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startID")
        navigationController?.pushViewController(startVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData!.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData![section].isOpen == true{
            return tableViewData![section].sectionData.count + 1
            
        }else{
            return 1
        }
        
    }
    
    
    //MARK: cellForRowAT
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            cell.textLabel?.text = tableViewData![indexPath.section].sectionTitle
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.textAlignment = NSTextAlignment.center //字體致中
            cell.textLabel?.text = tableViewData![indexPath.section].sectionData[indexPath.row - 1].name!
           
            
            // cell.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            //幫cell加陰影
            let myBackView = UIView(frame: cell.frame)
            myBackView.frame = CGRect(x: 5,y: 5,width: (tableView.frame.width) - 10,height: (cell.frame.height) - 10)
            myBackView.layer.cornerRadius = 5
            myBackView.layer.shadowRadius = 2
            myBackView.backgroundColor = UIColor.white
            myBackView.layer.masksToBounds = false
            myBackView.clipsToBounds = false
            //myBackView.layer.shadowOffset = CGSize.Make(-1,1)
            myBackView.layer.shadowOpacity = 0.2
            let test : CGRect = myBackView.layer.bounds
            myBackView.layer.shadowPath = UIBezierPath(rect: test).cgPath
            cell.addSubview(myBackView)
            cell.sendSubviewToBack(myBackView)
            
            return cell
            
            //加東西
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            if  tableViewData![indexPath.section].isOpen == true{
                tableViewData![indexPath.section].isOpen = false
                let indexes = IndexSet(integer : indexPath.section)
                tableView.reloadSections(indexes, with: .automatic)
                
            }else{
                tableViewData![indexPath.section].isOpen = true
                let indexes = IndexSet(integer : indexPath.section)
                tableView.reloadSections(indexes, with: .automatic)
            }
            
        }else{
            
            let section =  indexPath.section
            let cellData = tableViewData?[section].sectionData
            let tripDetail = cellData?[indexPath.row - 1] 
            
            if tripDetail?.name != "✏️加入旅程"{
                
                let alertControll = UIAlertController()
                
                let storeFile = UIAlertAction(title: "評價搜尋", style: .default) { (action) in
                    
                    if let tripDvc = self.storyboard?.instantiateViewController(withIdentifier: "TripDvc") {
                        
                        let tripDetailVC = tripDvc as! TripDetailViewController // 轉到單一評價
                        
                        tripDetailVC.placeName = tripDetail?.name
                        tripDetailVC.placeId = tripDetail?.placeID
                        
                        self.navigationController?.pushViewController(tripDvc, animated: true)
                        
                    }
                }
                
                
                let okAction = UIAlertAction(title: "地圖導航", style: .default) { (action)->Void in
                    
                    if  let googleVC = self.storyboard?.instantiateViewController(withIdentifier: "googleVC") {
                        
                        let gooVC = googleVC as! GoogleMapViewController
                        
                        gooVC.googleMaplDetail = tripDetail
                        
                        self.navigationController?.pushViewController(gooVC, animated: true)
                        
                    }
                }
                
                let deleteAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
                    print("取消")
                }
                
                alertControll.addAction(storeFile)
                alertControll.addAction(okAction)
                alertControll.addAction(deleteAction)
                self.present(alertControll, animated: true, completion: nil)
                
            }else{
                //轉場到景點搜尋
                if let vc = storyboard?.instantiateViewController(withIdentifier: "TripPlanVC") {
                    let tripPlanVC = vc as! TripPlanViewController
                    tripPlanVC.noteData = self.notedata
                    tripPlanVC.sectionIndex = indexPath.section
                    navigationController?.pushViewController(tripPlanVC, animated: true)
                }
                
            }
            
            
        }
    }
    
    //增加刪除功能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            //防止使用者刪除日期
            if(indexPath.row == 0){
                return
            }
            
            let cellData =  tableViewData![(indexPath.section)]
            let deleteId = cellData.sectionData[indexPath.row-1].id
            
            //防止使用者刪除新增按鈕
            if(deleteId != nil){
                //資料庫刪除成功時 順便把畫面的tableViewData也需要刪除
                if(dbManager.deletePlanDetail(withID: deleteId!)){
                    tableViewData![(indexPath.section)].sectionData.remove(at: indexPath.row-1)
                }
            }
            
        }
        
        tableView.reloadData()
    }
//    func initStatusBarStyle(){
//        
//        // Set StatusBar Style
//        self.navigationController?.navigationBar.barStyle = .black
//        
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        // navigation & status bar 改顏色方法
//        navigationController?.navigationBar.apply(gradient: [UIColor(red: 19/255, green: 93/255, blue: 14, alpha: 1),UIColor(red: 105/255, green: 255/255, blue: 151/255, alpha: 1),UIColor(red: 0/255, green: 228/255, blue: 255, alpha: 1)])
//    }
}



