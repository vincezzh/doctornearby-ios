//
//  CountryTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-27.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class CountryTableViewController: UITableViewController {
    
    let allNames = ["Canada": ["British Columbia", "Ontario", "Quebec"]]
    let activeNames = ["British Columbia", "Ontario", "Quebec"]
    var selectedName: String = ""
    var onDataAvailable : ((data: String) -> ())?
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectArray = [Objects]()

    override func viewDidLoad() {
        super.viewDidLoad()

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
            cell.textLabel?.tintColor = UIColor.blackColor()
        }else {
            cell.textLabel?.tintColor = UIColor.lightGrayColor()
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
