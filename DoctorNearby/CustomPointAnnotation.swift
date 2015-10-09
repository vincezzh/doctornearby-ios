//
//  CustomPointAnnotation.swift
//  Discover Life
//
//  Created by Vince Zhang on 2015-07-09.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var iconImage: UIImage!
    var name = ""
    var url: NSURL?
    var mapItem: MKMapItem?
}
