//
//  HotUserCellView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 3/4/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit
import CZWebImage

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
    
    private var viewModel: HotUserCellViewModel    
    var diffId: String {return viewModel.diffId}
    var onAction: OnAction?

    required init(viewModel: CZFeedViewModelable?, onAction: OnAction?) {
        guard let viewModel = viewModel as? HotUserCellViewModel else {
            fatalError("Incorrect ViewModel type.")
        }
        self.viewModel = viewModel
        self.onAction = onAction
        super.init(frame: .zero)
        config(with: viewModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Must call designated initializer `init(viewModel:onAction:)`")
    }

    func config(with viewModel: CZFeedViewModelable?) {
        guard let viewModel = viewModel as? HotUserCellViewModel else {
            fatalError("Incorrect ViewModel type.")
        }
        if let portraitUrl = viewModel.portraitUrl {
            portaitView?.cz_setImage(with: portraitUrl)
            portaitView?.roundToCircle()
        }
        nameLabel?.text = viewModel.userName
        detailsLabel?.text = viewModel.fullName
        
        frameView?.roundCorner(2)
    }

    static func sizeThatFits(_ containerSize: CGSize, viewModel: CZFeedViewModelable) -> CGSize {
        return CZFacadeViewHelper.sizeThatFits(containerSize,
                                               viewModel: viewModel,
                                               viewClass: HotUserCellView.self,
                                               isHorizontal: true)
    }
    
    func config(with viewModel: CZFeedViewModelable?, prevViewModel: CZFeedViewModelable?) {}
}


