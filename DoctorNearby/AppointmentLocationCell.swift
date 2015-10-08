//
//  AppointmentLocationCell.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-08.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class AppointmentLocationCell: UITableViewCell {

    @IBOutlet weak var locationTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        locationTextField.delegate = self
    }

}

extension AppointmentLocationCell: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        return true
    }
}