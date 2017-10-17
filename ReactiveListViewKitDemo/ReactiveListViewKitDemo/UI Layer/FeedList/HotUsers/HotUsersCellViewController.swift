//
//  HotUsersCellViewController.swift
//  CZInstagram
//
//  Created by Cheng Zhang on 3/28/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import CZUtils
import ReactiveListViewKit

class HotUsersCellViewController: UIViewController, CZFeedCellViewSizeCalculatable {
    var diffId: String {
        return viewModel.diffId
    }
    fileprivate var viewModel: HotUsersCellViewModel
    var onEvent: OnEvent?
    fileprivate var containerStackView: UIStackView!
    fileprivate var sectionHeaderView: CZFeedListSupplementaryTextView!
    fileprivate var horizontalListView: CZHorizontalSectionAdapterView!
    fileprivate static let headerTitle = "Suggestions for you"
    fileprivate static let seeAllText = "See All"
    fileprivate static let suggestedUsersSectionViewBGColor = UIColor(white: 250.0 / 255.0, alpha: 1)
    
    required init(viewModel: CZFeedViewModelable?, onEvent: OnEvent?) {
        self.viewModel = viewModel as! HotUsersCellViewModel
        self.onEvent = onEvent
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Must call designated initializer init(viewMode:onEvent:).")
    }
    
    func config(with viewModel: CZFeedViewModelable?) {
        guard let viewModel = viewModel as? HotUsersCellViewModel else {preconditionFailure()}
        let feedModels = viewModel.users.flatMap { user in
            CZFeedModel(viewClass: HotUserCellCardView.self,
                        viewModel: HotUserCellViewModel(user))
        }
        let horizontalListViewModel = CZHorizontalSectionAdapterViewModel(feedModels, viewHeight: 200)
        horizontalListView?.config(with: horizontalListViewModel)
    }
    
    static func sizeThatFits(_ containerSize: CGSize, viewModel: CZFeedViewModelable) -> CGSize {
        let size = CZFacadeViewHelper.sizeThatFits(containerSize,
                                                   viewModel: viewModel,
                                                   viewClass: HotUsersCellViewController.self)
        return size
    }
    
    func config(with viewModel: CZFeedViewModelable?, prevViewModel: CZFeedViewModelable?) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        config(with: viewModel)
    }
}

fileprivate extension HotUsersCellViewController {
    func setupViews () {
        view.backgroundColor = HotUsersCellViewController.suggestedUsersSectionViewBGColor

        // containerStackView
        containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = 5
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.overlayOnSuperview(view)
        
        // headerView
        let sectionHeaderViewModel = CZFeedListSupplementaryTextViewModel(title: HotUsersCellViewController.headerTitle,
                                                                          actionButtonText: HotUsersCellViewController.seeAllText,
                                                                          actionButtonClosure: { button in
                                                                            print("Tapped SeeAll button")
        }, inset: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) )
        sectionHeaderView = CZFeedListSupplementaryTextView(viewModel: sectionHeaderViewModel,
                                                            onEvent: onEvent)
        
        // horizontalListView
        horizontalListView = CZHorizontalSectionAdapterView(onEvent: onEvent)
        horizontalListView.heightAnchor.constraint(equalToConstant: HotUserSection.userCardSize.height).isActive = true
        
        let arrangedSubViews: [UIView] = [CZDividerView(),
                                          sectionHeaderView,
                                          horizontalListView,
                                          CZDividerView()]
        arrangedSubViews.forEach{ containerStackView.addArrangedSubview($0) }
    }
}


