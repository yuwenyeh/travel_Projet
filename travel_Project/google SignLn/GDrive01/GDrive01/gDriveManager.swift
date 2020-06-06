//
//  gDriveManager.swift
//  GDrive01
//
//  Created by 葉育彣 on 2020/5/14.
//  Copyright © 2020 周旻鋒. All rights reserved.
//
import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher
import GoogleSignIn




//protocol GDriveManagerDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
//}


class GDriveManager : NSObject, GIDSignInDelegate {
    
    static let shared = GDriveManager()
    
    let clientID = "1094427429359-01be7j45pigbe9i9akkavqa472ltafa3.apps.googleusercontent.com"
    
    //kGTLRAuthScopeDriveFile
    let KGSDF = kGTLRAuthScopeDriveFile
    
    let drive = GTLRDriveService()
    
    //google signIn
    let signIn = GIDSignIn.sharedInstance()
    
    
    private override init(){
        super.init()
        self.signIn?.delegate = self
    }
    
    
    func setAuthorizer(authorizer: GTMFetcherAuthorizationProtocol){
        drive.authorizer = authorizer
    }
    
    //MARK: -GIDSignInDelegate Methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error{
            print("Auth Fail: \(error)")
            return
        }
        
        let userID = user.userID ?? "n/a"
        let name = user.profile.name ?? "n/a"
        print("Auth OK: \(userID), \(name)")
        
        self.setAuthorizer(authorizer : user.authentication.fetcherAuthorizer())
        
    }
    
    
    
    
    
}

