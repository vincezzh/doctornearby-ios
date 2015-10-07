//
//  AppointmentAddTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-07.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class AppointmentAddTableViewController: UITableViewController {
    
    var startsDatePickerCellID = "startsDatePickerCell"
    var endsDatePickerCellID = "endsDatePickerCell"
    var names = ["section1": ["titleCell", "locationCell"], "section2": ["startsCell", "endsCell", "alertCell"]]
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectArray = [Objects]()
    
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellID = objectArray[indexPath.section].sectionObjects[indexPath.row]
        return (cellID == "startsDatePickerCell" || cellID == "endsDatePickerCell") ? 216 : tableView.rowHeight
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = GlobalConstant.defaultColor
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let cellID = objectArray[indexPath.section].sectionObjects[indexPath.row]
        cell = tableView.dequeueReusableCellWithIdentifier(cellID)! as UITableViewCell
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.reuseIdentifier == "startsCell" {
            toggleDatePickerForSelectedIndexPath(indexPath, cellID: "startsDatePickerCell")
        }else if cell?.reuseIdentifier == "endsCell" {
            toggleDatePickerForSelectedIndexPath(indexPath, cellID: "endsDatePickerCell")
        }else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func toggleDatePickerForSelectedIndexPath(indexPath: NSIndexPath, cellID: String) {
        tableView.beginUpdates()
        let datePickerIndex = indexPath.row + 1
        let indexPaths = [NSIndexPath(forRow: datePickerIndex, inSection: indexPath.section)]
        let hasDatePicker = objectArray[indexPath.section].sectionObjects.contains(cellID)
        if hasDatePicker {
            objectArray[indexPath.section].sectionObjects.removeAtIndex(datePickerIndex)
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        }else {
            objectArray[indexPath.section].sectionObjects.insert(cellID, atIndex: datePickerIndex)
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        tableView.endUpdates()
    }
    
}
