//
//  CitiesTableViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-10-06.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    let cities: Array<String> = City.names()
    var filteredCities = Array<String>()
    var selectedCity: String = ""
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
            return filteredCities.count
        }else {
            return cities.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.textColor = UIColor.blackColor()
        
        if searchActive {
            cell.textLabel?.text = filteredCities[indexPath.row]
            if selectedCity == filteredCities[indexPath.row] {
                cell.textLabel?.textColor = GlobalConstant.defaultColor
            }
        }else {
            cell.textLabel?.text = cities[indexPath.row]
            if selectedCity == cities[indexPath.row] {
                cell.textLabel?.textColor = GlobalConstant.defaultColor
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchActive {
            dismissViewController(filteredCities[indexPath.row])
        }else {
            dismissViewController(cities[indexPath.row])
        }
    }
    
}

extension CitiesTableViewController: UISearchBarDelegate {
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
        
        filteredCities = cities.filter({ (city) -> Bool in
            let tempCity = city as NSString
            let range = tempCity.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if(filteredCities.count == 0 && searchBar.text == ""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}