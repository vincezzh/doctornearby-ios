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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
    }

}
