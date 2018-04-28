//
//  ProgressLoader.swift
//  testTask
//
//  Created by Mac on 4/27/18.
//  Copyright © 2018 kovtuns. All rights reserved.
//

import Foundation
import SVProgressHUD

class ProgressLoader: NSObject {
    class func show(title: String = "Loading...") {
        SVProgressHUD.show(withStatus: title)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    class func hide(withCompletion completion: @escaping SVProgressHUDDismissCompletion) {
        SVProgressHUD.dismiss(completion: completion)
    }
    
    class func hide() {
        SVProgressHUD.dismiss()
    }
}
