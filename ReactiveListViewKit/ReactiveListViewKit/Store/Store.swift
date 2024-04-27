import Foundation
import CZUtils

// MARK: - State

public protocol State {
  mutating func reduce(action: Action)
}

public protocol CopyableState: State, NSCopying {}

// MARK: - Action

public protocol Action {}

// MARK: - Store

/// The store that maintains the state and notifies the observers when the state changes.
///
/// - Note: The store only holds weak reference to observers, no need to explicitly call `unregisterObserver()` when deinit.
public class Store<StateType: CopyableState> {
  public private (set) var state: StateType {
    didSet {
      // Notify the observers when the state changes.
      publishStateChange()

      // Make a copy of the current state.
      previousState = state.copy() as? StateType
    }
  }
  public private (set) var previousState: StateType?

  // private var observers = ThreadSafeWeakArray<any StoreObserver<StateType>>(allowDuplicates: false)
  private var observers = [any StoreObserver<StateType>]()
  private let middlewares: [any Middleware<StateType>]

  public init(state: StateType,
              middlewares: [any Middleware<StateType>] = []) {
    self.state = state
    self.middlewares = middlewares
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
  public func registerObserver(_ observer: any StoreObserver<StateType>) {
    observers.append(observer)

    // Notify the `observer` with current `state` and `previousState`.
    observer.storeDidUpdate(state: state, previousState: previousState)
  }

  /// UnregisterObservers the `observer` from observing the state changes.
  public func unregisterObserver(_ observer: any StoreObserver<StateType>) {
    observers.remove(observer)
  }

  // MARK: - Actions

  /// Dispatches the  `action` to the store which updates the state correspondingly and notifies the observers with the state change .
  public func dispatch(action: Action) {
    dbgPrintWithFunc(self, "\(action)")

    middlewares.forEach {
      $0.process(action: action, state: state)
    }

    // Update the state and notifies the observers with the state change.
    // - Note: It will set a new state to self and trigger `publishStateChange()`, because the
    // identifier for `reduce(action:)` of `State` protocol is `mutating`.
    self.state.reduce(action: action)
  }
}
