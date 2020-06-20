//
//  startPlanning.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/18.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

class StartPlanning: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var data:[Note] = []
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    
   // let search = UISearchController(searchResultsController: nil)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count == 0 ? 1 : data.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelTableViewCell", for: indexPath) as! TravelTableViewCell
        
        
        
        if self.data.count != 0{
            
            let note = self.data[indexPath.row]
            cell.showsReorderControl = true
            
            
            cell.startDay?.text = note.startDate
            cell.travelName?.text = note.travelName
            cell.happyNumber?.text = note.days
            
            
        }else{
            cell.startDay.text = "日期"
            cell.travelName.text = "旅遊名稱"
            cell.happyNumber.text = "天數"
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, comletionHandler) in
            
            //刪除資料
            self.data.remove(at: indexPath.row)
            comletionHandler(true)
        }
        
       let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        
        return swipeConfiguration
        
   
    }
   
    func initStatusBarStyle(){
        
        // Set StatusBar Style
        
        self.navigationController?.navigationBar.barStyle = .black
 
        self.navigationController?.navigationBar.tintColor = UIColor.red
        // navigation & status bar 改顏色方法
//        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 219/255, alpha: 1)
        
        
        navigationController?.navigationBar.apply(gradient: [UIColor(red: 0, green: 219/255, blue: 0, alpha: 1),UIColor(red: 231/255, green: 231/255, blue: 243/255, alpha: 1)])
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        initStatusBarStyle()
        
    }
    //background-image: linear-gradient(120deg, #d4fc79 0%, #96e6a1 100%);
  //background-image: linear-gradient(120deg, #84fab0 0%, #8fd3f4 100%);
    
}
extension UINavigationBar{
    
    //將顏色加入指定範圍
    func apply(gradient colors: [UIColor]) {
        var naviAndStatusBar: CGRect = self.bounds
        naviAndStatusBar.size.height += 45//statusBar和navigationBar的高度
        setBackgroundImage(UINavigationBar.gradient(size: naviAndStatusBar.size,colors: colors), for: .default)
    }
    
    //設定漸層
    static func gradient(size: CGSize, colors: [UIColor]) ->UIImage{
        
        let cgColors = colors.map{$0.cgColor}//將顏色轉換成cgColor
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)//開始繪製的位置
        
        guard let context = UIGraphicsGetCurrentContext() else { return UIGraphicsGetImageFromCurrentImageContext()!}
        
        defer {UIGraphicsEndImageContext()}
        
        var locations: [CGFloat] = [0,1]//顏色位置(座標)
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgColors as NSArray as CFArray, locations: &locations) else { return UIGraphicsGetImageFromCurrentImageContext()! }
        
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: [])//繪製漸層的角度
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
}


//extension StartPlanning:StartPlanningDelegate{
//
//    func didFinishUpdate(note:Note){
//        if let index = self.data.firstIndex(of: note){
//
//            let data = Note()
//
//
//        }
//    }
//
//}






