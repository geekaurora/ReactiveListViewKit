//
//  HotUserCellView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 3/4/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit

class HotUserCellCardView: CZNibLoadableView, CZFeedCellViewSizeCalculatable {
    @IBOutlet var frameView: UIView?
    @IBOutlet var contentView: UIView?
    @IBOutlet var stackView: UIStackView?
    @IBOutlet var portaitView: UIImageView?
    
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var detailsLabel: UILabel?
    @IBOutlet var followButton: UIButton?
    @IBOutlet var closeButton: UIButton?
    
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
        backgroundColor = .white
        config(with: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Must call designated initializer `init(viewModel:onEvent:)`")
    }
    
    func config(with viewModel: CZFeedViewModelable?) {
        guard let viewModel = viewModel as? HotUserCellViewModel else {
            fatalError("Incorrect ViewModel type.")
        }
        if let portraitUrl = viewModel.portraitUrl {
            portaitView?.sd_setImage(with: portraitUrl)
            portaitView?.roundToCircleWithFrame()
        }
        detailsLabel?.text = viewModel.fullName
        nameLabel?.text = ""

        followButton?.roundCorner(cornerRadius: 2)
        closeButton?.roundCorner(cornerRadius: 2)
        frameView?.roundCornerWithFrame(cornerRadius: 2)
    }
    
    func config(with viewModel: CZFeedViewModelable?, prevViewModel: CZFeedViewModelable?) {}
    
    static func sizeThatFits(_ containerSize: CGSize, viewModel: CZFeedViewModelable) -> CGSize {
        return CZFacadeViewHelper.sizeThatFits(containerSize,
                                                   viewModel: viewModel,
                                                   viewClass: HotUserCellCardView.self,
                                                   isHorizontal: true)
    }
    
    @IBAction func tappedFollow(_ sender: UIButton) {
        onEvent?(SuggestedUserEvent.follow(user: viewModel.user))
    }
    
    @IBAction func tappedClose(_ sender: UIButton) {
        onEvent?(SuggestedUserEvent.ignore(user: viewModel.user))
    }
    
}
