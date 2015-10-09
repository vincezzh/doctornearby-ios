//
//  PillListTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-09.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class PillListTableViewController: UITableViewController {

    var pills = [Pill]()
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPillNavigationBarItem()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalFlag.needRefreshPill {
            reloadData()
        }
    }
    
    func refresh() {
        reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pills.count
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = GlobalConstant.defaultColor
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pillCell")! as! PillListCell
        cell.pill = pills[indexPath.row]
        return cell
    }
    
    func addNewPill() {
        performSegueWithIdentifier("showaddNewPillSegue", sender: self)
    }
    
    func reloadData() {
        pills.removeAll()
        
        let pill1 = Pill()
        pill1.medicine = "Vitamin A"
        pill1.secondsLeft = 15
        pills.append(pill1)
        
        let pill2 = Pill()
        pill2.medicine = "Vitamin B"
        pill2.secondsLeft = 10245
        pills.append(pill2)
        
        self.tableView.reloadData()
        self.refresher.endRefreshing()
    }

}
