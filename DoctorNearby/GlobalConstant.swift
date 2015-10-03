//
//  GlobalConstant.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-29.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

struct GlobalConstant {
    
    static var baseServerURL = "http://localhost:9091/doctornearby"
    static var defaultPageSize = 25
    static var defaultPageStart = 0
    
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