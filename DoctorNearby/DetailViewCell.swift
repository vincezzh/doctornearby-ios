//
//  DetailViewCell.swift
//  SAInboxViewControllerSample
//
//  Created by Taiki Suzuki on 2015/08/15.
//  Copyright (c) 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import MapKit

class DetailViewCell: UITableViewCell, CLLocationManagerDelegate, MKMapViewDelegate {

    static let kCellIdentifier = "DetailViewCell"

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var webView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
    }
    
    func loadWebPage() {
        let url = NSURL(string: "http://www.akhaltech.com")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
//        webView.loadHTMLString("<html><body><h1>Hello World!!!</h1></body></html>", baseURL: nil)
    }
    
    func locationMapPage() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressLabel.text!) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error == nil {
                if let ps = placemarks {
                    if let pmCircularRegion = ps[0].region as? CLCircularRegion {
                        let metersAcross = pmCircularRegion.radius * 10
                        let region = MKCoordinateRegionMakeWithDistance(pmCircularRegion.center, metersAcross, metersAcross)
                        self.mapView.region = region
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = ps[0].location!.coordinate
                        annotation.title = self.addressLabel.text
                        annotation.subtitle = self.contactLabel.text
                        self.mapView.addAnnotation(annotation)

                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        locationMapPage()
        loadWebPage()
    }
}
