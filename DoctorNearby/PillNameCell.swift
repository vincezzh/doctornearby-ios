//
//  PillNameCell.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-09.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class PillNameCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension PillNameCell: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}