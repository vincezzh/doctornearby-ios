//
//  DetailViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON

class SearchDetailViewController: SAInboxDetailViewController {
    
    var doctor = Doctor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        let nib = UINib(nibName: DetailViewCell.kCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: DetailViewCell.kCellIdentifier)
        
        title = doctor.name
        
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        
        let color = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        appearance.barTintColor = .whiteColor()
        appearance.tintColor = color
        appearance.titleTextAttributes = [NSForegroundColorAttributeName : color]
        enabledViewControllerBasedAppearance = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailViewCell.kCellIdentifier)!
        
        if let cell = cell as? DetailViewCell {
            cell.doctor = doctor
            cell.mapButton.addTarget(self, action: "showMapView:", forControlEvents:UIControlEvents.TouchUpInside)
            cell.bookmarkButton.addTarget(self, action: "addBookmark:", forControlEvents:UIControlEvents.TouchUpInside)
        }
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGRectGetHeight(tableView.frame)
    }
    
    func showMapView(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        mapViewController.doctor = doctor
        self.presentViewController(mapViewController, animated: true, completion: nil)
        
    }
    
    func addBookmark(sender: UIButton!) {
        var parameters = [String: AnyObject]()
        var bookmarkParameter: [String: String] = ["userId": GlobalConstant.userId()]
        bookmarkParameter.updateValue(doctor.doctorId, forKey: "doctorId")
        parameters.updateValue(bookmarkParameter, forKey: "bookmark")
        
        Alamofire.request(.POST, "\(GlobalConstant.baseServerURL)/user/bookmark/add", parameters: parameters, encoding: .JSON)
            .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                
                switch result {
                case .Success(let data):
                    
                    let json = JSON(data: data)
                    let isSuccess: Bool = json["success"].boolValue
                    var title = ""
                    var message = ""
                    if isSuccess {
                        title = "Congratulations"
                        message = "The doctor has been saved in your bookmark list."
                        
                        GlobalFlag.needRefreshBookmark = true
                    }else {
                        title = "I'm sorry"
                        message = "The process is failed."
                    }
                    
                    let actionSheetController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    actionSheetController.addAction(okAction)
                    self.presentViewController(actionSheetController, animated: true, completion: nil)
                    
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
    }
}