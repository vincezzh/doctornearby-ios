//
//  SearchViewController
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class SearchViewController : UIViewController, UIPopoverPresentationControllerDelegate, KSTokenViewDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet var languageView: KSTokenView!
    let languages: Array<String> = Language.names()
    @IBOutlet var specialistView: KSTokenView!
    let specialists: Array<String> = Specialist.names()
    @IBOutlet var cityView: KSTokenView!
    let cities: Array<String> = City.names()
    @IBOutlet var hospitalView: KSTokenView!
    let hospitals: Array<String> = Hospital.names()
    
    var doctorTypeSwitchIndex = 0
    
    func initComponents() {
        
        nameTextField.delegate = self
        
        genderButton.layer.cornerRadius = 5
        genderButton.layer.borderWidth = 1
        genderButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        languageView.delegate = self
        languageView.promptText = "Language: "
        languageView.placeholder = "Search"
        languageView.descriptionText = "language"
        languageView.maxTokenLimit = 1
        languageView.style = .Rounded
        languageView.shouldHideSearchResultsOnSelect = true
        languageView.searchResultSize = CGSize(width: languageView.frame.width, height: 220)
        
        specialistView.delegate = self
        specialistView.promptText = "Specialization: "
        specialistView.placeholder = "Search"
        specialistView.descriptionText = "specialist"
        specialistView.maxTokenLimit = 1
        specialistView.style = .Rounded
        specialistView.shouldHideSearchResultsOnSelect = true
        specialistView.searchResultSize = CGSize(width: specialistView.frame.width, height: 220)
        
        cityView.delegate = self
        cityView.promptText = "City: "
        cityView.placeholder = "Search"
        cityView.descriptionText = "city"
        cityView.maxTokenLimit = 1
        cityView.style = .Rounded
        cityView.shouldHideSearchResultsOnSelect = true
        cityView.searchResultSize = CGSize(width: cityView.frame.width, height: 220)
        
        hospitalView.delegate = self
        hospitalView.promptText = "Hospital: "
        hospitalView.placeholder = "Search"
        hospitalView.descriptionText = "hospital"
        hospitalView.maxTokenLimit = 1
        hospitalView.style = .Rounded
        hospitalView.shouldHideSearchResultsOnSelect = true
        hospitalView.searchResultSize = CGSize(width: hospitalView.frame.width, height: 220)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.initComponents()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func tokenView(token: KSTokenView, performSearchWithString string: String, completion: ((results: Array<AnyObject>) -> Void)?) {
        var data: Array<String> = []
        var names = languages
        if token.descriptionText == "specialist" {
            names = specialists
        }else if token.descriptionText == "city" {
            names = cities
        }else if token.descriptionText == "hospital" {
            names = hospitals
        }
        
        for value: String in names {
            if value.lowercaseString.rangeOfString(string.lowercaseString) != nil {
                data.append(value)
            }
        }
        completion!(results: data)
    }
    
    func tokenViewDidBeginEditing(tokenView: KSTokenView) {
        if tokenView.descriptionText == "language" {
            self.view.frame.origin.y -= 80
        }else if tokenView.descriptionText == "specialist" {
            self.view.frame.origin.y -= 230
        }else if tokenView.descriptionText == "city" {
            self.view.frame.origin.y -= 300
        }else if tokenView.descriptionText == "hospital" {
            self.view.frame.origin.y -= 380
        }
    }
    
    func tokenViewDidEndEditing(tokenView: KSTokenView) {
        if tokenView.descriptionText == "language" {
            self.view.frame.origin.y += 80
        }else if tokenView.descriptionText == "specialist" {
            self.view.frame.origin.y += 230
        }else if tokenView.descriptionText == "city" {
            self.view.frame.origin.y += 300
        }else if tokenView.descriptionText == "hospital" {
            self.view.frame.origin.y += 380
        }
    }
    
    func tokenView(token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
    
    func doSomethingWithData(data: String) {
        genderButton.titleLabel?.text = data
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGenderPopup" {
            if let popupView = segue.destinationViewController as? GenderPopupViewController {
                if let popup = popupView.popoverPresentationController {
                    popup.delegate = self
                }
                
                popupView.onDataAvailable = {[weak self]
                    (data) in
                    if let weakSelf = self {
                        weakSelf.doSomethingWithData(data)
                    }
                }
            }
        }else if segue.identifier == "showSearchResultList" {
            SAInboxViewController.appearance.barTintColor = UIColor(red: 70/255, green: 136/255, blue: 241/255, alpha: 1)
            SAInboxViewController.appearance.tintColor = .whiteColor()
            SAInboxViewController.appearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            
            let destViewController = segue.destinationViewController as! UINavigationController
            destViewController.delegate = self
            let viewController: SearchListViewController = destViewController.viewControllers[0] as! SearchListViewController
            
            var gender = ""
            if genderButton.titleLabel?.text == "Female" {
                gender = "Female"
            }else if genderButton.titleLabel?.text == "Male" {
                gender = "Male"
            }
            var physicianType = "Family Medicine"
            if doctorTypeSwitchIndex == 1 {
                physicianType = getSelectedTokenTitle(specialistView.tokens()!)
            }
            let parameters = [
                "name": nameTextField.text!,
                "gender": gender,
                "language": getSelectedTokenTitle(languageView.tokens()!),
                "physicianType": physicianType,
                "location": getSelectedTokenTitle(cityView.tokens()!),
                "hospital": getSelectedTokenTitle(hospitalView.tokens()!)
            ]
            viewController.parameters = parameters
        }
    }
    
    func getSelectedTokenTitle(tokens: Array<KSToken>) -> String {
        var title = ""
        if tokens.count > 0 {
            title = tokens[0].title
        }
        return title
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    @IBAction func changeSelectedIndex(sender: IGSwitch) {
        doctorTypeSwitchIndex = sender.selectedIndex
    }
    
    @IBAction func search(sender: AnyObject) {
        
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SAInboxAnimatedTransitioningController.sharedInstance.setOperation(operation)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
}
