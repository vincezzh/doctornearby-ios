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
    var dateFormatter = NSDateFormatter()
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        
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
        
        let now = NSDate()
        if cellID == "startsCell" {
            cell?.detailTextLabel?.text = dateFormatter.stringFromDate(now)
        }else if cellID == "endsCell" {
            let afterAnHourNow = now.dateByAddingTimeInterval(3600)
            cell?.detailTextLabel?.text = dateFormatter.stringFromDate(afterAnHourNow)
        }else if cellID == "alertCell" {
            cell?.detailTextLabel?.text = "None"
        }
        
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
    
    @IBAction func changeStartsDatePicker(sender: AnyObject) {
        let row: Int = objectArray[1].sectionObjects.indexOf("startsCell")!
        let targetedCellIndexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 1)
        let cell = tableView.cellForRowAtIndexPath(targetedCellIndexPath)
        let targetedDatePicker = sender as! UIDatePicker
        cell?.detailTextLabel?.text = dateFormatter.stringFromDate(targetedDatePicker.date)
    }
    
    @IBAction func changeEndsDatePicker(sender: AnyObject) {
        let row: Int = objectArray[1].sectionObjects.indexOf("endsCell")!
        let targetedCellIndexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 1)
        let cell = tableView.cellForRowAtIndexPath(targetedCellIndexPath)
        let targetedDatePicker = sender as! UIDatePicker
        cell?.detailTextLabel?.text = dateFormatter.stringFromDate(targetedDatePicker.date)
    }
    
    @IBAction func clickCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clickSaveButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doAlertWithData(data: String) {
        let row: Int = objectArray[1].sectionObjects.indexOf("alertCell")!
        let targetedCellIndexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 1)
        let cell = tableView.cellForRowAtIndexPath(targetedCellIndexPath)
        cell?.detailTextLabel?.text = data
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popupAlertSegue" {
            if let viewController = segue.destinationViewController as? AlertTableViewController {
                viewController.onDataAvailable = {[weak self]
                    (data) in
                    if let weakSelf = self {
                        weakSelf.doAlertWithData(data)
                    }
                }
            }
        }
    }
    
}
