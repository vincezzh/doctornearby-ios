//
//  ButtonCreater.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-24.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import LiquidFloatingActionButton

class ButtonCreater: LiquidFloatingActionButtonDataSource {
    
    var cells = [LiquidFloatingCell]()
    var floatingActionButton: LiquidFloatingActionButton!
    let defaultColor = GlobalConstant.buttonColor()
    
    func generateButtons(names: [String], xPositon: CGFloat, yPosition: CGFloat) -> LiquidFloatingActionButton {
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.color = self.defaultColor
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            return LiquidFloatingCell(name: iconName, icon: UIImage(named: iconName)!)
        }
        
        for name: String in names {
            cells.append(cellFactory(name))
        }
        
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
    
}