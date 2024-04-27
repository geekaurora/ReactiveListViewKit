import Foundation

public class Store<StateType: CopyableState> {
  public private (set) var prevState: StateType?

  public private (set) var state: StateType {
    didSet {
      subscriptions = subscriptions.filter { $0.subscriber != nil }
      for subscription in subscriptions {
        subscription.notify(with: state, prevState: prevState)
      }
      prevState = state.copy() as? StateType

    }
  }

  private var _subscriptions = [Subscription<StateType>]()
  private var subscriptions: [Subscription<StateType>] {
    get {
      return self._subscriptions
    }
    set {
      self._subscriptions = newValue
    }
  }
  private let middlewares: [Middlewares<StateType>]

  public init(state: StateType,
              middlewares: [AnyMiddleware] = []) {
    self.state = state
    self.middlewares = middlewares.map(Middlewares.init)
  }

  // MARK: - Publish

  public func notifyStateChange() {
    subscriptions.forEach { $0.notify(with: state, prevState: prevState) }
  }

  // MARK: - Subscriptions

  public func subscribe(_ subscriber: AnySubscriber,
                        notifyOnQueue queue: DispatchQueue? = DispatchQueue.main,
                        selector: ((StateType) -> Any)? = nil) {
    guard !self.subscriptions.contains(where: {$0.subscriber === subscriber}) else { return }
    let subscription = Subscription(subscriber: subscriber, selector: selector)
    self.subscriptions.append(subscription)
    subscription.notify(with: self.state, prevState: self.prevState)
  }

  public func remove(subscriber: AnySubscriber) {
    subscriptions = subscriptions.filter { $0.subscriber !== subscriber }
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
