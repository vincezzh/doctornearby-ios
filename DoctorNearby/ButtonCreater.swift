//
//  ButtonCreater.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-24.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import LiquidFloatingActionButton

class ButtonCreater: LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate {
    
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    let defaultColor = UIColor(red: 82 / 255.0, green: 112 / 255.0, blue: 235 / 255.0, alpha: 1.0)
    
    func generateButtons(xPositon: CGFloat, yPosition: CGFloat) -> LiquidFloatingActionButton {
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.color = self.defaultColor
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            return LiquidFloatingCell(icon: UIImage(named: iconName)!)
        }
        cells.append(cellFactory("settings"))
        cells.append(cellFactory("bookmark"))
        cells.append(cellFactory("pill"))
        cells.append(cellFactory("calendar"))
        cells.append(cellFactory("search"))
        
        let floatingFrame = CGRect(x: xPositon, y: yPosition, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        
        return bottomRightButton
    }
    
    @objc func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    @objc func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    @objc func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        
        liquidFloatingActionButton.close()
    }
    
}