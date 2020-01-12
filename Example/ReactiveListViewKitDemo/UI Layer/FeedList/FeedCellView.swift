//
//  FeedCellView.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 1/4/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit
import SDWebImage

/**
 Content view of `FeedCell`, composed of various subviews corresponding to elements contained by `FeedCellViewModel`
 */
class FeedCellView: CZNibLoadableView, CZFeedCellViewSizeCalculatable {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var userInfoStackView: UIStackView!
    @IBOutlet var contentStackView: UIStackView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var portaitView: UIImageView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var bottomDivider: UIView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var likeStackView: UIStackView!
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var userActionContainerView: UIView!
    @IBOutlet var stackViewWidthConstraint: NSLayoutConstraint!

    private var viewModel: FeedCellViewModel    
    var diffId: String { return viewModel.diffId }
    var onAction: OnAction?
    static let imageRatio: CGFloat = 1.0

    required init(viewModel: CZFeedViewModelable?, onAction: OnAction?) {
        guard let viewModel = viewModel as? FeedCellViewModel else {
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

    func config(with viewModel: CZFeedViewModelable?, containerSize: CGSize) {
        guard let viewModel = viewModel as? FeedCellViewModel else {
            fatalError("Incorrect ViewModel type.")
        }
        self.viewModel = viewModel

        if let portraitUrl = viewModel.portraitUrl {
            portaitView.sd_setImage(with: portraitUrl)
            portaitView.roundToCircleWithFrame()
        }
        if let imageUrl = viewModel.imageUrl {
            imageView.sd_setImage(with: imageUrl)
        }
        contentLabel.preferredMaxLayoutWidth = containerSize.width
        userNameLabel.text = viewModel.userName
        contentLabel.text = viewModel.content
        likesLabel.text = "\(viewModel.likesCount) likes"

        likeButton.setTitle("", for: .normal)
        likeButton.setImage(UIImage(named: viewModel.userHasLiked ? "Liked" : "Like"), for: .normal)
        bottomDivider.isHidden = !viewModel.isInFeedDetails
        stackViewWidthConstraint.constant = UIScreen.currWidth    
    }

    static func sizeThatFits(_ containerSize: CGSize, viewModel: CZFeedViewModelable) -> CGSize {
        return CZFacadeViewHelper.sizeThatFits(containerSize,
                                               viewModel: viewModel,
                                               viewClass: FeedCellView.self)
    }
    
    func config(with viewModel: CZFeedViewModelable?) {}
}

// MARK: - Private methods

private extension FeedCellView {
    @IBAction func tappedLike(_ sender: UIButton) {
        let action = LikeFeedAction(feed: viewModel.feed)
        onAction?(action)
    }
}
