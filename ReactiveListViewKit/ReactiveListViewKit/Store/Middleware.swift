import Foundation

/// The  protocol that defines the middleware to process the actions of the store.
///
/// - Note: Middleware will be called for each action.
public protocol Middleware<StateType> {
  associatedtype StateType

  /// Processes the `action` of the store with the current `state`.
  func process(action: Action,
               state: StateType)
}
