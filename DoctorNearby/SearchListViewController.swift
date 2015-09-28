//
//  FeedViewController.swift
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class SearchListViewController: SAInboxViewController {
    
    private var contents: [DoctorContent] = [
        DoctorContent(name: "Vince Zhang", contact: "Phone: 416-839-7036", address: "38 Lindisfarne Way, Markham, L3P3W9, Canada"),
        DoctorContent(name: "Vince Zhang", contact: "Phone: 416-839-7036", address: "38 Lindisfarne Way, Markham, L3P3W9, Canada"),
        DoctorContent(name: "Vince Zhang", contact: "Phone: 416-839-7036", address: "38 Lindisfarne Way, Markham, L3P3W9, Canada")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Search Results"
        
        navigationController?.navigationBarHidden = true
        
        let nib = UINib(nibName: ListViewCell.kCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: ListViewCell.kCellIdentifier)
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    struct DoctorContent {
        var name: String
        var contact: String
        var address: String
    }
}

extension SearchListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ListViewCell.kCellIdentifier)!
        
        if let cell = cell as? ListViewCell {
            let content = contents[indexPath.row]
            cell.setUsername(content.name)
            cell.setMainText(content.address)
        }
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
}

//MARK: - UITableViewDelegate Methods
extension SearchListViewController {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let viewController = SearchDetailViewController()
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            SAInboxAnimatedTransitioningController.sharedInstance.configureCotainerView(self, cell: cell, cells: tableView.visibleCells, headerImage: headerView.screenshotImage())
        }
        
        let content = contents[indexPath.row]
        viewController.name = content.name
        viewController.address = content.address
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}