//
//  UIScreen+Extension.swift
//
//  Created by Cheng Zhang on 1/8/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

public extension UIScreen {
    public static var currSize: CGSize {
        return main.bounds.size
    }

    public static var currWidth: CGFloat {
        return currSize.width
    }

    public static var currHeight: CGFloat {
        return currSize.height
    }

}
