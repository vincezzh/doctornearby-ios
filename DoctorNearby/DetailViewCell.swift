//
//  DetailViewCell.swift
//  SAInboxViewControllerSample
//
//  Created by Taiki Suzuki on 2015/08/15.
//  Copyright (c) 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailViewCell: UITableViewCell {

    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    static let kCellIdentifier = "DetailViewCell"
    var content: Doctor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        loadWebPage()
    }
    
    func loadWebPage() {

//        let lc: LoaderCreater = LoaderCreater()
//        let loader = lc.generateLoader(self.frame.width * 0.5 - 25, yPosition: self.frame.height * 0.5 - 13)
//        self.addSubview(loader)
        
        let activityIndicator = ActivityIndicator()
        activityIndicator.showActivityIndicator(self)
        
        Alamofire.request(.GET, "\(GlobalConstant.baseServerURL)/doctor/\(content!.doctorId)/profile", parameters: nil, encoding: .JSON)
            .responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<NSData>) -> Void in
                
                switch result {
                case .Success(let data):
                    
                    let json = JSON(data: data)
                    if let html: String = json["data"]["html"].stringValue {
                        self.webView.loadHTMLString(html, baseURL: nil)
                    }
                    
                case .Failure(let data, let error):
                    print("Request failed with error: \(error)")
                    if let data = data {
                        print("Response data: \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                    }
                }
                
//                loader.removeFromSuperview()
                activityIndicator.hideActivityIndicator(self)
                
        }

    }
    
    @IBAction func clickPhoneButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://(416) 461-8363")!)
    }
    
    @IBAction func clickBookmarkButton(sender: AnyObject) {
    }
    
}
