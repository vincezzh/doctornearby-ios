//
//  SearchViewController
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class SearchViewController : UIViewController, UIPopoverPresentationControllerDelegate, KSTokenViewDelegate {
    
    @IBOutlet var tokenView: KSTokenView!
    let names: Array<String> = City.names()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenView.delegate = self
        tokenView.promptText = "City: "
        tokenView.placeholder = "Search"
//        tokenView.descriptionText = "Languages"
        tokenView.maxTokenLimit = 1
        tokenView.style = .Rounded
        tokenView.searchResultSize = CGSize(width: tokenView.frame.width, height: 220)
    }
    
    func tokenView(token: KSTokenView, performSearchWithString string: String, completion: ((results: Array<AnyObject>) -> Void)?) {
        var data: Array<String> = []
        for value: String in names {
            if value.lowercaseString.rangeOfString(string.lowercaseString) != nil {
                data.append(value)
            }
        }
        completion!(results: data)
    }
    
    func tokenView(token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let popupView = segue.destinationViewController as? UIViewController {
            if let popup = popupView.popoverPresentationController {
                popup.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    @IBAction func changeSelectedIndex(sender: IGSwitch) {
        print(sender.selectedIndex)
    }
    
}
