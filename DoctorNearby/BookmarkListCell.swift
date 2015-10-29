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
    var bookmark = Doctor()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        nameLabel.text = bookmark.name
        locationLabel.text = "@\(bookmark.province)"
        contactLabel.text = bookmark.contact
    }
    
}
