//
//  HotUserCellView.swift
//  CZInstagram
//
//  Created by Cheng Zhang on 3/4/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit
import CZUtils
import ReactiveListViewKit
import SDWebImage

enum HotUserSection {
    static let heightForHorizontal: CGFloat = 76
    static let userCardSize = CGSize(width: 100, height: 147)
}

class HotUserCellView: CZNibLoadableView, CZFeedCellViewSizeCalculatable {
    @IBOutlet var frameView: UIView?
    @IBOutlet var contentView: UIView?
    @IBOutlet var stackView: UIStackView?
    @IBOutlet var portaitView: UIImageView?

    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var detailsLabel: UILabel?
    
    fileprivate var viewModel: HotUserCellViewModel    
    var diffId: String {return viewModel.diffId}
    var onEvent: OnEvent?

    required init(viewModel: CZFeedViewModelable?, onEvent: OnEvent?) {
        guard let viewModel = viewModel as? HotUserCellViewModel else {
            fatalError("Incorrect ViewModel type.")
        }
        self.viewModel = viewModel
        self.onEvent = onEvent
        super.init(frame: .zero)
        config(with: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Should invoke designated initializer `init(viewModel:onEvent:)`")
    }

    func config(with viewModel: CZFeedViewModelable?) {
        guard let viewModel = viewModel as? HotUserCellViewModel else {
            fatalError("Incorrect ViewModel type.")
        }
        if let portraitUrl = viewModel.portraitUrl {
            portaitView?.sd_setImage(with: portraitUrl)
            portaitView?.roundToCircleWithFrame()
        }
        nameLabel?.text = viewModel.userName
        detailsLabel?.text = viewModel.fullName
        
        frameView?.roundCornerWithFrame(cornerRadius: 2)
    }

    static func sizeThatFits(_ containerSize: CGSize, viewModel: CZFeedViewModelable) -> CGSize {
        return CZFacadeViewHelper.sizeThatFits(containerSize,
                                               viewModel: viewModel,
                                               viewClass: HotUserCellView.self,
                                               isHorizontal: true)
    }
    
    func config(with viewModel: CZFeedViewModelable?, prevViewModel: CZFeedViewModelable?) {}
}


