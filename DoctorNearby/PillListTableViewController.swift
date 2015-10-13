//
//  PillListTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-09.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
        self.refresher.endRefreshing()
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
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.showActivityIndicator(self.view)
        
        let medicineParams: [String : AnyObject] = ["userId": GlobalConstant.userId()]
        let parameters: [String : AnyObject] = ["medicine": medicineParams]
        
        Alamofire.request(.POST, "\(GlobalConstant.baseServerURL)/user/medicine/list", parameters: parameters, encoding: .JSON)
            .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                
                switch result {
                case .Success(let data):
                    
                    let json = JSON(data: data)
                    if json["data"].count > 0 {
                        for index in 0...json["data"].count - 1 {
                            let pill: Pill = Pill()
                            pill.id = json["data"][index]["_id"]["$oid"].stringValue
                            pill.medicine = json["data"][index]["name"].stringValue
                            pill.leftMinutes = NSTimeInterval(json["data"][index]["leftMinutes"].intValue)
                            
                            self.pills.append(pill)
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
                
                activityIndicator.hideActivityIndicator(self.view)
        }
    }

}
