//
//  SpecializationTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-06.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class SpecializationTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    let specialists: Array<String> = Specialist.names()
    var filteredSpecialists = Array<String>()
    var selectedSpecialist: String = ""
    var searchActive : Bool = false
    var onDataAvailable : ((data: String) -> ())?
    
    func sendData(data: String) {
        self.onDataAvailable?(data: data)
    }
    
    func dismissViewController(value: String) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.sendData(value)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredSpecialists.count
        }else {
            return specialists.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.textColor = UIColor.blackColor()
        
        if searchActive {
            cell.textLabel?.text = filteredSpecialists[indexPath.row]
            if selectedSpecialist == filteredSpecialists[indexPath.row] {
                cell.textLabel?.textColor = GlobalConstant.defaultColor
            }
        }else {
            cell.textLabel?.text = specialists[indexPath.row]
            if selectedSpecialist == specialists[indexPath.row] {
                cell.textLabel?.textColor = GlobalConstant.defaultColor
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchActive {
            dismissViewController(filteredSpecialists[indexPath.row])
        }else {
            dismissViewController(specialists[indexPath.row])
        }
    }
    
}

extension SpecializationTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredSpecialists = specialists.filter({ (specialist) -> Bool in
            let tempSpecialist = specialist as NSString
            let range = tempSpecialist.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if(filteredSpecialists.count == 0 && searchBar.text == ""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}
