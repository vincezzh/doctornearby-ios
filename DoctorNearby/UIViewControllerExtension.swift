//
//  UIViewControllerExtension
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "menu-navi")!)
        self.addRightBarButtonWithImage(UIImage(named: "bookmark-navi")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func setSearchNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "menu-navi")!)
        self.addCustomRightBarButtonWithImage(UIImage(named: "search-navi")!, actionName: "search")
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func setAppointmentNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "menu-navi")!)
        self.addCustomRightBarButtonWithImage(UIImage(named: "add-navi")!, actionName: "addNewAppointment")
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func addCustomRightBarButtonWithImage(buttonImage: UIImage, actionName: String) {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector(actionName))
        rightButton.tintColor = UIColor(red: 68 / 255.0, green: 169 / 255.0, blue: 138 / 255.0, alpha: 1.0)
        navigationItem.rightBarButtonItem = rightButton;
    }
    
}