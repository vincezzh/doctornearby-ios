//
//  MenuViewController
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case Main = 0
    case Search
    case Appointments
    case Medicines
    case About
}

protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class MenuViewController : UIViewController, LeftMenuProtocol, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var menus = ["Dashboard", "Search", "Appointments", "Medicines", "About"]
    var mainViewController: UIViewController!
    var searchViewController: UIViewController!
    var appointmentViewController: UIViewController!
    var pillViewController: UIViewController!
    var aboutViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let searchViewController = storyboard.instantiateViewControllerWithIdentifier("DoctorSearchTableViewController") as! DoctorSearchTableViewController
        self.searchViewController = UINavigationController(rootViewController: searchViewController)
        
        let appointmentViewController = storyboard.instantiateViewControllerWithIdentifier("AppointmentListTableViewController") as! AppointmentListTableViewController
        self.appointmentViewController = UINavigationController(rootViewController: appointmentViewController)
        
        let pillViewController = storyboard.instantiateViewControllerWithIdentifier("PillListTableViewController") as! PillListTableViewController
        self.pillViewController = UINavigationController(rootViewController: pillViewController)
        
        let aboutViewController = storyboard.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
        aboutViewController.delegate = self
        self.aboutViewController = UINavigationController(rootViewController: aboutViewController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: BaseTableViewCell = BaseTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: BaseTableViewCell.identifier)
        cell.backgroundColor = GlobalConstant.defaultColor
        cell.textLabel?.font = UIFont.italicSystemFontOfSize(18)
        cell.textLabel?.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        cell.textLabel?.text = menus[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    func changeViewController(menu: LeftMenu) {
        switch menu {
        case .Main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
            break
        case .Search:
            self.slideMenuController()?.changeMainViewController(self.searchViewController, close: true)
            break
        case .Appointments:
            self.slideMenuController()?.changeMainViewController(self.appointmentViewController, close: true)
            break
        case .Medicines:
            self.slideMenuController()?.changeMainViewController(self.pillViewController, close: true)
            break
        case .About:
            self.slideMenuController()?.changeMainViewController(self.aboutViewController, close: true)
            break
        }
    }
    
}