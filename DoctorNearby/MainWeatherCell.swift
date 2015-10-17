//
//  MainWeatherCell.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-16.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class MainWeatherCell: UITableViewCell {
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
