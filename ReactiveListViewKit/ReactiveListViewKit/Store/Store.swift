import Foundation
import CZUtils

public class Store<StateType: CopyableState> {
  public private (set) var state: StateType {
    didSet {
      publishStateChange()

      previousState = state.copy() as? StateType
    }
  }
  public private (set) var previousState: StateType?

  private var observers = ThreadSafeWeakArray<any StoreObserver<StateType>>(allowDuplicates: false)
  private let middlewares: [Middlewares<StateType>]

  public init(state: StateType,
              middlewares: [AnyMiddleware] = []) {
    self.state = state
    self.middlewares = middlewares.map(Middlewares.init)
  }

  // MARK: - Publish

  public func publishStateChange() {
    observers.allObjects.forEach { $0.storeDidUpdate(state: state, previousState: previousState) }
  }

  // MARK: - Subscriptions

  public func registerObserver(_ observer: any StoreObserver<StateType>) {
    observers.append(observer)

    // Notify the `observer` with `state` and `previousState`.
    observer.storeDidUpdate(state: state, previousState: previousState)
  }

  public func unregisterObserver(_ observer: any StoreObserver<StateType>) {
    observers.remove(observer)
  }

  // MARK: - Actions

  public func dispatch(action: Action) {
    dbgPrintWithFunc(self, "\(action)")

    state.reduce(action: action)
    middlewares.forEach { $0.middleware._process(action: action, state: state) }
  }
}
