//
//  HospitalTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-06.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class HospitalsTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    let hospitals: Array<String> = Hospital.names()
    var filteredHospitals = Array<String>()
    var selectedHospital: String = ""
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
        self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, self.tableView.bounds.width, 30), animated: false)
        searchBar.delegate = self
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredHospitals.count
        }else {
            return hospitals.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.textColor = UIColor.blackColor()
        
        if searchActive {
            cell.textLabel?.text = filteredHospitals[indexPath.row]
            if selectedHospital == filteredHospitals[indexPath.row] {
                cell.textLabel?.textColor = GlobalConstant.defaultColor
            }
        }else {
            cell.textLabel?.text = hospitals[indexPath.row]
            if selectedHospital == hospitals[indexPath.row] {
                cell.textLabel?.textColor = GlobalConstant.defaultColor
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchActive {
            dismissViewController(filteredHospitals[indexPath.row])
        }else {
            dismissViewController(hospitals[indexPath.row])
        }
    }
    
}

extension HospitalsTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if searchBar.text?.length > 0 {
            searchActive = true;
        }
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
        
        filteredHospitals = hospitals.filter({ (hospital) -> Bool in
            let tempHospital = hospital as NSString
            let range = tempHospital.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if(filteredHospitals.count == 0 && searchBar.text == ""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}

