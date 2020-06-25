//
//  background.swift
//  travel_project
//
//  Created by 葉育彣 on 2020/6/20.
//  Copyright © 2020 葉育彣. All rights reserved.
//

import UIKit

//
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
