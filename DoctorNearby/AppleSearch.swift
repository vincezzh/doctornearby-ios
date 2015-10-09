//
//  AppleSearch.swift
//  Discover Life
//
//  Created by Vince Zhang on 2015-07-10.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import MapKit

class AppleSearch {
    
    func refreshMapInformation(mapView: MKMapView, location: CLLocation, placeTypes: [String], radius: Double, doctorOfficeAnnotation: MKPointAnnotation?) {
        
        mapView.removeAnnotations(mapView.annotations)
        if let annotation: MKPointAnnotation = doctorOfficeAnnotation {
            mapView.addAnnotation(annotation)
        }
        
        for placeType in placeTypes {
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = placeType
            request.region = mapView.region
            
            let search = MKLocalSearch(request: request)
            
            search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in

                if error != nil {
                    print("Error occured in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count == 0 {
                    print("No matches found")
                } else {
                    for item in response!.mapItems {
                        
                        let placeMark = item.placemark as MKPlacemark!
                        let address = placeMark.addressDictionary as NSDictionary!
                        var titleString: String!
                        var subtitleString: String!
                        var name: String!
                        var street: String!
                        var zip: String!
                        var city: String!
                        
                        let distance = Int(location.distanceFromLocation(placeMark.location!))
                        
                        name = (address.objectForKey("Name") != nil ? address.objectForKey("Name") : "") as! String
                        street = (address.objectForKey("Street") != nil ? address.objectForKey("Street") : "") as! String
                        zip = (address.objectForKey("ZIP") != nil ? address.objectForKey("ZIP") : "") as! String
                        city = (address.objectForKey("City") != nil ? address.objectForKey("City") : "") as! String
                        titleString = "\(name) (\(distance)m)"
                        subtitleString = "\(street), \(city), \(zip)"
                        
                        let pin = CustomPointAnnotation()
                        pin.coordinate = item.placemark.coordinate
                        pin.title = titleString
                        pin.subtitle = subtitleString
                        pin.iconImage = UIImage(named: placeType)
                        
                        pin.name = name
                        pin.url = item.url
                        pin.mapItem = item
                        
                        mapView.addAnnotation(pin)
                    }
                }
            }
        }
    }
    
}
