//
//  CountryTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-27.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class CountryTableViewController: UITableViewController {
    
    let allNames = ["Canada": ["Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland and Labrador", "Nova Scotia", "Northwest Territories", "Nunavut", "Ontario", "Prince Edward Island", "Quebec", "Saskatchewan",  "Yukon"]]
    let activeNames = ["British Columbia", "Ontario", "Quebec"]
    var selectedProvince: String = ""
    var onDataAvailable : ((data: String) -> ())?
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectArray = [Objects]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, self.tableView.bounds.width, 30), animated: false)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        for (key, value) in allNames {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
    }
    
    func sendData(data: String) {
        self.onDataAvailable?(data: data)
    }
    
    func dismissViewController(value: String) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.sendData(value)
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = GlobalConstant.defaultColor
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let title = objectArray[indexPath.section].sectionObjects[indexPath.row]
        cell.textLabel?.text = title
        if activeNames.contains(title) {
            cell.textLabel?.textColor = UIColor.blackColor()
        }else {
            cell.textLabel?.textColor = UIColor.lightGrayColor()
        }
        
        if selectedProvince == title {
            cell.textLabel?.textColor = GlobalConstant.defaultColor
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let title = objectArray[indexPath.section].sectionObjects[indexPath.row]
        if activeNames.contains(title) {
            dismissViewController(objectArray[indexPath.section].sectionObjects[indexPath.row])
        }else {
            let alertController = UIAlertController(title: "Coming soon", message: "I'm sorry. \(title) will come very shortly.", preferredStyle: .Alert)
            let buttonOK = UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(buttonOK)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}
