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
    
    func setAboutNavigationBarItem() {
        self.title = "About"
        self.addCustomLeftBarButtonWithImage(UIImage(named: "home-navi")!, actionName: "goMain")
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func setSearchNavigationBarItem() {
        self.title = "Search"
        self.addLeftBarButtonWithImage(UIImage(named: "menu-navi")!)
        self.addCustomRightBarButtonWithImage(UIImage(named: "search-navi")!, actionName: "search")
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func setAppointmentNavigationBarItem() {
        self.title = "In 90 days Appointments"
        self.addLeftBarButtonWithImage(UIImage(named: "menu-navi")!)
        self.addCustomRightBarButtonWithImage(UIImage(named: "add-navi")!, actionName: "addNewAppointment")
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func setPillNavigationBarItem() {
        self.title = "Medicines"
        self.addLeftBarButtonWithImage(UIImage(named: "menu-navi")!)
        self.addCustomRightBarButtonWithImage(UIImage(named: "add-navi")!, actionName: "addNewPill")
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func addCustomLeftBarButtonWithImage(buttonImage: UIImage, actionName: String) {
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector(actionName))
        leftButton.tintColor = GlobalConstant.defaultColor
        navigationItem.leftBarButtonItem = leftButton;
    }
    
    func addCustomRightBarButtonWithImage(buttonImage: UIImage, actionName: String) {
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector(actionName))
        rightButton.tintColor = GlobalConstant.defaultColor
        navigationItem.rightBarButtonItem = rightButton;
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            self.view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    func showAlertPopup(title: String, message: String) {
            let actionController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            actionController.addAction(okAction)
            self.presentViewController(actionController, animated: true, completion: nil)
    }
}
    
