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
    // #39886F
    static let defaultColor = UIColor(red: 68 / 255.0, green: 169 / 255.0, blue: 138 / 255.0, alpha: 1.0)
    
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