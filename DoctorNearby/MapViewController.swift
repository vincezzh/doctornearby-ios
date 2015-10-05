//
//  MapViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-01.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    var doctor = Doctor()
    var doctorOffice: MKMapItem?
    var locationManager = CLLocationManager()
    var traveledDistance: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        distanceLabel.alpha = 0
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationMapPage()
    }

    func locationMapPage() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(doctor.address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error == nil {
                if let ps = placemarks {
                    if let pmCircularRegion = ps[0].region as? CLCircularRegion {
                        let metersAcross = pmCircularRegion.radius * 30
                        let region = MKCoordinateRegionMakeWithDistance(pmCircularRegion.center, metersAcross, metersAcross)
                        self.mapView.region = region

                        let annotation = MKPointAnnotation()
                        annotation.coordinate = ps[0].location!.coordinate
                        annotation.title = self.doctor.address
                        annotation.subtitle = self.doctor.contact
                        self.mapView.addAnnotation(annotation)
                        
                        let geocodedPlacemark: CLPlacemark = ps[0]
                        let placemark: MKPlacemark = MKPlacemark(coordinate: geocodedPlacemark.location!.coordinate, addressDictionary: geocodedPlacemark.addressDictionary as? [String : AnyObject])
                        self.doctorOffice = MKMapItem(placemark: placemark)
                        
                    }
                }
            }
        }
    }
    
    @IBAction func clickCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func clickBookmarkButton(sender: AnyObject) {
        
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
    
    @IBAction func clickPhoneButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(doctor.phoneNumber)")!)
    }
    
    @IBAction func clickRouteButton(sender: AnyObject) {
        
        let req = MKDirectionsRequest()
        req.source = MKMapItem.mapItemForCurrentLocation()
        req.destination = doctorOffice
        let dir = MKDirections(request:req)
        dir.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse?, error: NSError?) -> Void in
            if error == nil {
                if let routes = response?.routes {
                    let route = routes[0]
                    let poly = route.polyline
                    self.mapView.addOverlay(poly)
                }
            }
        }
        
        distanceLabel.text = "\(traveledDistance) km to your current location"
        distanceLabel.alpha = 1
        
    }
    
    @IBAction func clickNavigationButton(sender: AnyObject) {
        let options: [String : AnyObject] = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: true]
        MKMapItem.openMapsWithItems([self.doctorOffice!], launchOptions: options)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        var v : MKPolylineRenderer! = nil
        if let overlay = overlay as? MKPolyline {
            v = MKPolylineRenderer(polyline:overlay)
            v.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.8)
            v.lineWidth = 4
        }
        return v
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let doctorOfficeMKMapItem = doctorOffice {
            if traveledDistance == 0 {
                let destinationLocation: CLLocation = CLLocation(latitude: (doctorOfficeMKMapItem.placemark.location?.coordinate.latitude)!, longitude: (doctorOfficeMKMapItem.placemark.location?.coordinate.longitude)!)
                
                let distance = destinationLocation.distanceFromLocation(locations.last! as CLLocation)
                traveledDistance = Int(distance / 1000)
            }
        }

    }
}
