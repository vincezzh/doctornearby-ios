//
//  FeedViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchListViewController: SAInboxViewController {
    
    var doctors = [Doctor]()
    var parameters = [String: AnyObject]()
    var loadMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search Results"
        
        navigationController?.navigationBarHidden = true
        
        let nib = UINib(nibName: ListViewCell.kCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: ListViewCell.kCellIdentifier)
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.dataSource = self
        tableView.delegate = self
        
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func reloadData() {
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.showActivityIndicator(self.view)
        
        if let skip: Int = parameters["skip"] as? Int {
            parameters.updateValue(Int(GlobalConstant.defaultPageSize), forKey: "limit")
            parameters.updateValue(Int(skip + GlobalConstant.defaultPageSize), forKey: "skip")
        }else {
            parameters.updateValue(Int(GlobalConstant.defaultPageSize), forKey: "limit")
            parameters.updateValue(Int(GlobalConstant.defaultPageStart), forKey: "skip")
        }
        
        Alamofire.request(.POST, "\(GlobalConstant.baseServerURL)/doctor/search", parameters: parameters, encoding: .JSON)
            .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                
                var count = 0
                
                switch result {
                case .Success(let data):
                    
                    let json = JSON(data: data)
                    if json["data"].count > 0 {
                        for index in 0...json["data"].count - 1 {
                            let doctor: Doctor = Doctor()
                            let givenName = json["data"][index]["profile"]["givenName"].stringValue
                            let surName = json["data"][index]["profile"]["surname"].stringValue
                            doctor.name = "\(surName), \(givenName)"
                            doctor.doctorId = json["data"][index]["_id"].stringValue
                            doctor.contact = json["data"][index]["location"]["contactSummary"].stringValue
                            doctor.address = json["data"][index]["location"]["addressSummary"].stringValue
                            // Generate phone number
                            doctor.phoneNumber = ""
                            
                            self.doctors.append(doctor)
                            count++
                        }
                    }
                    
                    if count < GlobalConstant.defaultPageSize {
                        self.loadMore = false
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ListViewCell.kCellIdentifier)!
        
        if let cell = cell as? ListViewCell {
            let doctor = doctors[indexPath.row]
            cell.nameLabel.text = doctor.name
            cell.idLabel.text = doctor.doctorId
            cell.contactLabel.text = doctor.contact
            cell.addressLabel.text = doctor.address
        }
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if loadMore && indexPath.row == doctors.count - 1 {
            reloadData()
        }
    }
}

//MARK: - UITableViewDelegate Methods
extension SearchListViewController {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let viewController = SearchDetailViewController()
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            SAInboxAnimatedTransitioningController.sharedInstance.configureCotainerView(self, cell: cell, cells: tableView.visibleCells, headerImage: headerView.screenshotImage())
        }
        
        let doctor = doctors[indexPath.row]
        viewController.doctor = doctor
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}