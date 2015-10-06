//
//  DoctorSearchTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-06.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class DoctorSearchTableViewController: UITableViewController {

    @IBOutlet weak var selectedLanguageTextField: UILabel!
    @IBOutlet weak var selectedSpecialistTextField: UILabel!
    @IBOutlet weak var selectedCityTextField: UILabel!
    @IBOutlet weak var selectedHospitalTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else if section == 1 {
            return 2
        }else if section == 2 {
            return 1
        }else if section == 3{
            return 1
        }else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = GlobalConstant.defaultColor
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.whiteColor()
    }

    func doLanguagesWithData(data: String) {
        selectedLanguageTextField.text = data
    }
    
    func doSpecialistsWithData(data: String) {
        selectedSpecialistTextField.text = data
    }
    
    func doCityWithData(data: String) {
        selectedCityTextField.text = data
    }
    
    func doHospitalWithData(data: String) {
        selectedHospitalTextField.text = data
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLanguageSegue" {
            if let viewController = segue.destinationViewController as? LanguagesTableViewController {
                viewController.selectedLanguage = selectedLanguageTextField.text!
                viewController.onDataAvailable = {[weak self]
                    (data) in
                    if let weakSelf = self {
                        weakSelf.doLanguagesWithData(data)
                    }
                }
            }
        }else if segue.identifier == "showSpecialistsSegue" {
            if let viewController = segue.destinationViewController as? SpecializationTableViewController {
                viewController.selectedSpecialist = selectedSpecialistTextField.text!
                viewController.onDataAvailable = {[weak self]
                    (data) in
                    if let weakSelf = self {
                        weakSelf.doSpecialistsWithData(data)
                    }
                }
            }
        }else if segue.identifier == "showCitiesSegue" {
            if let viewController = segue.destinationViewController as? CitiesTableViewController {
                viewController.selectedCity = selectedCityTextField.text!
                viewController.onDataAvailable = {[weak self]
                    (data) in
                    if let weakSelf = self {
                        weakSelf.doCityWithData(data)
                    }
                }
            }
        }else if segue.identifier == "showHospitalsSegue" {
            if let viewController = segue.destinationViewController as? HospitalsTableViewController {
                viewController.selectedHospital = selectedHospitalTextField.text!
                viewController.onDataAvailable = {[weak self]
                    (data) in
                    if let weakSelf = self {
                        weakSelf.doHospitalWithData(data)
                    }
                }
            }
        }
    }

}
