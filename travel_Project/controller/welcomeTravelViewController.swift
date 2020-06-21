//
//  welcomeTravel.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/5/26.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit


class welcomeTravelViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    var formatter : DateFormatter! = nil
    let happyDay = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    
    @IBOutlet weak var startDay: UITextField! //出發日期
    @IBOutlet weak var travelname: UITextField!  //行程名稱
    @IBOutlet weak var happyNumber: UITextField!   //天數
    @IBOutlet var backgrounImageView: UIImageView!
    
    var isNewImage : Bool = false
    var notedata : Note!
    let dbManager = DBManager.shared
    
    
    //weak var delegate : StartPlanning?
//    @IBOutlet var showitem: UIImageView!
//
//
//    @IBAction func camera(_ sender: UIButton) {
//
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = .savedPhotosAlbum
//        imagePicker.delegate = self
//        self.present(imagePicker, animated: true, completion: nil)
//    }
//
//    //camera
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        let image = info[.originalImage] as? UIImage
//        self.showitem.image = image
//        isNewImage = true
//        self.dismiss(animated: true, completion: nil)
//    }
//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // guard let image = UIImage(named: "user") else{
            //fatalError("no starting image")
        
        //showitem.image = image
        UIPickerUnit();
    }
        //背景霧化
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        backgrounImageView.addSubview(blurEffectView)
        
        //產生陰影
//        showitem.layer.cornerRadius = 3
//        showitem.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
//        showitem.layer.shadowOffset = CGSize(width: 0, height: 1.75)
//        showitem.layer.shadowRadius = 1.7
//        showitem.layer.shadowOpacity = 0.45
 
    
    
    
    @IBAction func UserAction(_ sender: Any) {
        self.startDay.text = time()
    }
    
    
    //增加橘色確定Button
    @IBAction func dataAddTrip(_ sender: UIButton) {
        
        //驗證值
        if let textFiel = self.travelname.text{
            if textFiel == ""{
                let myalert = UIAlertController(title: "No input", message: "Please again", preferredStyle: .alert)
                let Alertaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                myalert.addAction(Alertaction)
                present(myalert, animated: true, completion: nil)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "SeguePlan"{
            
            let planVC = segue.destination as! PlanViewController
            let note = Note()
            var dailyStr = [String]()
            
            //把值裝進note
            note.travelName = self.travelname.text
            note.startDate =  self.startDay.text
            note.days = self.happyNumber.text
            
            //把出發日期 依照 天數 產生 key
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            
            if let dayCount = Int(note.days!) , let startDate = dateFormatter.date(from:note.startDate!) {
                
                note.dailyPlan = [CellData]()
                note.addFlag = true;//紀錄是否已設定行程
                
                for i in 0..<dayCount{
                    let addTime = Double(3600*24*i)
                    let travelDay  = startDate.addingTimeInterval(addTime)//出發天數轉date
                    let dayKey = dateFormatter.string(from: travelDay)
                    dailyStr.append(dayKey)//存入每天遊玩日期
                }
                
                note.dailyStr = dailyStr.joined(separator: "_")//組成字串
                //insert note to DB 順便回傳uuid 給 note
                note.id = dbManager.insertTravelPlanData(insertData: note)
                
                planVC.notedata = note
                
            }
            
        }
        
    }
    
    
    //
    @objc func datePickerChanged(datePicker: UIDatePicker){
        //依據元件的tag取得UITextField
        let myTextField = self.view.viewWithTag(200) as? UITextField
        myTextField?.text = formatter.string(from: datePicker.date)
    }
    
    
    //
    @objc func hideKeyboard(tapG: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return happyDay.count
    }
    //UIPickerView每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return happyDay[row]
    }
    
    //選擇改變後執行的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //依據元件的tag取得UITextField
        let myTextField = self.view?.viewWithTag(100) as? UITextField
        myTextField?.text = happyDay[row]
    }
    
    
    //設定時間格式
    func time() -> String {
        let now = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy年MM月dd日"
        let currentTime = dateformatter.string(from: now)
        return currentTime
    }
    
    //
    func UIPickerUnit(){
        
        //建立UIPickView
        let myPickView = UIPickerView()
        //設定UIPickerView的Delegate跟Datasource
        myPickView.delegate = self
        myPickView.dataSource = self
        happyNumber.text = happyDay[0]
        happyNumber.inputView = myPickView
        happyNumber.tag = 100
        
        ////初始化formatter並設置日期顯示時間
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        //建立一個UIDatePicker
        let myDatePicker = UIDatePicker()
        //設置UIDatePicker格式
        myDatePicker.datePickerMode = .date
        //設置UIDatePicker顯使的環境
        myDatePicker.locale = NSLocale(localeIdentifier: "zh_TW") as Locale
        //設置UIDatePicker預設日期為現在日期
        myDatePicker.date = NSDate() as Date
        // 設置 UIDatePicker 改變日期時會執行動作的方法
        myDatePicker.addTarget(self,action:#selector(welcomeTravelViewController.datePickerChanged),for: .valueChanged)
        //將原本鍵盤試圖改UIDatePicker
        startDay.inputView = myDatePicker
        startDay.text = formatter.string(from: myDatePicker.date)
        startDay.tag = 200
        
        // UIDatePicker 改變選擇時執行的動作
        func datePickerChanged(datePicker:UIDatePicker) {
            // 依據元件的 tag 取得 UITextField
            let textLabel = self.view?.viewWithTag(200) as? UITextField
            //將UITextField的值更新為新的日期
            textLabel?.text = formatter.string(from: datePicker.date)
        }
        // 增加一個觸控事件
        let tap = UITapGestureRecognizer(target: self,action:#selector(welcomeTravelViewController.hideKeyboard(tapG:)))
        tap.cancelsTouchesInView = false
        // 加在最基底的 self.view 上
        self.view.addGestureRecognizer(tap)
        // 按空白處會隱藏編輯狀態
        func hideKeyboard(tapG:UITapGestureRecognizer){
            self.view.endEditing(true)
        }
        
    }
    
    
    
    
    
}
