//
//  MainViewController
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit
import MapKit
import EventKit
import Alamofire
import SwiftyJSON
import LiquidFloatingActionButton

class MainViewController: UIViewController {
    
    @IBOutlet weak var pillTime: UILabel!
    @IBOutlet weak var pillName: UILabel!
    @IBOutlet weak var appointmentTime: UILabel!
    @IBOutlet weak var appointmentNameLabel: UILabel!
    @IBOutlet weak var provinceButton: UIButton!
    @IBOutlet weak var locationTextfield: UILabel!
    @IBOutlet weak var degreeTextField: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherTextfield: UILabel!
    @IBOutlet weak var dateTextfield: UILabel!
    
    let bc: ButtonCreater = ButtonCreater()
    let locationManager = CLLocationManager()
    var dateFormatter = NSDateFormatter()
    var country = ""
    var city = ""
    
    var timer = NSTimer()
    let timeInterval: NSTimeInterval = 30
    var timeCount: NSTimeInterval = 0.0
    var pillLeftMinutes: NSTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.generateButtons()
        self.chechIfShowWalkThrough()
        
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        loadRecentAppointment()
        loadRecentPill()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    @IBAction func showWalkthrough(){
        showWalkThroughPages()
    }
    
    func loadRecentAppointment() {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case EKAuthorizationStatus.Authorized:
            getEvents(eventStore)
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Event, completion: { (granted: Bool, error: NSError?) -> Void in
                if granted {
                    self.getEvents(eventStore)
                } else {
                    print("Access denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    
    func getEvents(store: EKEventStore) {
        var hasEvent = false
        
        let calendars = store.calendarsForEntityType(EKEntityType.Event)
        for calendar in calendars {
            if calendar.type == EKCalendarType.CalDAV {
                let endDate = NSDate(timeIntervalSinceNow: NSTimeInterval(GlobalConstant.defaultCalendarPeriod));
                let predicate = store.predicateForEventsWithStartDate(NSDate(), endDate: endDate, calendars: [calendar])
                let events: [EKEvent] = store.eventsMatchingPredicate(predicate)
                if events.count > 0 {
                    for event in events {
                        if let notes = event.notes {
                            if notes.contains(GlobalConstant.brandFlag) {
                                appointmentNameLabel.text = event.title
                                appointmentTime.text = dateFormatter.stringFromDate(event.startDate)
                                hasEvent = true
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        if !hasEvent {
            appointmentNameLabel.text = "No Appointment Recently"
            appointmentTime.text = ""
        }
    }
    
    func loadRecentPill() {
        let medicineParams: [String : AnyObject] = ["userId": GlobalConstant.userId()]
        let parameters: [String : AnyObject] = ["medicine": medicineParams]
        
        Alamofire.request(.POST, "\(GlobalFlag.baseServerURL)/user/medicine/recentOne", parameters: parameters, encoding: .JSON)
            .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                
                switch result {
                case .Success(let data):
                    
                    let json = JSON(data: data)
                    if json["data"].count > 0 {
                        self.pillName.text = json["data"]["name"].stringValue
                        self.pillLeftMinutes = NSTimeInterval(json["data"]["leftMinutes"].intValue)
                        
                        if !self.timer.valid {
                            self.timeCount = self.pillLeftMinutes * 60
                            self.pillTime.text = self.timeString(self.pillLeftMinutes * 60)
                            self.timer = NSTimer.scheduledTimerWithTimeInterval(self.timeInterval,
                                target: self,
                                selector: "timerDidEnd:",
                                userInfo: nil,
                                repeats: true)
                        }
                    }else {
                        self.pillName.text = "No Medecine"
                        self.pillTime.text = ""
                    }
                    
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
                
        }
    }
    
    func timerDidEnd(timer: NSTimer){
        
        timeCount = timeCount - timeInterval
        if timeCount <= 0 {
            pillTime.text = "Medicine to go"
            timer.invalidate()
        } else {
            pillTime.text = timeString(timeCount)
        }
        
    }
    
    func timeString(time: NSTimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) - hours * 3600) / 60
        if hours == 0 && minutes == 0 {
            return "Less than 1m"
        }else {
            return String(format:"%02ih %02im", hours, minutes)
        }
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

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if city == "" {
            let location: CLLocation = manager.location!
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                
                if let placeMark: CLPlacemark = placemarks![0] {
                    if let tempCity = placeMark.addressDictionary!["City"] as? NSString {
                        self.city = tempCity.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                        self.locationTextfield.text = self.city
                    }
                    if let tempCountry = placeMark.addressDictionary!["Country"] as? NSString {
                        self.country = tempCountry.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                    }
                    self.loadWeather()
                }
            })
        }
    }
    
    func loadWeather() {
        
        if city != "" {
            
            let activityIndicator = ActivityIndicator()
            activityIndicator.showActivityIndicator(self.view)
            let weatherUrl = "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(city)%2C%20\(country)%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
            
            Alamofire.request(.GET, weatherUrl, parameters: nil, encoding: .JSON)
                .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                    
                    switch result {
                    case .Success(let data):
                        
                        let json = JSON(data: data)
                        if json["query"].count > 0 {
                            let date = json["query"]["results"]["channel"]["item"]["condition"]["date"].stringValue
                            let fTemp = json["query"]["results"]["channel"]["item"]["condition"]["temp"].stringValue
                            let cTemp = Int((Double(fTemp)! - 32) * 0.5556)
                            let weather = json["query"]["results"]["channel"]["item"]["condition"]["text"].stringValue
                            
                            self.dateTextfield.text = date
                            self.degreeTextField.text = "\(cTemp)"
                            self.weatherTextfield.text = weather
                            
                            if weather.contains("Snow") {
                                self.weatherImage.image = UIImage(named: "snow")
                            }else if weather.contains("Cloudy") {
                                self.weatherImage.image = UIImage(named: "cloudy")
                            }else if weather.contains("Rain") {
                                self.weatherImage.image = UIImage(named: "rainy")
                            }else if weather.contains("Sun") {
                                self.weatherImage.image = UIImage(named: "sunny")
                            }else if weather.contains("Fog") {
                                self.weatherImage.image = UIImage(named: "fog")
                            }else {
                                self.weatherImage.image = UIImage(named: "weather")
                            }
                        }
                        
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
    
}

