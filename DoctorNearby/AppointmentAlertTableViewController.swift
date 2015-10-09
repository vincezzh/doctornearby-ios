//
//  AlertTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-08.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class AppointmentAlertTableViewController: UITableViewController {

    var names = ["section1": ["None"], "section2": ["5 mins before", "10 mins before", "30 mins before", "1 hour before", "2 hours before", "1 day before", "2 days before", "1 week before"]]
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectArray = [Objects]()
    
    var onDataAvailable : ((data: String) -> ())?
    
    func sendData(data: String) {
        self.onDataAvailable?(data: data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        for (key, value) in names {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = GlobalConstant.defaultColor
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let title = objectArray[indexPath.section].sectionObjects[indexPath.row]
        let cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("alertCell")! as UITableViewCell
        cell?.textLabel?.text = title
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        navigationController?.popViewControllerAnimated(true)
        self.sendData((cell?.textLabel?.text)!)
    }
    
}
