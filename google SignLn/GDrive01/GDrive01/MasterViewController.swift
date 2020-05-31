//
//  MasterViewController.swift
//  GDrive01
//
//  Created by 周旻鋒 on 2020/5/11.


import UIKit


class MasterViewController: UIViewController{
    
    var manager = GDriveManager.shared
    
    lazy var signIn = self.manager.signIn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        signIn?.delegate = manager
        signIn?.scopes = [manager.KGSDF]
        signIn?.clientID = manager.clientID
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //畫面出現前會呼叫
        super.viewDidAppear(animated)
        
        //Optional Chain
        guard let authorizer = signIn?.currentUser?.authentication?.fetcherAuthorizer(),
            // 1,產生判斷 canAuthorize  is Bool, 上面3個值是！可選型別故加? <option鍊 >
            let canAuthorize = authorizer.canAuthorize,canAuthorize
            
            else {
                signIn?.presentingViewController = self
                signIn?.signIn()
                return
        }
        
        //No need to login , we can start to uer gdrive
        print("Already sing-in ,start to use.")
        
        manager.setAuthorizer(authorizer : authorizer)
    }
    
    
    
}

