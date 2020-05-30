//
//  welcomeTravel.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/5/26.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

protocol welcomeDelegate :class{
    func didFinishUpdate(_ note:Note)
}

class welcomeTravel: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    var formatter : DateFormatter! = nil
    let happyDay = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    
    @IBOutlet weak var textLabel: UITextField!
    @IBOutlet weak var travelname: UITextField!
    @IBOutlet weak var happyNumber: UITextField!
    
    
    
    weak var delegate : welcomeDelegate?
    
    
    
    
    @IBAction func UserAction(_ sender: Any) {
        self.textLabel.text = time()
    }
    
    
    
    //
    @IBAction func addNote(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        let note = Note()
        
        //把值裝進node
        note.text = self.textLabel.text
        note.date = self.travelname.text
        note.Days = self.happyNumber.text
        
        
        self.delegate?.didFinishUpdate(note)
        
        
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //textLabel.text = travelname.text
        
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
        myDatePicker.addTarget(self,action:#selector(welcomeTravel.datePickerChanged),for: .valueChanged)
        //將原本鍵盤試圖改UIDatePicker
        textLabel.inputView = myDatePicker
        textLabel.text = formatter.string(from: myDatePicker.date)
        textLabel.tag = 200
        
        
        // UIDatePicker 改變選擇時執行的動作
        func datePickerChanged(datePicker:UIDatePicker) {
            // 依據元件的 tag 取得 UITextField
            let textLabel = self.view?.viewWithTag(200) as? UITextField
            //將UITextField的值更新為新的日期
            textLabel?.text = formatter.string(from: datePicker.date)
        }
        
        
        // 增加一個觸控事件
        let tap = UITapGestureRecognizer(target: self,action:#selector(welcomeTravel.hideKeyboard(tapG:)))
        tap.cancelsTouchesInView = false
        // 加在最基底的 self.view 上
        self.view.addGestureRecognizer(tap)
        // 按空白處會隱藏編輯狀態
        func hideKeyboard(tapG:UITapGestureRecognizer){
            self.view.endEditing(true)
        }
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
    
    
    
    
    
    
    
}
