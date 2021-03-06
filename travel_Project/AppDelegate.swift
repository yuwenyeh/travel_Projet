//
//  AppDelegate.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/5/26.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate {
    //
   var window: UIWindow?
    //AIzaSyCzxPdj1LXGnX0953beVlsZu1CgrobApgk
        
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyCzxPdj1LXGnX0953beVlsZu1CgrobApgk")
        GMSPlacesClient.provideAPIKey("AIzaSyCzxPdj1LXGnX0953beVlsZu1CgrobApgk")
        
     
        
        let navBar = UINavigationBar.appearance()//設定導航欄
        
        navBar.barTintColor = UIColor(red: 247/255, green: 226/255, blue: 29/255, alpha: 1
        )
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor(red: 247/255, green: 226/255, blue: 29/255, alpha: 1)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        self.window!.rootViewController = inputViewController
        self.window!.makeKeyAndVisible()
        
        
        //產生資料庫
        let dbManager = DBManager.shared
        dbManager.createDatabase()
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

