//
//  HexColor.swift
//  AlarmWork
//
//  Created by saichi on 2015/08/02.
//  Copyright (c) 2015年 SaichiSuzuki. All rights reserved.
//

import UIKit

extension UIColor {
    class func hexStr (var hexStr : NSString, alpha : CGFloat) -> UIColor {
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
//            print("invalid hex string", terminator: "")
            return UIColor.whiteColor();
        }
    }
}

