//
//  DoctorSearchTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-06.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class DoctorSearchTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate {
    
    var isSpecialistSelected = false

    @IBOutlet weak var selectedProvinceTextField: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var selectedLanguageTextField: UILabel!
    @IBOutlet weak var selectedGenderTextField: UILabel!
    @IBOutlet weak var selectedSpecialistTextField: UILabel!
    @IBOutlet weak var selectedCityTextField: UILabel!
    @IBOutlet weak var selectedHospitalTextField: UILabel!
    @IBOutlet weak var physicianTypeSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSearchNavigationBarItem()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.lastNameTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.addressTextField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        selectedProvinceTextField.text = GlobalFlag.province
        selectedSpecialistTextField.textColor = UIColor.lightGrayColor()
    }
    
    @IBAction func selectPhysicianTypeSegment(sender: AnyObject) {
        if physicianTypeSegment.selectedSegmentIndex == 0 {
            isSpecialistSelected = false
            selectedSpecialistTextField.text! = "ALL"
        }else if physicianTypeSegment.selectedSegmentIndex == 1 {
            isSpecialistSelected = false
            selectedSpecialistTextField.textColor = UIColor.lightGrayColor()
        }else if physicianTypeSegment.selectedSegmentIndex == 2 {
            isSpecialistSelected = true
            selectedSpecialistTextField.textColor = UIColor.darkGrayColor()
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 7
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
    
    func doGenderWithData(data: String) {
        selectedGenderTextField.text = data
    }
    
    func doProvinceWithData(data: String) {
        selectedProvinceTextField.text = data
        selectedCityTextField.text = "ALL"
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
            if isSpecialistSelected {
                if let viewController = segue.destinationViewController as? SpecializationTableViewController {
                    viewController.selectedSpecialist = selectedSpecialistTextField.text!
                    viewController.onDataAvailable = {[weak self]
                        (data) in
                        if let weakSelf = self {
                            weakSelf.doSpecialistsWithData(data)
                        }
                    }
                }
            }
        }else if segue.identifier == "showCitiesSegue" {
            if let viewController = segue.destinationViewController as? CitiesTableViewController {
                viewController.selectedCity = selectedCityTextField.text!
                viewController.province = selectedProvinceTextField.text!
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
        }else if segue.identifier == "showGendersSegue" {
            if let viewController = segue.destinationViewController as? GenderTableViewController {
                viewController.selectedGender = selectedGenderTextField.text!
                viewController.onDataAvailable = {[weak self]
                    (data) in
                    if let weakSelf = self {
                        weakSelf.doGenderWithData(data)
                    }
                }
            }
        }else if segue.identifier == "showProvinceSegue" {
            if let viewController = segue.destinationViewController as? CountryTableViewController {
                viewController.selectedProvince = selectedProvinceTextField.text!
                viewController.onDataAvailable = {[weak self]
                    (data) in
                    if let weakSelf = self {
                        weakSelf.doProvinceWithData(data)
                    }
                }
            }
        }else if segue.identifier == "showDoctorsSearchResultList" {
            
            SAInboxViewController.appearance.barTintColor = GlobalConstant.defaultColor
            SAInboxViewController.appearance.tintColor = .whiteColor()
            SAInboxViewController.appearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            
            let destViewController = segue.destinationViewController as! UINavigationController
            destViewController.delegate = self
            let viewController: SearchListViewController = destViewController.viewControllers[0] as! SearchListViewController
            
            var gender = ""
            if selectedGenderTextField.text == "Female" {
                gender = "Female"
            }else if selectedGenderTextField.text == "Male" {
                gender = "Male"
            }
            var physicianType = ""
            if physicianTypeSegment.selectedSegmentIndex == 1 {
                physicianType = "Family Medicine"
            }else {
                if selectedSpecialistTextField.text! != "ALL" {
                    physicianType = selectedSpecialistTextField.text!
                }
            }
            var language = ""
            if selectedLanguageTextField.text != "ALL" {
                language = selectedLanguageTextField.text!
            }
            var city = ""
            if selectedCityTextField.text != "ALL" {
                city = selectedCityTextField.text!
            }
            var hospital = ""
            if selectedHospitalTextField.text != "ALL" {
                hospital = selectedHospitalTextField.text!
            }
            let province = selectedProvinceTextField.text!
            let lastName = lastNameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let firstName = firstNameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let phoneNumber = phoneNumberTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let address = addressTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let parameters = [
                "surname": lastName,
                "givenname": firstName,
                "gender": gender,
                "language": language,
                "physicianType": physicianType,
                "location": city,
                "hospital": hospital,
                "province": province,
                "phoneNumber": phoneNumber,
                "address": address
            ]
            viewController.parameters = parameters
            
        }
    }
    
    func search() {
        performSegueWithIdentifier("showDoctorsSearchResultList", sender: self)
    }

}

extension DoctorSearchTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}