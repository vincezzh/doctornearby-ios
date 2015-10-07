//
//  AppointmentListTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-07.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class AppointmentListTableViewController: UITableViewController {
    
    var appointments = [Appointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAppointmentNavigationBarItem()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = GlobalConstant.defaultColor
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.whiteColor()
    }

    func addNewAppointment() {
        performSegueWithIdentifier("showAddNewAppointmentSegue", sender: self)
    }
}
