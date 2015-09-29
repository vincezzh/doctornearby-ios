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
    
    var contents: [Doctor] = []
    var parameters: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Search Results"
        
        navigationController?.navigationBarHidden = true
        
        let nib = UINib(nibName: ListViewCell.kCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: ListViewCell.kCellIdentifier)
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        reloadData()
    }
    
    func reloadData() {
        Alamofire.request(.POST, "http://localhost:9091/doctornearby/doctor/search", parameters: parameters, encoding: .JSON)
            .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                
                switch result {
                case .Success(let data):
                    
                    let json = JSON(data: data)
                    if json["data"].count > 0 {
                        for index in 0...json["data"].count - 1 {
                            let doctor: Doctor = Doctor()
                            doctor.name = json["data"][index]["profile"]["givenName"].stringValue
                            self.contents.append(doctor)
                        }
                    }
                    self.tableView.reloadData()
                    
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
                
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
            let content = contents[indexPath.row]
            cell.setUsername(content.name)
            cell.setMainText(content.address)
        }
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
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
        
        let content = contents[indexPath.row]
        viewController.name = content.name
        viewController.address = content.address
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}