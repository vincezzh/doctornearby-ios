//
//  GenderPopupViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-25.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class GenderPopupViewController: UIViewController {
    
    @IBOutlet weak var eitherButton: UIButton!
    @IBOutlet weak var femailButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eitherButton.layer.cornerRadius = 5
        femailButton.layer.cornerRadius = 5
        mailButton.layer.cornerRadius = 5
    }
    
    var onDataAvailable : ((data: String) -> ())?
    
    func sendData(data: String) {
        self.onDataAvailable?(data: data)
    }

    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 210, height: 150)
        }
        set {
            super.preferredContentSize = newValue
        }
    }

    @IBAction func selectEither(sender: AnyObject) {
        dismissGenderViewController("Either")
    }
    
    @IBAction func selectMale(sender: AnyObject) {
        dismissGenderViewController("Male")
    }
    
    @IBAction func selectFemale(sender: AnyObject) {
        dismissGenderViewController("Female")
    }
    
    func dismissGenderViewController(gender: String) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.sendData(gender)
        }
    }
}
