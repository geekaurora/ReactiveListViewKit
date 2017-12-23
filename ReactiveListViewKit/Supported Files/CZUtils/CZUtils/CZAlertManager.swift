//
//  CZAlertManager.swift
//
//  Created by Cheng Zhang on 1/15/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

/// Convenient helper class for AlertViewController displaying 
open class CZAlertManager: NSObject {
    open class func showAlert(title: String? = nil,
                         message: String,
                         actionText1: String = "Ok",
                         actionHandler1: ((UIAlertAction) -> Void)? = nil,
                         on viewController: UIViewController? = nil,
                         completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionText1, style: .default, handler: actionHandler1)
        alertController.addAction(action)
        guard let presentingViewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController else {
            assertionFailure("Couldn't find valid presenting ViewController.")
            return
        }
        presentingViewController.topMost.present(alertController, animated: true, completion: completion)
    }
}
