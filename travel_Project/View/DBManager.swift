//
//  DBManager.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/16.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import Foundation
import FMDB

class DBManager : NSObject {
    
    let databaseFileName = "database.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    static let shared = DBManager()
    
    
    //建立表
    let CREATE_TRAVEL_PLAN_SQL = "create table travel_plan (id text primary key not null, travelName text not null, startDate text not null, days text not null, dayStr ,createTime text not null)"
    
    let CREATE_TRAVEL_DETAIL_SQL = "create table travel_detail (id text primary key not null,relateId text not null , travelDay text not null, placeName text, placeId text ,address text , photoReference  text  , centerLat text , centerLng text, createTime text not null)"
    
    
    
    override init() {
        super.init()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        print(pathToDatabase!)
    }
    
    
    //建立表格
    func createDatabase() -> Bool {
        
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    do {
                        try database.executeUpdate(CREATE_TRAVEL_PLAN_SQL, values: nil)
                        try database.executeUpdate(CREATE_TRAVEL_DETAIL_SQL, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    // At the end close the database.
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    
    
    func openDatabase() -> Bool {
        
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    
    
    
    
    //搜尋旅程計畫(大項)
    func loadTravelPlans()->  [Note]{
        
        var travelPlans = [Note]()
        
        if openDatabase() {
            
            let query = "select * from travel_plan order by \(CREATE_TIME) desc"
            
            do {
                
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let travelPlan = Note()
                    travelPlan.id = results.string(forColumn: ID)
                    travelPlan.travelName = results.string(forColumn: TRAVAEL_NAME)
                    travelPlan.startDate = results.string(forColumn: START_DATE)
                    travelPlan.days = results.string(forColumn: DAYS)
                    travelPlan.dailyStr = results.string(forColumn: DAY_STR)
                    
                    travelPlans.append(travelPlan)
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return travelPlans
        
    }
    
    
    
    //讀取行程計畫(每一天行程 遊玩細項)
    func loadPlanDetails(_ relateId:String , daily:String) -> CellData{
        
        
        var cellData:CellData?
        
        var planDetails = [TravelDetail]()//裝遊玩細項的陣列
        
        if openDatabase() {
            
            let query = "select * from travel_detail  where relateId=? and  travelDay=? order by \(CREATE_TIME) asc"
            
            do {
                
                let results = try database.executeQuery(query, values: [relateId, daily])
                
                //如果有撈出資料
                while results.next() {
                    
                    var planDetail = TravelDetail()
                    //每日行程細項
                    planDetail.id = results.string(forColumn: ID)
                    planDetail.relateId = results.string(forColumn: RELATE_ID)
                    planDetail.travelDaily = results.string(forColumn: TRAVEL_DAY)
                    planDetail.name = results.string(forColumn: PLACE_NAME)
                    planDetail.placeID = results.string(forColumn: PLACE_ID)
                    planDetail.address = results.string(forColumn: ADDRESS)
                    planDetail.photoReference = results.string(forColumn: PHOTO_REFERENCE)
                    planDetail.centerLat = results.double(forColumn: CENTER_LAT)
                    planDetail.centerLng = results.double(forColumn: CENTER_LNG)
                    
                    planDetails.append(planDetail)
                }
                
                //裝入予預設值
                let travelDefaultDetail = TravelDetail(name: "✏️加入旅程")
                planDetails.append(travelDefaultDetail)
                
                //每日行程主項
                cellData = CellData(isOpen: true, sectionTitle: daily, sectionData: planDetails)
                
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return cellData!
        
    }
    
    
    //新增行程
    func insertTravelPlanData(insertData:Note?) ->String{
        
        let uuid = (UUID().uuidString)
        
        if openDatabase() {
            
            if let insertData = insertData{
                
                let query = "insert into travel_plan (\(ID) , \(TRAVAEL_NAME),\(START_DATE),\(DAYS),\(DAY_STR),\(CREATE_TIME)) values('\(uuid)','\(insertData.travelName!)','\(insertData.startDate!)','\(insertData.days!)','\(insertData.dailyStr!)',strftime('%s', 'now'))"
                
                if !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
                
            }
            
        }
        
        database.close()
        
        return uuid
        
    }
    
    
    //新增每日行程詳情
    func insertPlanDetail(insertData:TravelDetail?) {
        
        if openDatabase() {
            
            if let insertData = insertData{
                
                let query = "insert into travel_detail(\(ID) , \(RELATE_ID),\(TRAVEL_DAY),\(PLACE_NAME),\(PLACE_ID),\(ADDRESS),\(PHOTO_REFERENCE),\(CENTER_LAT),\(CENTER_LNG),\(CREATE_TIME)) values('\(UUID().uuidString)','\(insertData.relateId!)','\(insertData.travelDaily!)','\(insertData.name!)',  '\(insertData.placeID!)','\(insertData.address!)','\(insertData.photoReference!)','\(insertData.centerLat!)','\(insertData.centerLng!)',strftime('%s', 'now'))"
                
                if !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
                
            }
            
        }
        
        database.close()
    }
    
    //刪除旅遊計畫
    func deletePlan(withID deleteId: String) -> Bool {
        var deleted = false
        
        //需要刪除plan表 跟detail表中 realateID = plan id 的項目
        if openDatabase() {
            
            let deleteDetail = "delete from travel_detail where \(RELATE_ID)=?"
            
            let deletePlan =  "delete from travel_plan where \(ID)=?"
            do {
                //先刪除旅遊詳情
                try database.executeUpdate(deleteDetail, values: [deleteId])
                //再刪除旅遊計畫
                try database.executeUpdate(deletePlan, values: [deleteId])
                deleted = true
            }
                
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
    }
    
    
    
    //刪除每日行程詳情
    func deletePlanDetail(withID deleteId: String) -> Bool {
        var deleted = false
        
        if openDatabase() {
            let query = "delete from travel_detail where \(ID)=?"
            
            do {
                try database.executeUpdate(query, values: [deleteId])
                deleted = true
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}



