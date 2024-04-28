import Foundation

/// The protocol that defines the middleware to process the actions of the store.
///
/// - Note: MiddlewareProtocol will be called for each action.
public protocol MiddlewareProtocol<StateType> {
  associatedtype StateType

  /// Processes the `action` of the store with the current `state`.
  func process(action: CZActionProtocol,
               state: StateType)
}
