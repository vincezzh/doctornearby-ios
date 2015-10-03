//
//  BookmarkListCell.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-02.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class BookmarkListCell: UITableViewCell {
    
    static let kCellIdentifier = "BookmarkListCell"

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
