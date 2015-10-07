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
    let extensionWord = "Ext."

    func phoneNumber() -> String {
        var phone = ""
        var phoneNumber = ""
        if contact != "" {
            if let content: String = contact {
                let phoneWordEndIndex = content.indexOf(phoneWord) + phoneWord.length
                let extensionIndex = content.indexOf(extensionWord)
                let firstCommanIndex = content.indexOf(",")
                
                if extensionIndex >= 0 {
                    phone = content.subString(phoneWordEndIndex, endIndex: extensionIndex).trim()
                }else {
                    if firstCommanIndex >= 0 {
                        phone = content.subString(phoneWordEndIndex, endIndex: firstCommanIndex).trim()
                    }else {
                        phone = content.subString(phoneWordEndIndex, endIndex: content.length).trim()
                    }
                }
                
                for letter in phone.characters {
                    switch (letter) {
                        case "0","1","2","3","4","5","6","7","8","9" :
                            phoneNumber = phoneNumber + String(letter)
                        default :
                            print("Removed invalid character: \(letter)")
                    }
                }
            }
        }
        return phoneNumber
    }
}