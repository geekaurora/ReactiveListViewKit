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

  public func subscribe(_ subscriber: any Subscriber<StateType>,
                        selector: ((StateType) -> Any)? = nil) {
//    let subscription = Subscription(subscriber: subscriber, selector: selector)
//    self.subscriptions.append(subscription)

    subscribers.append(subscriber)
    // subscription.notify(with: self.state, prevState: self.prevState)
  }

  public func remove(subscriber: any Subscriber<StateType>) {
    subscribers.remove(subscriber)
  }

  // MARK: - Actions

  public func dispatch(action: Action) {
    let actionString = String(describing: action).components(separatedBy: "\n").first
    dbgPrint("Reactor - Fired action: \(actionString!)")
    self.state.reduce(action: action)
    let state = self.state
    self.middlewares.forEach { $0.middleware._process(action: action, state: state) }
  }
}
