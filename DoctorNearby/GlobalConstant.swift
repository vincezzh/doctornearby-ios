//
//  GlobalConstant.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-29.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

struct GlobalConstant {
    
    static let baseServerURL = "http://localhost:9091/doctornearby"
    static let defaultPageSize = 25
    static let defaultPageStart = 0
    
    static let brandFlag = "Added by Doctor NearBy"
    static let defaultCalendar = "Calendar"
    static let defaultCalendarPeriod = 60 * 60 * 24 * 90 // 90 days
    
    static let defaultColor = UIColor(red: 129 / 255.0, green: 168 / 255.0, blue: 93 / 255.0, alpha: 1.0)
    static let buttonColors: [UIColor] = [
            UIColor(red: 253 / 255.0, green: 45 / 255.0, blue: 58 / 255.0, alpha: 1.0),
            UIColor(red: 10 / 255.0, green: 98 / 255.0, blue: 247 / 255.0, alpha: 1.0),
            UIColor(red: 255 / 255.0, green: 102 / 255.0, blue: 0 / 255.0, alpha: 1.0),
            UIColor(red: 234 / 255.0, green: 186 / 255.0, blue: 28 / 255.0, alpha: 1.0),
            UIColor(red: 113 / 255.0, green: 0 / 255.0, blue: 188 / 255.0, alpha: 1.0),
            UIColor(red: 12 / 255.0, green: 226 / 255.0, blue: 95 / 255.0, alpha: 1.0)
        ]
    
    static func buttonColor() -> UIColor {
        let index = arc4random_uniform(6)
        return buttonColors[Int(index)]
    }

    static func userId() -> String {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let userId = userDefaults.valueForKey("DoctorNearby_UserId") {
            return userId as! String
        }else {
            let userId = (UIDevice.currentDevice().identifierForVendor?.UUIDString)!
            userDefaults.setValue(userId, forKey: "DoctorNearby_UserId")
            userDefaults.synchronize()
            return userId
        }
    }
}