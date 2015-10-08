//
//  AppointmentListTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-07.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit
import EventKit

class AppointmentListTableViewController: UITableViewController {
    
    var appointments = [Appointment]()
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAppointmentNavigationBarItem()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        
        getAuthrizationAndInsertEventInCalendar()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = GlobalConstant.defaultColor
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("appointmentCell")! as UITableViewCell
        cell.textLabel?.text = appointments[indexPath.row].title
        return cell
    }

    func addNewAppointment() {
        performSegueWithIdentifier("showAddNewAppointmentSegue", sender: self)
    }
    
    func getAuthrizationAndInsertEventInCalendar() {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case EKAuthorizationStatus.Authorized:
            getEvents(eventStore)
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Event, completion: { (granted: Bool, error: NSError?) -> Void in
                if granted {
                    self.getEvents(eventStore)
                } else {
                    print("Access denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    
    func getEvents(store: EKEventStore) {
        let calendars = store.calendarsForEntityType(EKEntityType.Event)
        
        for calendar in calendars {
            if calendar.title == GlobalConstant.defaultCalendar {
                let endDate = NSDate(timeIntervalSinceNow: NSTimeInterval(GlobalConstant.defaultCalendarPeriod));
                let predicate = store.predicateForEventsWithStartDate(NSDate(), endDate: endDate, calendars: [calendar])
                let events: [EKEvent] = store.eventsMatchingPredicate(predicate)
                if events.count > 0 {
                    for event in events {
                        if let notes = event.notes {
                            if notes.contains(GlobalConstant.brandFlag) {
                                let appointment = Appointment()
                                appointment.title = event.title
                                if let location = event.location {
                                    appointment.location = location
                                }
                                appointment.startsTime = dateFormatter.stringFromDate(event.startDate)
                                appointment.endsTime = dateFormatter.stringFromDate(event.endDate)
                                appointments.append(appointment)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
