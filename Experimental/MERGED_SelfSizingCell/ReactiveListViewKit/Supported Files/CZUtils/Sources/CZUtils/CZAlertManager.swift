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
                            confirmText: String = "Ok",
                            confirmHandler: ((UIAlertAction) -> Void)? = nil,
                            cancelText: String? = nil,
                            cancelHandler: ((UIAlertAction) -> Void)? = nil,
                            on viewController: UIViewController? = nil,
                            completion: (() -> Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action1 = UIAlertAction(title: confirmText, style: .default, handler: confirmHandler)
    alertController.addAction(action1)
    if let cancelText = cancelText {
      let action2 = UIAlertAction(title: cancelText, style: .cancel, handler: cancelHandler)
      alertController.addAction(action2)
    }
    
    guard let presentingViewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController else {
      assertionFailure("Couldn't find valid presenting ViewController.")
      return
    }
    presentingViewController.topMost.present(alertController, animated: true, completion: completion)
  }
  
}
