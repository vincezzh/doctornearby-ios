//
//  GenderPopupViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-25.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class GenderPopupViewController: UIViewController {

    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 210, height: 150)
        }
        set {
            super.preferredContentSize = newValue
        }
    }

    @IBAction func selectEither(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
