//
//  AppointmentTitleCell.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-08.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class AppointmentTitleCell: UITableViewCell {
    
    @IBOutlet weak var titleTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        titleTextField.delegate = self
    }

}

extension AppointmentTitleCell: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}