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
    
    
    
    let CREATE_TRAVEL_PLAN_SQL = "create table travel_plan (id text primary key not null, travelName text not null, startDate text not null, days text not null, dayStr ,createTime text not null)"
    
    
    let CREATE_TRAVEL_DETAIL_SQL = "create table travel_detail (id text primary key not null,relateId text not null , travelDay text not null, placeName text, address text , photoReference  text  , centerLat text , centerLng text, createTime text not null)"
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
        print("documentsDirectory")
        
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    
    
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
            self.createDatabase()
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}



