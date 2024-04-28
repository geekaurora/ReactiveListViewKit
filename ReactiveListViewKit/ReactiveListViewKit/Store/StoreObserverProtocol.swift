import Foundation

/// The protocol that defines the observer to observe the store state changes.
public protocol StoreObserverProtocol<StateType> {
  associatedtype StateType
  
  /// Gets notified with the current `state` and `previousState` when the store state changes.
  func storeDidUpdate(state: StateType,
                      previousState: StateType?)

  /// Gets notified with a dispatched action.
  func didReceiveStoreAction(_ action: CZActionProtocol)
}

public extension StoreObserverProtocol {
  func didReceiveStoreAction(_ action: CZActionProtocol) {
    // No-op.
  }
}
