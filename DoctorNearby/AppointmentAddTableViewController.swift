//
//  AppointmentAddTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-07.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit
import EventKit

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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        
        for (key, value) in names {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            self.view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
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
        if cellID == "titleCell" {
            cell = tableView.dequeueReusableCellWithIdentifier(cellID)! as! AppointmentTitleCell
        }else if cellID == "locationCell" {
            cell = tableView.dequeueReusableCellWithIdentifier(cellID)! as! AppointmentLocationCell
        }else {
            cell = tableView.dequeueReusableCellWithIdentifier(cellID)! as UITableViewCell
        }
        
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
        getAuthrizationAndInsertEventInCalendar()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getAuthrizationAndInsertEventInCalendar() {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case EKAuthorizationStatus.Authorized:
            insertEvent(eventStore)
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Event, completion: { (granted: Bool, error: NSError?) -> Void in
                if granted {
                    self.insertEvent(eventStore)
                } else {
                    print("Access denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    
    func insertEvent(store: EKEventStore) {
        let calendars = store.calendarsForEntityType(EKEntityType.Event)
        
        for calendar in calendars {
            if calendar.title == GlobalConstant.defaultCalendar {
                
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                event.title = getLabelText("titleCell")
                event.location = getLabelText("locationCell")
                event.startDate = getDateFromString("startsCell")
                event.endDate = getDateFromString("endsCell")
                event.notes = GlobalConstant.brandFlag

                let seconds = caculateAlarmInSecond()
                if(seconds != -1) {
                    let alarm:EKAlarm = EKAlarm(relativeOffset: NSTimeInterval(seconds))
                    event.alarms = [alarm]
                }
                
                do {
                    try store.saveEvent(event, span: EKSpan.ThisEvent)
                    GlobalFlag.needRefreshAppointment = true
                }catch {
                    print("Event save failed")
                }
            }
        }
    }
    
    func caculateAlarmInSecond() -> Int {
        var seconds = -1
        let row: Int = objectArray[1].sectionObjects.indexOf("alertCell")!
        let targetedCellIndexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 1)
        let cell = tableView.cellForRowAtIndexPath(targetedCellIndexPath)
        let labelText = cell?.detailTextLabel?.text
        
        if labelText == "5 mins before" {
            seconds = -60 * 5
        }else if labelText == "10 mins before" {
            seconds = -60 * 10
        }else if labelText == "30 mins before" {
            seconds = -60 * 30
        }else if labelText == "1 hour before" {
            seconds = -60 * 60 * 1
        }else if labelText == "2 hours before" {
            seconds = -60 * 60 * 2
        }else if labelText == "1 day before" {
            seconds = -60 * 60 * 24 * 1
        }else if labelText == "2 days before" {
            seconds = -60 * 60 * 24 * 2
        }else if labelText == "1 week before" {
            seconds = -60 * 60 * 24 * 7
        }else {
            seconds = -1
        }
        
        return seconds
    }
    
    func getLabelText(cellID: String) -> String {
        let row: Int = objectArray[0].sectionObjects.indexOf(cellID)!
        let targetedCellIndexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 0)
        var labelText = ""
        if cellID == "titleCell" {
            let cell = tableView.cellForRowAtIndexPath(targetedCellIndexPath) as! AppointmentTitleCell
            labelText = cell.titleTextField.text!
        }else if cellID == "locationCell" {
            let cell = tableView.cellForRowAtIndexPath(targetedCellIndexPath) as! AppointmentLocationCell
            labelText = cell.locationTextField.text!
        }
        return labelText
    }
    
    func getDateFromString(cellID: String) -> NSDate {
        let row: Int = objectArray[1].sectionObjects.indexOf(cellID)!
        let targetedCellIndexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 1)
        let cell = tableView.cellForRowAtIndexPath(targetedCellIndexPath)
        return dateFormatter.dateFromString((cell?.detailTextLabel?.text)!)!
    }
    
    func doAlertWithData(data: String) {
        let row: Int = objectArray[1].sectionObjects.indexOf("alertCell")!
        let targetedCellIndexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 1)
        let cell = tableView.cellForRowAtIndexPath(targetedCellIndexPath)
        cell?.detailTextLabel?.text = data
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popupAlertSegue" {
            if let viewController = segue.destinationViewController as? AppointmentAlertTableViewController {
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
