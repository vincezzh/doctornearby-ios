//
//  PillListCell.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-09.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class PillListCell: UITableViewCell {
    
    var pill = Pill()
    var timer = NSTimer()
    let timeInterval: NSTimeInterval = 30
    var timeCount: NSTimeInterval = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.textLabel?.text = pill.medicine
        
        if !timer.valid {
            timeCount = pill.secondsLeft
            self.detailTextLabel?.text = timeString(pill.secondsLeft)
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
                target: self,
                selector: "timerDidEnd:",
                userInfo: nil,
                repeats: true)
        }
    }
    
    func timerDidEnd(timer: NSTimer){

        timeCount = timeCount - timeInterval
        if timeCount <= 0 {
            self.detailTextLabel?.text = "Medicine to go"
            timer.invalidate()
        } else {
            self.detailTextLabel?.text = timeString(timeCount)
        }
        
    }
    
    func timeString(time: NSTimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) - hours * 3600) / 60
        if hours == 0 && minutes == 0 {
            return "Less than 1m"
        }else {
            return String(format:"%02ih %02im", hours, minutes)
        }
    }

}
