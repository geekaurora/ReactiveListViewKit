//
//  ReactiveListViewKitConstants.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/2/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/**
 Constants of ReactiveListViewKit
 */
public enum ReactiveListViewKit {
    public static var isDebugMode = true
    public static var isIncrementalUpdateEnabled = true
    public static var useGCD = false

    public static let ClearBGColor = UIColor.clear
    public static let GreyBGColor = UIColor(white: 240.0 / 255.0, alpha: 1.0)
    public static let GreyDividerColor = UIColor(white: 217.0 / 255.0, alpha: 1.0)
    public static let minimumLineSpacing: CGFloat = 10
    public static let minimumInteritemSpacing: CGFloat = 10
    public static let sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    
    public enum FeedListSupplementaryTextView {
        public static let inset =  UIEdgeInsets(top: 8, left: 10, bottom: 3, right: 10)
        public static let titleFont =  UIFont.boldSystemFont(ofSize: 14)
        public static let titleColor = UIColor(white: 0.1, alpha: 1)
        public static let actionButtonColor = UIColor(red: 62.0 / 255.0, green: 153 / 255.0, blue: 237 / 255.0, alpha: 1)
    }
    
    public static let horizontalSectionAdapterViewBGColor: UIColor = .clear
    
    public static let feedListSupplementaryLineHeaderViewInset =  UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    public static let feedListSupplementaryLineFooterViewInset =  UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
}
