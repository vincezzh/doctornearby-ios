//
//  LoaderCreater.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-24.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import LiquidLoader

class LoaderCreater {
    
    let defaultColor = UIColor(red: 82 / 255.0, green: 112 / 255.0, blue: 235 / 255.0, alpha: 1.0)
    
    func generateLoader(xPosition: CGFloat, yPosition: CGFloat) -> LiquidLoader {
        
        let lineColor = defaultColor
        let lineFrame = CGRect(x: xPosition, y: yPosition, width: 100, height: 50)
        let lineLoader = LiquidLoader(frame: lineFrame, effect: .GrowLine(lineColor))
        
        return lineLoader
        
    }
    
}
