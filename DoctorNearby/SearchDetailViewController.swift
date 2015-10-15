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
import LiquidFloatingActionButton

class SearchDetailViewController: SAInboxDetailViewController {
    
    let bc: ButtonCreater = ButtonCreater()
    var doctor = Doctor()
    var fromBookMarkView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateButtons()
        
        tableView.dataSource = self
        
        let nib = UINib(nibName: DetailViewCell.kCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: DetailViewCell.kCellIdentifier)
        
        title = doctor.name
        
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        
        appearance.barTintColor = GlobalConstant.defaultColor
        appearance.tintColor = UIColor.whiteColor()
        appearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        enabledViewControllerBasedAppearance = true
        
        if fromBookMarkView {
            addCloseButton()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    func addCloseButton() {
        let closeButtonItem = UIBarButtonItem()
        let closeButton: UIButton = UIButton()
        closeButton.setImage(UIImage(named: "close-icon"), forState: .Normal)
        closeButton.frame = CGRectMake(0, 0, 32, 32)
        closeButton.addTarget(self, action: "didTapCloseButton:", forControlEvents: .TouchUpInside)
        closeButtonItem.customView = closeButton
        headerView.navigationItem.setRightBarButtonItem(closeButtonItem, animated: false)
    }
    
    func didTapCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension SearchDetailViewController: LiquidFloatingActionButtonDelegate {
    func generateButtons() {
        var names: [String] = ["search", "bookmark", "phone", "map"]
        if fromBookMarkView {
            names = ["home", "phone", "map"]
        }
        let dashboardButtons = bc.generateButtons(names, xPositon: self.view.frame.width - 56 - 16, yPosition: self.view.frame.height - 56 - 16)
        dashboardButtons.delegate = self
        self.view.addSubview(dashboardButtons)
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        if bc.cells[index].name == "bookmark" {
            addBookmark()
        }else if bc.cells[index].name == "phone" {
            callDoctorClinic()
        }else if bc.cells[index].name == "map" {
            launchMapView()
        }else if bc.cells[index].name == "search" || bc.cells[index].name == "home" {
            goToRootPage()
        }
        
        liquidFloatingActionButton.close()
    }
    
    func goToRootPage() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addBookmark() {
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
    
    func callDoctorClinic() {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(doctor.phoneNumber())")!)
    }
    
    func launchMapView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        mapViewController.doctor = doctor
        mapViewController.fromBookMarkView = fromBookMarkView
        self.presentViewController(mapViewController, animated: true, completion: nil)
    }
}

extension SearchDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailViewCell.kCellIdentifier)!
        
        if let cell = cell as? DetailViewCell {
            cell.doctor = doctor
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
}