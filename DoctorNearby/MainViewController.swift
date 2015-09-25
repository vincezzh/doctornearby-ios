//
//  MainViewController
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let bc: ButtonCreater = ButtonCreater()
        let testButton = bc.generateButtons(self.view.frame.width - 56 - 16, yPosition: self.view.frame.height - 56 - 16)
        self.view.addSubview(testButton)
        
        let lc: LoaderCreater = LoaderCreater()
        let testLoader = lc.generateLoader(self.view.frame.width * 0.5 - 50, yPosition: self.view.frame.height * 0.5 - 25)
        self.view.addSubview(testLoader)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey("walkthroughPresented") {
            showWalkthrough()
            userDefaults.setBool(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    
    @IBAction func showWalkthrough(){
        
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

