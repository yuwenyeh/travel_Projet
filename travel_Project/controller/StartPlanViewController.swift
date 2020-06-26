//
//  startPlanning.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/18.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class StartPlanViewController: UIViewController {
    
    
    var data:[Note] = []
    
    let dbManager = DBManager.shared
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = self
        self.tableview.dataSource = self
//        initStatusBarStyle()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //initStatusBarStyle()
        //讀取資料
        self.data = DBManager.shared.loadTravelPlans()
        tableview.reloadData()
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

extension StartPlanViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count == 0 ? 1 : data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelTableViewCell", for: indexPath) as! TravelTableViewCell
        
        if self.data.count > 0{
            
            let note = self.data[indexPath.row]
            cell.startDay?.text = "日期:\(note.startDate!)"
            cell.travelName?.text = "旅遊名稱\(note.travelName!)"
            cell.happyNumber?.text = "天數:\(note.days!)天"
        }
     
        let myBackView = UIView(frame: cell.frame)
        myBackView.frame = CGRect(x: 5,y: 5,width: (tableView.frame.width) - 5,height: (cell.frame.height) - 5)
        myBackView.layer.cornerRadius = 5 //角半徑
        myBackView.layer.shadowRadius = 2 //陰影半徑
        myBackView.backgroundColor = UIColor.white
        myBackView.layer.masksToBounds = false  //界線
        myBackView.clipsToBounds = false //界線
        // myBackView.layer.shadowOffset = CGSizeMake(-1,1)
        myBackView.layer.shadowOpacity = 0.2  //陰影不透明度
        let test : CGRect = myBackView.layer.bounds
        myBackView.layer.shadowPath = UIBezierPath(rect: test).cgPath //陰影路徑
        cell.addSubview(myBackView)
        cell.sendSubviewToBack(myBackView) //發送返回
        cell.showsReorderControl = true//啟用重新排序
        return cell
    }
    
}


extension StartPlanViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.data.count > 0 {
            
            let note = self.data[indexPath.row]
            if let planVC = storyboard?.instantiateViewController(withIdentifier: "plan") {
                
                let planViewController = planVC as! PlanViewController
                planViewController.notedata = note
                navigationController?.pushViewController(planViewController, animated: true)
            }
            
        }else{
                
//            let showAlert = UIAlertController(title: nil, message: "請添加行程", preferredStyle: .alert)
//            present(showAlert, animated: true, completion: nil)
          
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, comletionHandler) in
            
            //防止行程計畫沒資料時誤刪
            if self.data.count == 0{
                return
            }
            
            let deleteId = self.data[indexPath.row].id
            //刪除DB資料
            if(self.dbManager.deletePlan(withID: deleteId!)){
                //刪除畫面資料
                self.data.remove(at: indexPath.row)
                tableView.reloadData()
            }
        
            comletionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
        
    }
    
    
}




//extension UINavigationBar{
//    
//    //將顏色加入指定範圍
//    func apply(gradient colors: [UIColor]) {
//        var naviAndStatusBar: CGRect = self.bounds
//        naviAndStatusBar.size.height += 45//statusBar和navigationBar的高度
//        setBackgroundImage(UINavigationBar.gradient(size: naviAndStatusBar.size,colors: colors), for: .default)
//    }
//    
//    //設定漸層
//    static func gradient(size: CGSize, colors: [UIColor]) ->UIImage{
//        
//        let cgColors = colors.map{$0.cgColor}//將顏色轉換成cgColor
//        
//        UIGraphicsBeginImageContextWithOptions(size, true, 0)//開始繪製的位置
//        
//        guard let context = UIGraphicsGetCurrentContext() else { return UIGraphicsGetImageFromCurrentImageContext()!}
//        
//        defer {UIGraphicsEndImageContext()}
//        
//        var locations: [CGFloat] = [0,1]//顏色位置(座標)
//        
//        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgColors as NSArray as CFArray, locations: &locations) else { return UIGraphicsGetImageFromCurrentImageContext()! }
//        
//        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: [])//繪製漸層的角度
//        
//        return UIGraphicsGetImageFromCurrentImageContext()!
//    }
//    
//}
//






