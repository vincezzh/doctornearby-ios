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

class MainViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let bc: ButtonCreater = ButtonCreater()
        let testButton = bc.generateButtons(self.view.frame.width - 56 - 16, yPosition: self.view.frame.height - 56 - 16)
        self.view.addSubview(testButton)
        
        let lc: LoaderCreater = LoaderCreater()
        let testLoader = lc.generateLoader(self.view.frame.width * 0.5 - 25, yPosition: self.view.frame.height * 0.5 - 13)
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

    @IBAction func getDoctorById(sender: AnyObject) {
        
        Alamofire.request(.GET, "http://localhost:9091/doctornearby/doctor/103559/detail", parameters: nil)
            .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                
                switch result {
                case .Success(let data):
                    let json = JSON(data: data)
                    print(json["data"]["_id"])
                    print(json["data"]["profile"]["surname"])
                    print(json["data"]["registration"]["trainingList"][0]["medicalSchool"])
                    print(json["data"]["specialtyList"][0]["name"])
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
                
        }
    
    }
    
    @IBAction func searchDoctorsByName(sender: AnyObject) {
        
        let parameters = [
            "name": "zhang",
            "language": "ENGLISH"
        ]
        
        Alamofire.request(.POST, "http://localhost:9091/doctornearby/doctor/search", parameters: parameters, encoding: .JSON)
            .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                
                switch result {
                case .Success(let data):
                    let json = JSON(data: data)
                    for index in 0...json["data"].count - 1 {
                        let givenName = json["data"][index]["profile"]["givenName"]
                        print("\(index): \(givenName)")
                    }
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
                
        }
        
    }
    
}

