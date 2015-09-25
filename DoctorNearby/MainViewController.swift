//
//  MainViewController
//  DoctorNearby
//
//  Created by Vince Zhang on 2015-09-23.
//  Copyright © 2015 AkhalTech. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let bc: ButtonCreater = ButtonCreater()
        let testButton = bc.generateButtons(self.view.frame.width - 56 - 16, yPosition: self.view.frame.height - 56 - 16)
        self.view.addSubview(testButton)
        
        let lc: LoaderCreater = LoaderCreater()
        let testLoader = lc.generateLoader(self.view.frame.width * 0.5 - 50, yPosition: self.view.frame.height * 0.5 - 25)
        self.view.addSubview(testLoader)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

}

