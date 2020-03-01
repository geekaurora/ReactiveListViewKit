//
//  UIViewController+Addtion.swift
//
//  Created by Cheng Zhang on 4/19/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

public extension UIViewController {
    /// Stick the intput view's edges to topLayoutGuide, bottomLayoutGuide, leading, trailing
  func overlapSubViewOnSelf(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    var topMost: UIViewController {
        var currVC: UIViewController = self
        while let presentedVC = currVC.presentedViewController {
            currVC = presentedVC
        }
        return currVC
    }
    
  func showTitleOnNavBar() {
        let internalTitleView: UIView
        if let image = UIImage(named: "InstagramTitle") {
            internalTitleView = UIImageView(image: image)
        } else {
            let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            titleView.textAlignment = .center
            titleView.text = "Instagram"
            titleView.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 25)
            titleView.textColor = UIColor(white: 0.22, alpha: 1)
            internalTitleView = titleView
        }
        navigationItem.titleView = internalTitleView
    }
    
  func setTabTitle(_ title: String, at index: Int) {
        guard let tabBarItems = tabBarController?.tabBar.items,
            0..<tabBarItems.count ~= index else { return }
        tabBarItems[index].title = NSLocalizedString(title, comment: "")
    }
}


