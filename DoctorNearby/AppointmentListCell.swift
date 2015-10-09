//
//  AppointmentListCell.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-08.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class AppointmentListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
