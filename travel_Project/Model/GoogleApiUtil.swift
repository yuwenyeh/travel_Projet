//
//  GoogleApiUtil.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/12.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import Foundation

class GoogleApiUtil{
    
    private static let GOOGLE_API_KEY = "AIzaSyD-OVc_frDI7h3KNYjsjB8cr_kiG2K74SY";
    
    private static let GOOGLE_MAP_API_URL:String = "https://maps.googleapis.com/maps/api";
    
    private static let GOOGLE_STATIC_MAP:String = "\(GOOGLE_MAP_API_URL)/staticmap";
    
    private static let GOOGLE_NEAR_MAP:String = "\(GOOGLE_MAP_API_URL)/place/nearbysearch";
    
    private static let GOOGLE_DETAIL:String = "\(GOOGLE_MAP_API_URL)/place/details";
    
    private static let GOOGLE_PHOTO:String = "\(GOOGLE_MAP_API_URL)/place/photo";
    
    
    //type = "tourist_attraction"旅遊景點
    public static func createStaticMapUrl(lat:Double, lng:Double, w:Int, h:Int) -> String {
        //精度緯度
        let centerLatLngStr = String.init(format: "%f,%f", lat, lng)
        return "\(GOOGLE_STATIC_MAP)?center=\(centerLatLngStr)&&markers=color:red%7Clabel:S%7C\(centerLatLngStr)&size=\(w)x\(h)&scale=2&zoom=16&language=zh-TW&key=AIzaSyD-OVc_frDI7h3KNYjsjB8cr_kiG2K74SY";
    }
    
    //搜尋附近景點
    public static func createNearMapUrl(lat:Double, lng:Double,types:String) ->String{
        //精度緯度
        let centerLatLngStr = String.init(format: "%f,%f", lat, lng)
        return "\(GOOGLE_NEAR_MAP)/json?location=\(centerLatLngStr)&radius=2000&types=\(types)&language=zh-TW&key=\(GOOGLE_API_KEY)";
    }
    
    //取景點詳情
    public static func  createMapDetailInfo(placeId:String) ->String{
        return "\(GOOGLE_DETAIL)/json?place_id=\(placeId)&fields=formatted_address,name,review,photo&language=zh-TW&key=\(GOOGLE_API_KEY)";
    }
    
    
   
    
    //取照片
    public static func createPhotoUrl(ference:String,width:Int) ->String{
        return "\(GOOGLE_PHOTO)?maxwidth=\(width)&photoreference=\(ference)&key=\(GOOGLE_API_KEY)"
    }
    
    //https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference="
    
    
    
    
    
    
}
// GoogleApiUtil
//createStaticMapUrl
