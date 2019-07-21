//
//  CZFeedListViewStateMachine.swift
//  ReactiveListViewKit
//
//  Created by Cheng Zhang on 2/25/17.
//  Copyright © 2017 Cheng Zhang. All rights reserved.
//

import UIKit

/// Elegant State Machine for `CZFeedListFacadeView`
public class CZFeedListViewStateMachine {
    public enum State {
        case `init`
        case error
        case loading
        case showingViewModels
        case showingMoreViewModels
        /// Pull to refresh
        case requestingViewModelsDueToPTR
        case requestingAutoRefresh
        case requestingMoreViewModels
        case requestingMoreViewModelsError
    }
    public enum Action {
        case resetingViewModels
        case appendingViewModels
        case requestingMoreViewModels
        case autoRefreshingViewModels
        case showingErrorScreen
        case userPulledToRefresh
        case userRequestedRetry
        case showingLoadingScreen
    }
    private(set) var state: State
    
    public init(state: State = .`init`) {
        self.state = state
    }
    
    public func sendEvent(_ action: Action) {
        switch action {
        case .resetingViewModels:
            state = .showingViewModels
        case .appendingViewModels:
            state = .showingMoreViewModels
        case .requestingMoreViewModels:
            state = .requestingMoreViewModels
        case .showingErrorScreen:
            state = (state == .requestingMoreViewModels) ? .requestingMoreViewModelsError : .error
        case .userPulledToRefresh:
            state = .requestingViewModelsDueToPTR
        case .userRequestedRetry:
            switch state {
            case .requestingMoreViewModelsError:
                state = .requestingMoreViewModels
            case .error:
                state = .loading
            default:
                break
            }
        case .showingLoadingScreen:
            if state != .requestingViewModelsDueToPTR {
                state = .loading
            }
        case .autoRefreshingViewModels:
            state = .requestingAutoRefresh
        }
    }
}
