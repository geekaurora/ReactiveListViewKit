import Foundation
import CZUtils

public class Store<StateType: CopyableState> {
  public private (set) var state: StateType {
    didSet {
      notifyStateChange()

      prevState = state.copy() as? StateType
    }
  }
  public private (set) var prevState: StateType?

  private var subscribers = ThreadSafeWeakArray<any Subscriber<StateType>>(allowDuplicates: false)
  private let middlewares: [Middlewares<StateType>]

  public init(state: StateType,
              middlewares: [AnyMiddleware] = []) {
    self.state = state
    self.middlewares = middlewares.map(Middlewares.init)
  }

  // MARK: - Publish

  public func notifyStateChange() {
    subscribers.allObjects.forEach { $0.update(with: state, prevState: prevState) }
  }

  // MARK: - Subscriptions

  public func subscribe(_ subscriber: any Subscriber<StateType>) {
    subscribers.append(subscriber)

    // Notify the `subscriber` with `state` and `prevState`.
    subscriber.update(with: state, prevState: prevState)
  }

  public func remove(subscriber: any Subscriber<StateType>) {
    subscribers.remove(subscriber)
  }

  // MARK: - Actions

  public func dispatch(action: Action) {
    dbgPrintWithFunc(self, "\(action)")

    state.reduce(action: action)
    middlewares.forEach { $0.middleware._process(action: action, state: state) }
  }
}
