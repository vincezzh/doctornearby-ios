//
//  MainViewController
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LiquidFloatingActionButton

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let bc: ButtonCreater = ButtonCreater()
    var names = ["section1": ["weatherCell", "nextPillCell", "nextAppointmentCell"]]
    var dateFormatter = NSDateFormatter()
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateButtons()
        self.chechIfShowWalkThrough()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        
        for (key, value) in names {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    @IBAction func showWalkthrough(){
        showWalkThroughPages()
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellID = objectArray[indexPath.section].sectionObjects[indexPath.row]
        return cellID == "weatherCell" ? 100 : 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let cellID = objectArray[indexPath.section].sectionObjects[indexPath.row]
        if cellID == "weatherCell" {
            cell = tableView.dequeueReusableCellWithIdentifier(cellID)! as! MainWeatherCell
        }else if cellID == "nextPillCell" {
            cell = tableView.dequeueReusableCellWithIdentifier(cellID)! as! MainNextPillCell
        }else if cellID == "nextAppointmentCell" {
            cell = tableView.dequeueReusableCellWithIdentifier(cellID)! as! MainNextAppointmentCell
        }else {
            cell = tableView.dequeueReusableCellWithIdentifier(cellID)! as UITableViewCell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension MainViewController: BWWalkthroughViewControllerDelegate {
    func chechIfShowWalkThrough() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey("walkthroughPresented") {
            showWalkthrough()
            userDefaults.setBool(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    
    func showWalkThroughPages() {
        // Get view controllers and build the walkthrough
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pageManager = storyboard.instantiateViewControllerWithIdentifier("WalkPageManager") as! BWWalkthroughViewController
        let pageOne = storyboard.instantiateViewControllerWithIdentifier("WalkPage1")
        let pageTwo = storyboard.instantiateViewControllerWithIdentifier("WalkPage2")
        let pageThree = storyboard.instantiateViewControllerWithIdentifier("WalkPage3")
        
        // Attach the pages to the master
        pageManager.delegate = self
        pageManager.addViewController(pageOne)
        pageManager.addViewController(pageTwo)
        pageManager.addViewController(pageThree)
        
        self.presentViewController(pageManager, animated: true, completion: nil)
    }
    
    func walkthroughPageDidChange(pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension MainViewController: LiquidFloatingActionButtonDelegate {
    func generateButtons() {
        let names: [String] = ["search"]
        let dashboardButtons = bc.generateButtons(names, xPositon: self.view.frame.width - 56 - 16, yPosition: self.view.frame.height - 56 - 16)
        dashboardButtons.delegate = self
        self.view.addSubview(dashboardButtons)
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        if bc.cells[index].name == "search" {
            launchSearchView()
        }
        
        liquidFloatingActionButton.close()
    }
    
    func launchSearchView() {
        print("search")
    }
}

