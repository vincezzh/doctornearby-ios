//
//  Doctor.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-28.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import Foundation

class Doctor {
    var doctorId: String = ""
    var name: String = ""
    var address: String = ""
    var contact: String = ""
    let phoneWord = "Phone:"

    func phoneNumber() -> String {
        var phone = ""
        if contact != "" {
            if let content: String = contact {
                let phoneWordEndIndex = content.indexOf(phoneWord) + phoneWord.length
                let firstCommanIndex = content.indexOf(",")
                if firstCommanIndex >= 0 {
                    phone = content.subString(phoneWordEndIndex, endIndex: firstCommanIndex).trim()
                }else {
                    phone = content.subString(phoneWordEndIndex, endIndex: content.length).trim()
                }
            }
        }
        return phone
    }
}