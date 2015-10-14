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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        
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
        
        if GlobalFlag.needRefreshBookmark {
            reloadData()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func refresh() {
        reloadData()
    }
    
    func reloadData() {
        
        var parameters = [String: AnyObject]()
        let parameter: [String: String] = ["userId": GlobalConstant.userId()]
        parameters.updateValue(parameter, forKey: "bookmark")
        
        Alamofire.request(.POST, "\(GlobalConstant.baseServerURL)/user/bookmark/list", parameters: parameters, encoding: .JSON)
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
                    
                    GlobalFlag.needRefreshBookmark = false
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Please choose", message: "Which option do you prefer?", preferredStyle: .ActionSheet)
        
        let closeAction: UIAlertAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil)
        actionSheetController.addAction(closeAction)
        
        let showDetailAction: UIAlertAction = UIAlertAction(title: "Show Doctor Detail", style: .Default) { action -> Void in
            self.showDoctorMapView(self.bookmarks[indexPath.row])
        }
        actionSheetController.addAction(showDetailAction)

        let deleteBookmarkAction: UIAlertAction = UIAlertAction(title: "Delete this Bookmark", style: .Default) { action -> Void in
            self.deleteBookmark(self.bookmarks[indexPath.row])
        }
        actionSheetController.addAction(deleteBookmarkAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    
    func deleteBookmark(bookmark: Doctor) {
        
        var parameters = [String: AnyObject]()
        var bookmarkParameter: [String: String] = ["userId": GlobalConstant.userId()]
        bookmarkParameter.updateValue(bookmark.doctorId, forKey: "doctorId")
        parameters.updateValue(bookmarkParameter, forKey: "bookmark")
        
        Alamofire.request(.POST, "\(GlobalConstant.baseServerURL)/user/bookmark/delete", parameters: parameters, encoding: .JSON)
            .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                
                switch result {
                case .Success(let data):
                    
                    let json = JSON(data: data)
                    let isSuccess: Bool = json["success"].boolValue
                    var title = ""
                    var message = ""
                    if isSuccess {
                        title = "Congratulations"
                        message = "The doctor has been deleted in your bookmark list."
                        
                        self.reloadData()
                    }else {
                        title = "I'm sorry"
                        message = "The process is failed."
                    }
                    
                    let actionSheetController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    actionSheetController.addAction(okAction)
                    self.presentViewController(actionSheetController, animated: true, completion: nil)
                    
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
        }
        
    }
    
    func showDoctorMapView(bookmark: Doctor) {
        let viewController = SearchDetailViewController()
        viewController.doctor = bookmark
        viewController.fromBookMarkView = true
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
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