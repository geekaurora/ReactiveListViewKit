//
//  CZTheme.swift
//
//  Created by Cheng Zhang on 4/18/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

/// Common theme settings for projects
public struct CZTheme {
    public static let greyDividerColor: CGFloat = 217.0 / 255.0
}

public extension UIColor {
    public static let candyGreen = UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    public static let facebookBlue = UIColor(red: 68.0/255.0, green: 105.0/255.0, blue: 176.0/255.0, alpha: 1.0)
    public static let dividerGrey = UIColor(white: CZTheme.greyDividerColor, alpha: 1)
    public static let searchBarColor = UIColor(white: 217.0 / 255.0, alpha: 1)
    public static let searchBarTextGrey = UIColor(white: 127.0 / 255.0, alpha: 1)
    public static let tabBarTintColor = UIColor(white: 250.0 / 255.0, alpha: 1)
    public static let tabBarItemTintColor = UIColor(white: 38.0 / 255.0, alpha: 1)
}
