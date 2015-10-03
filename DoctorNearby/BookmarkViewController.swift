//
//  BookmarkViewController
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    var refresher: UIRefreshControl!
    var bookmarks = [Doctor]()
    var searchActive : Bool = false
    var filteredBookmarks = [Doctor]()
    var parameters = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        bookmarkTableView.addSubview(refresher)
        
        let nib = UINib(nibName: BookmarkListCell.kCellIdentifier, bundle: nil)
        bookmarkTableView.registerNib(nib, forCellReuseIdentifier: BookmarkListCell.kCellIdentifier)
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        
        searchBar.delegate = self
        
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func refresh() {
        reloadData()
    }
    
    func reloadData() {
        
        parameters.updateValue(GlobalConstant.userId(), forKey: "userId")
        
        Alamofire.request(.POST, "\(GlobalConstant.baseServerURL)/doctor/bookmarks", parameters: parameters, encoding: .JSON)
            .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                
                switch result {
                case .Success(let data):
                    
                    self.bookmarks.removeAll()
                    
                    let json = JSON(data: data)
                    if json["data"].count > 0 {
                        for index in 0...json["data"].count - 1 {
                            let doctor: Doctor = Doctor()
                            let givenName = json["data"][index]["profile"]["givenName"].stringValue
                            let surName = json["data"][index]["profile"]["surname"].stringValue
                            doctor.name = "\(surName), \(givenName)"
                            doctor.doctorId = json["data"][index]["_id"].stringValue
                            doctor.contact = json["data"][index]["location"]["contactSummary"].stringValue
                            doctor.address = json["data"][index]["location"]["addressSummary"].stringValue
                            
                            self.bookmarks.append(doctor)
                        }
                    }
                    
                    self.bookmarkTableView.reloadData()
                    
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
                
                self.refresher.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredBookmarks.count
        }else {
            return bookmarks.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BookmarkListCell.kCellIdentifier)!
        
        if let cell = cell as? BookmarkListCell {
            var bookmark = bookmarks[indexPath.row]
            if searchActive {
                bookmark = filteredBookmarks[indexPath.row]
            }
            cell.nameLabel.text = bookmark.name
        }
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
    
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
        
        filteredBookmarks = bookmarks.filter({ (doctor) -> Bool in
            let tempName = doctor.name as NSString
            let range = tempName.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if(filteredBookmarks.count == 0 && searchBar.text == ""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        bookmarkTableView.reloadData()
    }
    
}