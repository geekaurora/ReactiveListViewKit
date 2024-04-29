import Foundation
import CZUtils

// MARK: - State

public protocol StateProtocol {
  func reduce(action: CZActionProtocol) -> Self
}

public protocol CopyableStateProtocol: StateProtocol, NSCopying {}

// MARK: - Action

public protocol CZActionProtocol {}

// MARK: - Store

/// The store that maintains the state and notifies the observers when the state changes.
///
/// - Note: The store only holds weak reference to observers, no need to explicitly call `unregisterObserver()` when deinit.
public class Store<StateType: CopyableStateProtocol> {
  public private (set) var state: StateType {
    didSet {
      // Notify the observers when the state changes.
      publishStateChange()

      // Make a copy of the current state.
      previousState = state.copy() as? StateType
    }
  }
  public private (set) var previousState: StateType?

  /// The observers of the store that get notified when the state changes.
  private var observers: [any StoreObserverProtocol<StateType>] {
    return (_observers.allObjects as? [any StoreObserverProtocol<StateType>]).assertIfNil ?? []
  }
  /// - Note: If defined as `ThreadSafeWeakArray<any StoreObserverProtocol<StateType>>`, it only appends nil when calling `observers.append()`.
  private var _observers = ThreadSafeWeakArray<Any>(allowDuplicates: false)

  public init(state: StateType) {
    self.state = state
  }

  // MARK: - Publish State

  /// Notifies the observers when the state changes.
  public func publishStateChange() {
    observers.forEach {
      $0.storeDidUpdate(state: state, previousState: previousState)
    }
  }

  // MARK: - Observers

  /// Registers `observer` to observe the state changes.
  public func registerObserver(_ observer: any StoreObserverProtocol<StateType>) {
    _observers.append(observer)

    // Notify the `observer` with current `state` and `previousState`.
    observer.storeDidUpdate(state: state, previousState: previousState)
  }

  /// Unregisters the `observer` from observing the state changes.
  public func unregisterObserver(_ observer: any StoreObserverProtocol<StateType>) {
    _observers.remove(observer)
  }

  // MARK: - Actions

  /// Dispatches the  `action` to the store which updates the state correspondingly and notifies the observers with the state change .
  public func dispatch(action: CZActionProtocol) {
    dbgPrintWithFunc(self, "\(action)")

    // Notify the observers with the `action`.
    observers.forEach {
      $0.didReceiveStoreAction(action)
    }

    // Update the state and notifies the observers with the state change.
    // - Note: It will set a new state to self and trigger `publishStateChange()`.
    let newState = state.reduce(action: action)
    switch(action) {
    case CZFeedListViewAction.loadMore:
      break
    default:
      self.state = newState
    }
  }
}
