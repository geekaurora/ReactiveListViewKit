import Foundation

/// The protocol that defines the observer to observe the store state changes.
public protocol StoreObserver<StateType> {
  associatedtype StateType
  
  /// Gets notified with the current `state` and `previousState` when the store state changes.
  func storeDidUpdate(state: StateType,
                      previousState: StateType?)
}
