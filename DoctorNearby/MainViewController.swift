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
    
    let bc: ButtonCreater = ButtonCreater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateButtons()
        self.chechIfShowWalkThrough()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    @IBAction func showWalkthrough(){
        showWalkThroughPages()
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

