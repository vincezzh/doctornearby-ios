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
    let defaultColor = GlobalConstant.defaultColor
    
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
            return LiquidFloatingCell(name: iconName, icon: UIImage(named: iconName)!)
        }
        
        cells.append(cellFactory("pill"))
        cells.append(cellFactory("bookmark"))
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
        if cells[index].name == "pill" {
            launchPillView()
        }else if cells[index].name == "bookmark" {
            launchBookmarkView()
        }else if cells[index].name == "search" {
            launchSearchView()
        }
        
        liquidFloatingActionButton.close()
    }
    
    func launchSearchView() {
        print("search")
    }
    
    func launchBookmarkView() {
        print("bookmark")
    }
    
    func launchPillView() {
        print("pill")
    }
    
}