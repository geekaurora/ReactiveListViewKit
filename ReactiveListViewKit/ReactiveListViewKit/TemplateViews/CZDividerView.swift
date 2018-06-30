//
//  CZDividerView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/16/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Convenience divider view class
public final class CZDividerView: UIView {
    fileprivate let size: CGFloat
    fileprivate let bgColor: UIColor
    
    public init(size: CGFloat = 1,
         backgroudColor: UIColor = ReactiveListViewKit.GreyDividerColor) {
        self.size = size
        self.bgColor = backgroudColor
        super.init(frame: .zero)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("Must call designated initializer.")
    }
}

fileprivate extension CZDividerView {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = self.bgColor
        let sizeContrait = heightAnchor.constraint(equalToConstant: size)
        sizeContrait.priority = UILayoutPriority(rawValue: 749)
        sizeContrait.isActive = true
    }
}
